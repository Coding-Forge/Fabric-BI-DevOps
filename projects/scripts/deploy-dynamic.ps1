[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$Branch,

    [Parameter(Mandatory = $true)]
    [string]$TenantId,

    [Parameter(Mandatory = $true)]
    [string]$AppId,

    [Parameter(Mandatory = $true)]
    [string]$ClientSecret,

    [string]$DevWorkspaceId,

    [string]$DevWorkspaceName,

    [string]$FeatureWorkspacePrefix,

    [Parameter(Mandatory = $true)]
    [string]$PbipPath
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$script:FabricBaseUri = 'https://api.fabric.microsoft.com/v1'
$script:FabricHeaders = $null

function ConvertTo-SafeDisplayName {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Value
    )

    $safeName = $Value -replace '^refs/heads/', ''
    $safeName = $safeName -replace '[^A-Za-z0-9._-]+', '-'
    $safeName = $safeName.Trim('-')

    if ([string]::IsNullOrWhiteSpace($safeName)) {
        return 'workspace'
    }

    return $safeName
}

function Get-FabricAccessToken {
    param(
        [Parameter(Mandatory = $true)]
        [string]$TenantId,

        [Parameter(Mandatory = $true)]
        [string]$ClientId,

        [Parameter(Mandatory = $true)]
        [string]$Secret
    )

    $tokenUri = "https://login.microsoftonline.com/$TenantId/oauth2/v2.0/token"
    $body = @{
        client_id = $ClientId
        client_secret = $Secret
        grant_type = 'client_credentials'
        scope = 'https://api.fabric.microsoft.com/.default'
    }

    Write-Host 'Authenticating to Microsoft Fabric REST API.'
    $response = Invoke-RestMethod -Method Post -Uri $tokenUri -Body $body -ContentType 'application/x-www-form-urlencoded'
    return $response.access_token
}

function Invoke-FabricApi {
    param(
        [Parameter(Mandatory = $true)]
        [ValidateSet('Get', 'Post', 'Patch', 'Delete')]
        [string]$Method,

        [Parameter(Mandatory = $true)]
        [string]$Path,

        [object]$Body,

        [switch]$ReturnResponse
    )

    $uri = if ($Path.StartsWith('https://', [System.StringComparison]::OrdinalIgnoreCase)) {
        $Path
    }
    else {
        "$script:FabricBaseUri/$($Path.TrimStart('/'))"
    }

    $parameters = @{
        Method = $Method
        Uri = $uri
        Headers = $script:FabricHeaders
        ContentType = 'application/json'
    }

    if ($PSBoundParameters.ContainsKey('Body')) {
        $parameters.Body = ($Body | ConvertTo-Json -Depth 100)
    }

    try {
        $response = Invoke-WebRequest @parameters -UseBasicParsing
        $responseBody = $null

        if (![string]::IsNullOrWhiteSpace($response.Content)) {
            $responseBody = $response.Content | ConvertFrom-Json
        }

        if ($ReturnResponse) {
            return [pscustomobject]@{
                StatusCode = $response.StatusCode
                Headers = $response.Headers
                Body = $responseBody
            }
        }

        return $responseBody
    }
    catch {
        $responseBody = $null
        if ($_.Exception.Response -and $_.Exception.Response.GetResponseStream()) {
            $reader = [System.IO.StreamReader]::new($_.Exception.Response.GetResponseStream())
            $responseBody = $reader.ReadToEnd()
        }

        if ($responseBody) {
            throw "Fabric API request failed: $Method $uri`n$responseBody"
        }

        throw
    }
}

function Wait-FabricOperation {
    param(
        [string]$OperationUri
    )

    if ([string]::IsNullOrWhiteSpace($OperationUri)) {
        return
    }

    Write-Host "Waiting for Fabric operation: $OperationUri"

    while ($true) {
        $operation = Invoke-FabricApi -Method Get -Path $OperationUri
        $status = $operation.status

        if ($status -in @('Succeeded', 'Completed')) {
            return
        }

        if ($status -in @('Failed', 'Cancelled')) {
            throw "Fabric operation ended with status '$status': $($operation | ConvertTo-Json -Depth 20)"
        }

        Start-Sleep -Seconds 5
    }
}

