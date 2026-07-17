Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$scriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$scriptMap = @{
    'Toolkit'      = Join-Path $scriptRoot 'Clone-SparseToolkitProfile.ps1'
    'Azure DevOps' = Join-Path $scriptRoot 'Clone-SparseAzDoProfile.ps1'
    'GitHub'       = Join-Path $scriptRoot 'Clone-SparseGitHubProfile.ps1'
    'GitLab'       = Join-Path $scriptRoot 'Clone-SparseGitLabProfile.ps1'
}

foreach ($script in $scriptMap.Values) {
    if (!(Test-Path -LiteralPath $script)) {
        throw "Required sparse clone script not found: $script"
    }
}

function New-Label {
    param([string]$Text, [int]$X, [int]$Y)
    $label = New-Object System.Windows.Forms.Label
    $label.Text = $Text
    $label.Location = New-Object System.Drawing.Point($X, $Y)
    $label.Size = New-Object System.Drawing.Size(140, 22)
    $label
}

function New-TextBox {
    param([int]$X, [int]$Y, [int]$Width = 520)
    $textBox = New-Object System.Windows.Forms.TextBox
    $textBox.Location = New-Object System.Drawing.Point($X, $Y)
    $textBox.Size = New-Object System.Drawing.Size($Width, 24)
    $textBox
}

function New-ComboBox {
    param([int]$X, [int]$Y, [string[]]$Items)
    $comboBox = New-Object System.Windows.Forms.ComboBox
    $comboBox.Location = New-Object System.Drawing.Point($X, $Y)
    $comboBox.Size = New-Object System.Drawing.Size(220, 24)
    $comboBox.DropDownStyle = [System.Windows.Forms.ComboBoxStyle]::DropDownList
    [void]$comboBox.Items.AddRange($Items)
    $comboBox.SelectedIndex = 0
    $comboBox
}

function Write-OutputLine {
    param([string]$Text)
    $outputBox.AppendText("$Text`r`n")
    $outputBox.SelectionStart = $outputBox.TextLength
    $outputBox.ScrollToCaret()
}

$form = New-Object System.Windows.Forms.Form
$form.Text = 'Enterprise BI DevOps Sparse Clone UI'
$form.Size = New-Object System.Drawing.Size(860, 690)
$form.StartPosition = 'CenterScreen'

$form.Controls.Add((New-Label 'Clone mode' 20 20))
$modeBox = New-ComboBox 170 18 @('Toolkit', 'Azure DevOps', 'GitHub', 'GitLab')
$form.Controls.Add($modeBox)

$form.Controls.Add((New-Label 'Repository URL' 20 60))
$repoUrlBox = New-TextBox 170 58
$repoUrlBox.Text = 'https://github.com/Coding-Forge/Fabric-BI-DevOps.git'
$form.Controls.Add($repoUrlBox)

$form.Controls.Add((New-Label 'Destination folder' 20 100))
$parentFolderBox = New-TextBox 170 98 460
$form.Controls.Add($parentFolderBox)
$browseButton = New-Object System.Windows.Forms.Button
$browseButton.Text = 'Browse...'
$browseButton.Location = New-Object System.Drawing.Point(640, 96)
$browseButton.Size = New-Object System.Drawing.Size(90, 28)
$form.Controls.Add($browseButton)

$form.Controls.Add((New-Label 'New repo folder name' 20 140))
$repoNameBox = New-TextBox 170 138 300
$repoNameBox.Text = 'Fabric-BI-DevOps-Toolkit'
$form.Controls.Add($repoNameBox)

$form.Controls.Add((New-Label 'Final clone path' 20 180))
$destinationPreviewBox = New-TextBox 170 178 560
$destinationPreviewBox.ReadOnly = $true
$form.Controls.Add($destinationPreviewBox)

$form.Controls.Add((New-Label 'Branch' 20 220))
$branchBox = New-TextBox 170 218 220
$branchBox.Text = 'main'
$form.Controls.Add($branchBox)

