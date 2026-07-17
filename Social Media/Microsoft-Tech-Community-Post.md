# Enterprise BI DevOps with Microsoft Fabric

Enterprise BI DevOps with Microsoft Fabric is a platform-neutral approach for applying CI/CD, quality gates, and governance to Power BI and Microsoft Fabric PBIP projects.

![Enterprise BI DevOps with Microsoft Fabric architecture](images/enterprise-bi-devops-architecture.svg)

## Supported CI/CD platforms

- Azure DevOps
- GitHub Actions
- GitLab CI/CD

## Core pipeline pattern

![CI/CD quality flow](images/cicd-pipeline-flow.svg)

The shared pipeline pattern includes:

1. PBIP structure validation.
2. Branch-aware quality rule preparation.
3. Dataset quality checks with Tabular Editor BPA.
4. Report quality checks with PBI Inspector/Fab Inspector.
5. DAX test metadata execution.
6. Artifact publication.
7. Dev or feature workspace deployment when configured.

## Included no-code tools

![Fabric BI DevOps Accelerator Launchpad](../docs/images/fabric-bi-devops-accelerator-launchpad.png)

- Enterprise Standards Builder
- Quality Rule Designer
- DAX Test Builder
- Deployment Manifest Builder
- PBIP Project Readiness Scanner

## Governance direction

![Enterprise rule governance layers](images/governance-layers.svg)

The recommended enterprise maturity model is:

- Central baseline rules
- Policy profiles
- Project exceptions
- Generated effective CI rules

Repository:

https://github.com/Coding-Forge/Fabric-BI-DevOps
