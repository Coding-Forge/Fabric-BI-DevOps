
# Fabric + Git Integration Architecture

```mermaid
flowchart LR
    subgraph Fabric_Workspace["Fabric Workspace"]
        A["Reports (PBIP)"]
        B[Semantic Models]
        C[Notebooks / Dataflows]
    end

    subgraph GitRepo["Azure DevOps / GitHub Repo"]
        D[PBIP Artifacts<br/>JSON/YAML/TMDL]
        E[Feature Branches]
        F["Main Branch<br/>(Protected)"]
    end

    A <-- Sync --> D
    B <-- Sync --> D
    C <-- Sync --> D

    D <-- Pull / Push --> E
    E --> F
```

---

# `/docs/architecture/pbip-dev-workflow.md`

# PBIP Development Workflow

```mermaid
flowchart LR
    Dev[Developer Workstation<br/>VS Code + PBIDevMode] 
    Repo[(Git Repo)]
    PR[Pull Request<br/>Review + Checks]
    Fabric[Fabric Workspace<br/>Git-Connected]
    Pipelines[CI Pipeline]

    Dev -->|Commit / Push| Repo
    Repo --> PR
    PR -->|Approved + Merged| Repo
    Repo -->|Sync| Fabric
    Repo --> Pipelines
```

---

# `/docs/architecture/ci-pipeline.md`

# CI Pipeline for PBIP (Azure DevOps)

```mermaid
flowchart TD
    Trigger[Git Trigger<br/>Feature Branch or Main]
    Agent[Build Agent]
    Validate[pbi-tools Validate<br/>Schema/DAX/Lint]
    Tests[Unit Tests<br/>Model / Measures]
    Artifacts[Publish Artifacts]
    Status[CI Status Checks]

    Trigger --> Agent
    Agent --> Validate
    Validate --> Tests
    Tests --> Artifacts
    Artifacts --> Status
```

---

# `/docs/architecture/deployment-pipeline.md`

# Fabric Deployment Pipeline (Dev → Test → Prod)

```mermaid
flowchart LR
    DevWS[Dev Workspace<br/>Git-connected]
    TestWS[Test Workspace]
    ProdWS[Prod Workspace]

    subgraph Pipelines["Fabric Deployment Pipeline"]
        Promote1[Promote: Dev → Test]
        Promote2[Promote: Test → Prod]
    end

    DevWS --> Promote1 --> TestWS
    TestWS --> Promote2 --> ProdWS

    subgraph Controls["Validation & Governance"]
        Check1[Schema Diff]
        Check2[RLS/CLS Validation]
        Check3[Parameter Swap<br/>Key Vault]
        Check4[Refresh Tests]
    end

    Promote1 --> Check1
    Promote2 --> Check2
    Promote2 --> Check3
    Promote2 --> Check4
```

---

# `/docs/architecture/end-to-end-devops.md`

# End-to-End Fabric DevOps Architecture

```mermaid
flowchart TD

    subgraph Dev["Developer Flow"]
        VS[VS Code / Power BI Desktop]
        Branch[Feature Branch]
        Commit[Commit + Push]
        PR[Pull Request + Review]
    end

    subgraph Repo["Git Repository (ADO/GitHub)"]
        Main[Main Branch<br/>Protected]
        CI[CI Pipeline<br/>PBIP Validation]
        Artifacts[Build Artifacts]
    end

    subgraph Fabric["Fabric Environments"]
        DevWS[Dev Workspace]
        TestWS[Test Workspace]
        ProdWS[Prod Workspace]
    end

    VS --> Branch --> Commit --> PR --> Main
    Main --> CI --> Artifacts

    Main -->|Sync| DevWS
    DevWS -->|Promote| TestWS
    TestWS -->|Promote| ProdWS
```

---

# `/docs/architecture/powerbi-embedded.md`

# Power BI Embedded (App‑Owns‑Data) Architecture

```mermaid
flowchart LR
    App["Custom Web App<br/>(Frontend)"]
    Backend[Backend API<br/>Token Issuer]
    SP[Azure AD App Registration<br/>Service Principal]
    FabricWS[Fabric Workspace<br/>Reports / Models]
    Embed[Power BI Embed Token]

    App -->|Request| Backend
    Backend -->|Auth| SP
    SP -->|Get Access Token| MicrosoftEntra[(Microsoft Entra ID)]
    Backend -->|Generate Embed Token| Embed
    Embed --> App
    App -->|Load Report| FabricWS
```

---