function Wait-FabricResponseOperation {
    param(
        [Parameter(Mandatory = $true)]
        [pscustomobject]$Response
    )

    $operationUri = $null

    foreach ($headerName in @('Location', 'Operation-Location', 'x-ms-operation-location')) {
        if ($Response.Headers.ContainsKey($headerName)) {
            $operationUri = $Response.Headers[$headerName]
            break
        }
    }

    Wait-FabricOperation -OperationUri $operationUri
}

function Get-FabricWorkspaceByName {
    param(
        [Parameter(Mandatory = $true)]
        [string]$DisplayName
    )

    $workspaces = Invoke-FabricApi -Method Get -Path 'workspaces'
    return @($workspaces.value) | Where-Object { $_.displayName -eq $DisplayName } | Select-Object -First 1
}

function New-FabricWorkspace {
    param(
        [Parameter(Mandatory = $true)]
        [string]$DisplayName
    )

    Write-Host "Creating Fabric workspace: $DisplayName"
    return Invoke-FabricApi -Method Post -Path 'workspaces' -Body @{ displayName = $DisplayName }
}

function Resolve-TargetWorkspaceId {
    if ($Branch -like 'refs/heads/feature/*') {
        if ([string]::IsNullOrWhiteSpace($FeatureWorkspacePrefix)) {
            throw 'FeatureWorkspacePrefix is required for feature branch deployment.'
        }

        $branchName = ConvertTo-SafeDisplayName -Value ($Branch -replace '^refs/heads/feature/', '')
        $workspaceName = "$FeatureWorkspacePrefix-$branchName"
        $workspace = Get-FabricWorkspaceByName -DisplayName $workspaceName

        if ($workspace) {
            Write-Host "Using existing feature workspace '$workspaceName' ($($workspace.id))."
            return $workspace.id
        }

        $workspace = New-FabricWorkspace -DisplayName $workspaceName
        Write-Host "Created feature workspace '$workspaceName' ($($workspace.id))."
        return $workspace.id
    }

    if (![string]::IsNullOrWhiteSpace($DevWorkspaceName)) {
        $workspace = Get-FabricWorkspaceByName -DisplayName $DevWorkspaceName
        if (!$workspace) {
            throw "Dev workspace '$DevWorkspaceName' was not found or is not visible to the service principal. Confirm the service principal is added to that workspace."
        }

        Write-Host "Using Dev workspace '$DevWorkspaceName' ($($workspace.id))."
        return $workspace.id
    }

    if (![string]::IsNullOrWhiteSpace($DevWorkspaceId)) {
        Write-Host "Using Dev workspace ID: $DevWorkspaceId"
        return $DevWorkspaceId
    }

    throw 'DevWorkspaceName or DevWorkspaceId is required for Dev deployment.'
}

function Get-PbipProjectRoot {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Path
    )

    $resolvedPath = (Resolve-Path -Path $Path).Path

    if (Test-Path -Path $resolvedPath -PathType Leaf) {
        if ([System.IO.Path]::GetExtension($resolvedPath) -ne '.pbip') {
            throw "Expected a .pbip file or project directory, got: $resolvedPath"
        }

        return Split-Path -Parent $resolvedPath
    }

    return $resolvedPath
}

