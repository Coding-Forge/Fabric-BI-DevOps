# PBIP Build Guide — DIB Supply Chain Readiness

This guide walks participants through building a Power BI Project (PBIP) from the synthetic DIB Supply Chain CSV files.

## Goal

Create a PBIP report named:

```text
DIB Supply Chain Readiness
```

The report should help a defense-oriented manufacturing team answer:

- Which programs have supplier or part readiness risk?
- Which suppliers have cyber/compliance findings?
- Which critical parts are late, below reorder point, or quality constrained?
- Which purchase orders and shipments require attention?
- Which release artifacts should be reviewed before promotion?

## Prerequisites

- Power BI Desktop installed
- Local copy of this repository **or** access to the public raw GitHub CSV URLs
- CSV files in:

  ```text
  docs/workshops/sample-data/dib-supply-chain/csv/
  ```

- Optional: Fabric workspace connected to Git for PBIP sync

## Data source options

You can build the PBIP project from either local CSV files or public raw GitHub URLs.

| Option | Use when | Gateway impact |
|---|---|---|
| Local folder CSV files | Participants are working only in Power BI Desktop or the facilitator has distributed a local copy of the repo | If published to the Power BI Service, scheduled refresh requires a configured on-premises data gateway because the Service cannot directly reach the participant's local disk |
| Public raw GitHub URLs | Participants are building in Power BI Service/Fabric or need a repeatable cloud-accessible source | Scheduled refresh can use the cloud Web connector with Anonymous authentication, so no on-premises data gateway is required for these public CSV files |

The raw GitHub option is recommended for service-based workshops because every participant connects to the same public source over HTTPS.

## Part 1 — Create the PBIP project

1. Open **Power BI Desktop**.
2. Choose **File → Options and settings → Options**.
3. Confirm Power BI Project save format is available/enabled.
4. Import each CSV file using one of the following methods.

   **Option A — Local CSV folder**

   ```text
   docs/workshops/sample-data/dib-supply-chain/csv/
   ```

   **Option B — Web / raw GitHub URL**

   Use **Get data → Web** and paste the raw CSV URL for each table. Use **Anonymous** authentication.

   > Replace `main` with the appropriate branch name if running from a fork or workshop branch.

   | Table | Raw GitHub URL |
   |---|---|
   | `dim_date` | `https://raw.githubusercontent.com/Coding-Forge/Fabric-BI-DevOps/main/docs/workshops/sample-data/dib-supply-chain/csv/dim_date.csv` |
   | `dim_programs` | `https://raw.githubusercontent.com/Coding-Forge/Fabric-BI-DevOps/main/docs/workshops/sample-data/dib-supply-chain/csv/dim_programs.csv` |
   | `dim_suppliers` | `https://raw.githubusercontent.com/Coding-Forge/Fabric-BI-DevOps/main/docs/workshops/sample-data/dib-supply-chain/csv/dim_suppliers.csv` |
   | `dim_facilities` | `https://raw.githubusercontent.com/Coding-Forge/Fabric-BI-DevOps/main/docs/workshops/sample-data/dib-supply-chain/csv/dim_facilities.csv` |
   | `dim_parts` | `https://raw.githubusercontent.com/Coding-Forge/Fabric-BI-DevOps/main/docs/workshops/sample-data/dib-supply-chain/csv/dim_parts.csv` |
   | `fact_purchase_orders` | `https://raw.githubusercontent.com/Coding-Forge/Fabric-BI-DevOps/main/docs/workshops/sample-data/dib-supply-chain/csv/fact_purchase_orders.csv` |
   | `fact_shipments` | `https://raw.githubusercontent.com/Coding-Forge/Fabric-BI-DevOps/main/docs/workshops/sample-data/dib-supply-chain/csv/fact_shipments.csv` |
   | `fact_quality_inspections` | `https://raw.githubusercontent.com/Coding-Forge/Fabric-BI-DevOps/main/docs/workshops/sample-data/dib-supply-chain/csv/fact_quality_inspections.csv` |
   | `fact_compliance_assessments` | `https://raw.githubusercontent.com/Coding-Forge/Fabric-BI-DevOps/main/docs/workshops/sample-data/dib-supply-chain/csv/fact_compliance_assessments.csv` |
   | `fact_supplier_risk` | `https://raw.githubusercontent.com/Coding-Forge/Fabric-BI-DevOps/main/docs/workshops/sample-data/dib-supply-chain/csv/fact_supplier_risk.csv` |
   | `fact_inventory` | `https://raw.githubusercontent.com/Coding-Forge/Fabric-BI-DevOps/main/docs/workshops/sample-data/dib-supply-chain/csv/fact_inventory.csv` |