$form.Controls.Add((New-Label 'Toolkit platform' 20 260))
$platformBox = New-ComboBox 170 258 @('AzDo', 'GitHub', 'GitLab', 'None', 'All')
$form.Controls.Add($platformBox)

$form.Controls.Add((New-Label 'Toolkit profile' 20 300))
$profileBox = New-ComboBox 170 298 @('Standard', 'Minimal')
$form.Controls.Add($profileBox)

$includeWorkshopBox = New-Object System.Windows.Forms.CheckBox
$includeWorkshopBox.Text = 'Include workshop material'
$includeWorkshopBox.Location = New-Object System.Drawing.Point(170, 338)
$includeWorkshopBox.Size = New-Object System.Drawing.Size(220, 24)
$form.Controls.Add($includeWorkshopBox)

$commandLabel = New-Object System.Windows.Forms.Label
$commandLabel.Text = 'Command preview'
$commandLabel.Location = New-Object System.Drawing.Point(20, 380)
$commandLabel.Size = New-Object System.Drawing.Size(160, 22)
$form.Controls.Add($commandLabel)

$commandPreview = New-Object System.Windows.Forms.TextBox
$commandPreview.Location = New-Object System.Drawing.Point(20, 406)
$commandPreview.Size = New-Object System.Drawing.Size(800, 70)
$commandPreview.Multiline = $true
$commandPreview.ReadOnly = $true
$commandPreview.ScrollBars = 'Vertical'
$form.Controls.Add($commandPreview)

$runButton = New-Object System.Windows.Forms.Button
$runButton.Text = 'Run sparse clone'
$runButton.Location = New-Object System.Drawing.Point(20, 490)
$runButton.Size = New-Object System.Drawing.Size(150, 34)
$form.Controls.Add($runButton)

$closeButton = New-Object System.Windows.Forms.Button
$closeButton.Text = 'Close'
$closeButton.Location = New-Object System.Drawing.Point(180, 490)
$closeButton.Size = New-Object System.Drawing.Size(90, 34)
$form.Controls.Add($closeButton)

$outputBox = New-Object System.Windows.Forms.TextBox
$outputBox.Location = New-Object System.Drawing.Point(20, 540)
$outputBox.Size = New-Object System.Drawing.Size(800, 90)
$outputBox.Multiline = $true
$outputBox.ReadOnly = $true
$outputBox.ScrollBars = 'Vertical'
$form.Controls.Add($outputBox)

function Get-CommandPreview {
    $mode = [string]$modeBox.SelectedItem
    $repo = $repoUrlBox.Text.Trim()
    $destination = Get-FinalDestinationPath
    $branch = $branchBox.Text.Trim()

    if ($mode -eq 'Toolkit') {
        $command = ".\shared\scripts\Clone-SparseToolkitProfile.ps1 -RepoUrl `"$repo`" -Destination `"$destination`" -Branch `"$branch`" -Platform $($platformBox.SelectedItem) -Profile $($profileBox.SelectedItem)"
        if ($includeWorkshopBox.Checked) {
            $command += ' -IncludeWorkshop'
        }
        return $command
    }

    $scriptName = switch ($mode) {
        'Azure DevOps' { 'Clone-SparseAzDoProfile.ps1' }
        'GitHub' { 'Clone-SparseGitHubProfile.ps1' }
        'GitLab' { 'Clone-SparseGitLabProfile.ps1' }
    }

    return ".\shared\scripts\$scriptName -RepoUrl `"$repo`" -Destination `"$destination`" -Branch `"$branch`""
}

function Get-FinalDestinationPath {
    $parent = $parentFolderBox.Text.Trim()
    $repoName = $repoNameBox.Text.Trim()

    if ([string]::IsNullOrWhiteSpace($parent)) {
        return $repoName
    }

    if ([string]::IsNullOrWhiteSpace($repoName)) {
        return $parent
    }

    return (Join-Path $parent $repoName)
}

function Update-UiState {
    $toolkit = ([string]$modeBox.SelectedItem) -eq 'Toolkit'
    $platformBox.Enabled = $toolkit
    $profileBox.Enabled = $toolkit
    $includeWorkshopBox.Enabled = $toolkit
    $destinationPreviewBox.Text = Get-FinalDestinationPath
    $commandPreview.Text = Get-CommandPreview
}