function Get-PbipItemFolders {
    param(
        [Parameter(Mandatory = $true)]
        [string]$ProjectRoot
    )

    $pbipFile = Get-ChildItem -Path $ProjectRoot -Filter '*.pbip' -File | Select-Object -First 1
    if (!$pbipFile) {
        throw "No .pbip file found under $ProjectRoot"
    }

    $pbip = Get-Content -Path $pbipFile.FullName -Raw | ConvertFrom-Json
    $reportFolders = New-Object System.Collections.Generic.List[string]

    foreach ($artifact in @($pbip.artifacts)) {
        if ($artifact.report -and $artifact.report.path) {
            $reportFolders.Add((Join-Path $ProjectRoot $artifact.report.path))
        }
    }

    if ($reportFolders.Count -eq 0) {
        throw "No report artifacts found in $($pbipFile.FullName)"
    }

    $itemFolders = New-Object System.Collections.Generic.List[object]

    foreach ($reportFolder in $reportFolders) {
        $reportDefinitionPath = Join-Path $reportFolder 'definition.pbir'
        if (!(Test-Path $reportDefinitionPath)) {
            throw "Report definition not found: $reportDefinitionPath"
        }

        $reportDefinition = Get-Content -Path $reportDefinitionPath -Raw | ConvertFrom-Json
        if ($reportDefinition.datasetReference.byPath.path) {
            $semanticModelFolder = Join-Path $reportFolder $reportDefinition.datasetReference.byPath.path
            $semanticModelFolder = (Resolve-Path -Path $semanticModelFolder).Path
            $itemFolders.Add([pscustomobject]@{ Type = 'SemanticModel'; Path = $semanticModelFolder })
        }

        $itemFolders.Add([pscustomobject]@{ Type = 'Report'; Path = (Resolve-Path -Path $reportFolder).Path })
    }

    return $itemFolders | Sort-Object Type, Path -Unique | Sort-Object @{ Expression = { if ($_.Type -eq 'SemanticModel') { 0 } else { 1 } } }
}

function Get-ItemDefinitionFormat {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Type
    )

    switch ($Type) {
        'SemanticModel' { return 'TMDL' }
        'Report' { return 'PBIR' }
        default { throw "Unsupported Fabric item type: $Type" }
    }
}

function Get-PlatformMetadata {
    param(
        [Parameter(Mandatory = $true)]
        [string]$ItemFolder
    )

    $platformPath = Join-Path $ItemFolder '.platform'
    if (!(Test-Path $platformPath)) {
        throw "Fabric .platform metadata not found: $platformPath"
    }

    return Get-Content -Path $platformPath -Raw | ConvertFrom-Json
}