5. In Power Query, confirm data types:

   | Field type | Data type |
   |---|---|
   | IDs and codes | Text |
   | Dates | Date |
   | Scores and quantities | Whole number or decimal number |
   | Unit prices/costs | Decimal number |
   | Yes/No fields | Text |

6. Rename queries to match the file names without `.csv`.
7. Load the data.
8. Save as a Power BI Project:

   ```text
   DIB Supply Chain Readiness.pbip
   ```

9. Recommended workshop save path:

   ```text
   shared/pbip-local/DIB Supply Chain Readiness/
   ```

## Part 1b — Power Query pattern for Web CSVs

If using **Get data → Web**, Power BI will generate most of this for you. The following pattern is useful when participants want to inspect or standardize the query.

Example for `dim_suppliers`:

```powerquery
let
    Source = Csv.Document(
        Web.Contents("https://raw.githubusercontent.com/Coding-Forge/Fabric-BI-DevOps/main/docs/workshops/sample-data/dib-supply-chain/csv/dim_suppliers.csv"),
        [Delimiter = ",", Columns = 13, Encoding = 65001, QuoteStyle = QuoteStyle.Csv]
    ),
    PromotedHeaders = Table.PromoteHeaders(Source, [PromoteAllScalars = true]),
    ChangedTypes = Table.TransformColumnTypes(
        PromotedHeaders,
        {
            {"SupplierID", type text},
            {"SupplierName", type text},
            {"SupplierTier", type text},
            {"CAGECode", type text},
            {"Country", type text},
            {"State", type text},
            {"SmallBusiness", type text},
            {"OwnershipType", type text},
            {"CMMCLevel", Int64.Type},
            {"NIST800171Score", Int64.Type},
            {"ITARRegistered", type text},
            {"PrimaryCommodity", type text},
            {"ApprovedSupplierStatus", type text}
        }
    )
in
    ChangedTypes
```

### Why the Web source avoids a gateway

Power BI Service requires an on-premises data gateway when a semantic model refresh needs to reach data that is only available inside a private network, on a local workstation, or on a file share.

The raw GitHub URLs are public HTTPS endpoints. Power BI Service can reach them directly from the cloud using the built-in Web connector. Because the data source is cloud-accessible and uses Anonymous authentication, no on-premises data gateway is needed for scheduled refresh.

Use this approach only for the synthetic workshop data. Do not publish real customer, supplier, controlled, export-controlled, CUI, or classified data to a public repository.

## Part 2 — Create relationships

Create these model relationships:

| From table | Column | To table | Column |
|---|---|---|---|
| `fact_purchase_orders` | `ProgramID` | `dim_programs` | `ProgramID` |
| `fact_purchase_orders` | `SupplierID` | `dim_suppliers` | `SupplierID` |
| `fact_purchase_orders` | `FacilityID` | `dim_facilities` | `FacilityID` |
| `fact_purchase_orders` | `PartID` | `dim_parts` | `PartID` |
| `fact_shipments` | `PurchaseOrderID` | `fact_purchase_orders` | `PurchaseOrderID` |
| `fact_quality_inspections` | `ShipmentID` | `fact_shipments` | `ShipmentID` |
| `fact_compliance_assessments` | `SupplierID` | `dim_suppliers` | `SupplierID` |
| `fact_supplier_risk` | `SupplierID` | `dim_suppliers` | `SupplierID` |
| `fact_inventory` | `FacilityID` | `dim_facilities` | `FacilityID` |
| `fact_inventory` | `PartID` | `dim_parts` | `PartID` |

Optional date relationships can be added later. If participants are new to modeling, keep date relationships simple and focus on the business dimensions first.

## Part 3 — Create starter measures

Create a measure table named:

```text
_Measures
```

Add these starter measures:

```DAX
Total PO Value =
SUMX (
    fact_purchase_orders,
    fact_purchase_orders[QuantityOrdered] * fact_purchase_orders[UnitPrice]
)
```

```DAX
Open PO Count =
CALCULATE (
    COUNTROWS ( fact_purchase_orders ),
    fact_purchase_orders[POStatus] <> "Received"
)
```

