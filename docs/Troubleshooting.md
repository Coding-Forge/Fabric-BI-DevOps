# Troubleshooting Guide

This guide covers common issues when working with PBIP validation, report rules, and dataset rules in this repository.

## PBIP Structure Validation Fails

Symptom:

- `No .pbip file found`
- `Expected exactly one .pbip file at the project root`
- missing report or semantic model definition files

What to check:

- the repository root contains exactly one `.pbip` file
- the PBIP `artifacts[0].report.path` points to the report folder
- `definition.pbir` contains a valid `datasetReference.byPath.path`
- the semantic model includes `definition.pbism`, `definition/model.tmdl`, and `definition/relationships.tmdl`

Relevant validator:

- `tests/validate_pbip_structure.py`

## Dataset Rules Behave Differently on Branches

Symptom:

- a dataset rule triggers on `main` or `develop` but not on a feature branch

Cause:

- the effective ruleset is filtered by severity in `scripts/Prepare-QualityRules.ps1`

What to check:

- `Severity` value in `Rules-Dataset.json`
- branch name passed as `-SourceBranch`
- generated `Rules-Dataset.effective.json`

Rule behavior summary:

- `main` and `develop`: `Severity >= 2`
- feature branches: `Severity >= 3`

## Report Rules Behave Differently on Branches

Symptom:

- a report rule is only blocking on `main` or `develop`

Cause:

- selected warnings are promoted to `error` on protected integration branches

What to check:

- `id` in `Rules-Report.json`
- `logType` in the prepared output file
- generated `Rules-Report.effective.json`

## A Rule Is Too Noisy

Symptom:

- a rule catches valid visuals, valid model objects, or too many edge cases

What to do:

- narrow the scope first
- add explicit exclusions for known acceptable cases
- reduce severity or keep the report rule at `warning`
- validate on a feature branch before promoting on `main`

Best reference:

- `Rules-Authoring-Guide.md`

## Pipeline Cannot Find Report or Semantic Model Definitions

Symptom:

- `No semantic model definitions found`
- `No report definitions found`
- `Cannot find semantic model definition`

What to check:

- required `.pbism` and `.pbir` files still exist in expected folders
- folder names match the PBIP and PBIR path references
- the repository layout was not changed without updating those references

## Tool Download Failures in CI

Symptom:

- Tabular Editor or PBI Inspector download step fails

Likely causes:

- transient GitHub release availability issue
- network restrictions on the build agent
- upstream release asset naming change

What to check:

- URLs defined in `azure-pipelines.yml`
- build agent outbound connectivity
- whether fallback rule downloads succeeded separately from tool downloads

## DAX Test Stage Passes But Gives Low Confidence

Symptom:

- CI passes but the DAX test stage only proves file existence

Cause:

- `tests/run_dax_tests.py` is intentionally a minimal harness

What to do:

- replace placeholder assertions with real semantic model checks
- keep JUnit XML output so Azure Pipelines can publish results
- treat current DAX tests as scaffolding, not deep semantic validation

## Two Pipeline YAML Files Exist

Symptom:

- uncertainty about which pipeline file is operational

Current repository state:

- `azure-pipelines.yml` is the active quality-validation pipeline
- `azure-pipeline.yml` reads like example/template-oriented CI/CD guidance

Recommendation:

- use `azure-pipelines.yml` as the authoritative validation reference
- either document the purpose of `azure-pipeline.yml` or move/archive it to reduce ambiguity

## When To Change Rules vs Fix Artifacts

Change the artifact when:

- the rule is correct and the report/model violates a standard you want to keep

Change the rule when:

- the rule produces false positives
- the rule is enforcing a standard not yet agreed by the team
- the rule is too broad for the current project shape