function New-DefinitionParts {
    param(
        [Parameter(Mandatory = $true)]
        [string]$ItemFolder,

        [Parameter(Mandatory = $true)]
        [string]$Type,

        [string]$SemanticModelId
    )

    $files = Get-ChildItem -Path $ItemFolder -File -Recurse | Where-Object {
        $_.Name -ne '.platform'
    }

    $rootPath = (Resolve-Path -Path $ItemFolder).Path.TrimEnd('\', '/') + [System.IO.Path]::DirectorySeparatorChar
    $rootUri = [System.Uri]::new($rootPath)

    $parts = foreach ($file in $files) {
        $fileUri = [System.Uri]::new($file.FullName)
        $relativePath = [System.Uri]::UnescapeDataString($rootUri.MakeRelativeUri($fileUri).ToString())

        if ($Type -eq 'Report' -and $relativePath -eq 'definition.pbir') {
            if ([string]::IsNullOrWhiteSpace($SemanticModelId)) {
                throw 'SemanticModelId is required when deploying report definitions through the Fabric REST API.'
            }

            $definitionPbir = Get-Content -Path $file.FullName -Raw | ConvertFrom-Json
            $datasetReference = [pscustomobject]@{
                byConnection = [pscustomobject]@{
                    connectionString = "semanticmodelid=$SemanticModelId"
                }
            }
            $definitionPbir | Add-Member -NotePropertyName 'datasetReference' -NotePropertyValue $datasetReference -Force
            $content = $definitionPbir | ConvertTo-Json -Depth 100
            $bytes = [System.Text.Encoding]::UTF8.GetBytes($content)
        }
        else {
            $bytes = [System.IO.File]::ReadAllBytes($file.FullName)
        }

        [pscustomobject]@{
            path = $relativePath
            payload = [System.Convert]::ToBase64String($bytes)
            payloadType = 'InlineBase64'
        }
    }

    return @($parts)
}

function Get-FabricItemByNameAndType {
    param(
        [Parameter(Mandatory = $true)]
        [string]$WorkspaceId,

        [Parameter(Mandatory = $true)]
        [string]$DisplayName,

        [Parameter(Mandatory = $true)]
        [string]$Type
    )

    $items = Invoke-FabricApi -Method Get -Path "workspaces/$WorkspaceId/items"
    return @($items.value) | Where-Object {
        $_.displayName -eq $DisplayName -and $_.type -eq $Type
    } | Select-Object -First 1
}

function Publish-FabricItemDefinition {
    param(
        [Parameter(Mandatory = $true)]
        [string]$WorkspaceId,

        [Parameter(Mandatory = $true)]
        [pscustomobject]$ItemFolder,

        [string]$SemanticModelId
    )

    $platform = Get-PlatformMetadata -ItemFolder $ItemFolder.Path
    $displayName = $platform.metadata.displayName
    $type = $platform.metadata.type

    if ($type -ne $ItemFolder.Type) {
        throw "Item type mismatch for $($ItemFolder.Path): expected $($ItemFolder.Type), found $type in .platform."
    }

    $format = Get-ItemDefinitionFormat -Type $type
    $parts = New-DefinitionParts -ItemFolder $ItemFolder.Path -Type $type -SemanticModelId $SemanticModelId

    if ($parts.Count -eq 0) {
        throw "No definition files found for $displayName at $($ItemFolder.Path)"
    }

    $existingItem = Get-FabricItemByNameAndType -WorkspaceId $WorkspaceId -DisplayName $displayName -Type $type
    $definition = @{
        format = $format
        parts = $parts
    }

    if ($existingItem) {
        Write-Host "Updating $type '$displayName' ($($existingItem.id))."
        $response = Invoke-FabricApi -Method Post -Path "workspaces/$WorkspaceId/items/$($existingItem.id)/updateDefinition" -Body @{
            definition = $definition
        } -ReturnResponse
        Wait-FabricResponseOperation -Response $response
        return $existingItem.id
    }

    Write-Host "Creating $type '$displayName'."
    $response = Invoke-FabricApi -Method Post -Path "workspaces/$WorkspaceId/items" -Body @{
        displayName = $displayName
        type = $type
        definition = $definition
    } -ReturnResponse
    Wait-FabricResponseOperation -Response $response

    if ($response.Body -and $response.Body.id) {
        return $response.Body.id
    }

    $createdItem = Get-FabricItemByNameAndType -WorkspaceId $WorkspaceId -DisplayName $displayName -Type $type
    if (!$createdItem) {
        throw "Unable to resolve created $type '$displayName' after deployment."
    }

    return $createdItem.id
}

if (!(Test-Path -Path $PbipPath)) {
    throw "PBIP path not found: $PbipPath"
}

$accessToken = Get-FabricAccessToken -TenantId $TenantId -ClientId $AppId -Secret $ClientSecret
$script:FabricHeaders = @{
    Authorization = "Bearer $accessToken"
}

$projectRoot = Get-PbipProjectRoot -Path $PbipPath
$workspaceId = Resolve-TargetWorkspaceId
$itemFolders = Get-PbipItemFolders -ProjectRoot $projectRoot

Write-Host "Deploying PBIP project from: $projectRoot"
Write-Host "Target workspace ID: $workspaceId"

$semanticModelId = $null

foreach ($itemFolder in $itemFolders) {
    if ($itemFolder.Type -eq 'SemanticModel') {
        $semanticModelId = Publish-FabricItemDefinition -WorkspaceId $workspaceId -ItemFolder $itemFolder
        continue
    }

    if ([string]::IsNullOrWhiteSpace($semanticModelId)) {
        throw 'Cannot deploy report before a semantic model has been deployed or resolved.'
    }

    Publish-FabricItemDefinition -WorkspaceId $workspaceId -ItemFolder $itemFolder -SemanticModelId $semanticModelId | Out-Null
}

Write-Host 'Fabric PBIP deployment completed.'