```DAX
On Time Shipment Count =
COUNTROWS (
    FILTER (
        fact_shipments,
        NOT ISBLANK ( fact_shipments[ReceivedDate] )
            && RELATED ( fact_purchase_orders[NeedByDate] ) >= fact_shipments[ReceivedDate]
    )
)
```

```DAX
Shipment Count =
COUNTROWS ( fact_shipments )
```

```DAX
On Time Delivery % =
DIVIDE ( [On Time Shipment Count], [Shipment Count] )
```

```DAX
Rejected Quantity =
SUM ( fact_shipments[QuantityRejected] )
```

```DAX
Open High Findings =
CALCULATE (
    COUNTROWS ( fact_compliance_assessments ),
    fact_compliance_assessments[Status] = "Open",
    fact_compliance_assessments[FindingSeverity] = "High"
)
```

```DAX
Average Supplier Risk Score =
AVERAGE ( fact_supplier_risk[RiskScore] )
```

```DAX
Critical Parts Below Reorder =
COUNTROWS (
    FILTER (
        fact_inventory,
        fact_inventory[QuantityOnHand] < fact_inventory[ReorderPoint]
            && RELATED ( dim_parts[IsCriticalPart] ) = "Yes"
    )
)
```

## Part 4 — Build report pages

Create these pages:

### Page 1 — Executive Readiness

Recommended visuals:

- Cards:
  - `Total PO Value`
  - `Open PO Count`
  - `On Time Delivery %`
  - `Open High Findings`
  - `Critical Parts Below Reorder`
- Bar chart: `Average Supplier Risk Score` by supplier
- Matrix: Program, PO status, total PO value
- Slicer: Program status

### Page 2 — Supplier Risk and Compliance

Recommended visuals:

- Bar chart: risk score by supplier
- Table: open compliance findings by supplier
- Matrix: CMMC level, NIST score, ITAR registration, approved supplier status
- Slicer: finding severity

### Page 3 — Procurement and Delivery

Recommended visuals:

- Table: purchase orders, need-by date, status, DPAS rating
- Bar chart: PO value by commodity
- Bar chart: shipments by status
- Table: delayed shipments and late reasons

### Page 4 — Quality and Inventory

Recommended visuals:

- Table: quality inspection findings
- Bar chart: rejected quantity by supplier
- Matrix: parts below reorder by facility
- Slicer: critical part indicator

## Part 5 — Save and inspect PBIP output

1. Save the report.
2. Confirm the `.pbip`, `.Report`, and `.SemanticModel` folders exist.
3. Confirm model files include TMDL/definition content.
4. Commit the PBIP project to a feature branch if using Git.

## Part 6 — Use accelerator tools against this PBIP

Run these tools after the PBIP exists:

| Tool | Workshop use |
|---|---|
| PBIP Project Readiness Scanner | Validate the PBIP folder and governance assets |
| Enterprise Standards Builder | Create starter report/model quality rules |
| DAX Test Builder | Create tests for `On Time Delivery %`, `Open High Findings`, and `Critical Parts Below Reorder` |
| Deployment Manifest Builder | Document Dev/Test/Prod workspace targets and release gates |
| PBIP Diff Viewer | Compare before/after changes during labs |
| Dependency Impact Analyzer | Trace changes to supplier risk, compliance, or critical part measures |
| PR Quality Summary Generator | Create a PR handoff summary |
| Release Readiness Dashboard | Decide if the workshop release is ready |

## Suggested DAX test metadata

Create DAX test cases for:

| Measure | Expected behavior |
|---|---|
| `Total PO Value` | Greater than 0 |
| `On Time Delivery %` | Between 0 and 1 |
| `Open High Findings` | Greater than or equal to 0 |
| `Critical Parts Below Reorder` | Greater than or equal to 0 |
| `Average Supplier Risk Score` | Between 0 and 100 |

## Suggested governance conversation

Use this sample to discuss:

- How to handle suppliers with low NIST/CMMC posture
- Whether high cyber findings should block release
- How to document approved temporary exceptions
- How to distinguish operational risk from report quality risk
- How to keep synthetic workshop data separate from real customer data

## Expected final PBIP package

The completed workshop PBIP should include:

```text
DIB Supply Chain Readiness.pbip
DIB Supply Chain Readiness.Report/
DIB Supply Chain Readiness.SemanticModel/
Rules-Report.json
Rules-Dataset.json
dax-tests.json
deployment-manifest.json
policy-exceptions.json
```

