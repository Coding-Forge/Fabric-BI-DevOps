# Synthetic DIB Supply Chain Sample Data

This folder contains a synthetic dataset for workshops where participants do not have a customer PBIP solution available.

The scenario reflects common business patterns in the **Defense Industrial Base (DIB)** without using real customer, supplier, program, contract, export-controlled, or classified information.

## Scenario

**Apex Defense Manufacturing** is a fictional supplier managing parts, suppliers, facilities, purchase orders, quality inspections, compliance findings, inventory, and supplier risk across several defense-oriented programs.

Participants can use this dataset to build a Power BI Project (PBIP) that supports:

- Supplier delivery performance
- Critical part readiness
- Quality inspection trends
- Compliance and CMMC/NIST-style findings
- Supplier risk monitoring
- Program-level procurement status
- Inventory below reorder point

## Important data notice

- This is **synthetic training data**.
- CAGE codes, supplier names, program names, contract references, findings, and risk values are fictional.
- Do not treat this as controlled, export-controlled, classified, CUI, or customer data.
- Do not add real supplier, contract, program, or controlled technical information to this sample folder.

## Folder contents

```text
docs/workshops/sample-data/dib-supply-chain/
  README.md
  data-dictionary.md
  pbip-build-guide.md
  csv/
    dim_date.csv
    dim_programs.csv
    dim_suppliers.csv
    dim_facilities.csv
    dim_parts.csv
    fact_purchase_orders.csv
    fact_shipments.csv
    fact_quality_inspections.csv
    fact_compliance_assessments.csv
    fact_supplier_risk.csv
    fact_inventory.csv
```

## Recommended use

Use this dataset when:

- A customer cannot provide data for the workshop.
- You need a repeatable demo model for screenshots, video, or facilitator-led delivery.
- You want to test the accelerator tools against a realistic PBIP-style scenario.
- You need a baseline dataset for Lab 1, Lab 2, Lab 3, or the Accelerator Toolkit Workshop.

## Build path

1. Follow [PBIP Build Guide](pbip-build-guide.md).
2. Import the CSV files from `csv/`, or use the public raw GitHub URLs documented in the build guide.
3. Create relationships and measures.
4. Build the recommended report pages.
5. Save as a PBIP project under `shared/pbip-local/` or a separate workshop repo.
6. Run the accelerator tools against the resulting PBIP project.

## Data source options

| Option | Best for | Refresh behavior |
|---|---|---|
| Local CSV folder | Offline workshops, local Desktop-only demos, or private facilitator prep | Power BI Service refresh generally requires an on-premises data gateway because the files live on a local machine or file share |
| Public raw GitHub URLs | Power BI Service or Fabric workshops where participants need repeatable cloud-accessible data | Power BI Service can refresh through the cloud Web connector with Anonymous authentication; no on-premises gateway is needed for these public CSV files |

For service-friendly workshop delivery, prefer the raw GitHub URL option once the repository is public and the sample files are committed.

## Suggested report name

```text
DIB Supply Chain Readiness.pbip
```