$browseButton.Add_Click({
    $dialog = New-Object System.Windows.Forms.FolderBrowserDialog
    $dialog.Description = 'Select the parent folder where the new sparse-cloned repo folder will be created.'
    if ($dialog.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
        $parentFolderBox.Text = $dialog.SelectedPath
        Update-UiState
    }
})

$closeButton.Add_Click({ $form.Close() })

$runButton.Add_Click({
    try {
        $repo = $repoUrlBox.Text.Trim()
        $parentFolder = $parentFolderBox.Text.Trim()
        $repoName = $repoNameBox.Text.Trim()
        $destination = Get-FinalDestinationPath
        $branch = $branchBox.Text.Trim()

        if ([string]::IsNullOrWhiteSpace($repo)) { throw 'Repository URL is required.' }
        if ([string]::IsNullOrWhiteSpace($parentFolder)) { throw 'Destination parent folder is required.' }
        if ([string]::IsNullOrWhiteSpace($repoName)) { throw 'New repo folder name is required.' }
        if ($repoName -match '[\\/:*?"<>|]') { throw 'New repo folder name contains invalid path characters.' }
        if ([string]::IsNullOrWhiteSpace($destination)) { throw 'Final clone path is required.' }
        if ([string]::IsNullOrWhiteSpace($branch)) { throw 'Branch is required.' }

        $mode = [string]$modeBox.SelectedItem
        $script = $scriptMap[$mode]
        $arguments = @(
            '-NoProfile',
            '-ExecutionPolicy', 'Bypass',
            '-File', $script,
            '-RepoUrl', $repo,
            '-Destination', $destination,
            '-Branch', $branch
        )

        if ($mode -eq 'Toolkit') {
            $arguments += @('-Platform', [string]$platformBox.SelectedItem, '-Profile', [string]$profileBox.SelectedItem)
            if ($includeWorkshopBox.Checked) { $arguments += '-IncludeWorkshop' }
        }

        Write-OutputLine "Running: powershell.exe $($arguments -join ' ')"
        $process = New-Object System.Diagnostics.Process
        $process.StartInfo.FileName = 'powershell.exe'
        $process.StartInfo.Arguments = ($arguments | ForEach-Object {
            if ($_ -match '\s') { '"' + ($_ -replace '"', '\"') + '"' } else { $_ }
        }) -join ' '
        $process.StartInfo.RedirectStandardOutput = $true
        $process.StartInfo.RedirectStandardError = $true
        $process.StartInfo.UseShellExecute = $false
        $process.StartInfo.CreateNoWindow = $true
        [void]$process.Start()
        $stdout = $process.StandardOutput.ReadToEnd()
        $stderr = $process.StandardError.ReadToEnd()
        $process.WaitForExit()
        if ($stdout) { Write-OutputLine $stdout.TrimEnd() }
        if ($stderr) { Write-OutputLine $stderr.TrimEnd() }
        if ($process.ExitCode -ne 0) { throw "Sparse clone failed with exit code $($process.ExitCode)." }
        Write-OutputLine 'Sparse clone completed successfully.'
    }
    catch {
        Write-OutputLine "ERROR: $($_.Exception.Message)"
        [System.Windows.Forms.MessageBox]::Show($_.Exception.Message, 'Sparse Clone Error', 'OK', 'Error') | Out-Null
    }
})

@($modeBox, $repoUrlBox, $parentFolderBox, $repoNameBox, $branchBox, $platformBox, $profileBox, $includeWorkshopBox) | ForEach-Object {
    $_.Add_TextChanged({ Update-UiState })
}
$modeBox.Add_SelectedIndexChanged({ Update-UiState })
$platformBox.Add_SelectedIndexChanged({ Update-UiState })
$profileBox.Add_SelectedIndexChanged({ Update-UiState })
$includeWorkshopBox.Add_CheckedChanged({ Update-UiState })

Update-UiState
[void]$form.ShowDialog()

