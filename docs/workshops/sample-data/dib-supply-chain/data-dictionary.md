# DIB Supply Chain Data Dictionary

This dictionary describes the synthetic CSV files used by the workshop sample.

## Tables

| File | Type | Grain | Purpose |
|---|---|---|---|
| `dim_date.csv` | Dimension | One row per selected calendar date | Date labels for ordering, shipping, inspection, assessment, risk, and inventory snapshots |
| `dim_programs.csv` | Dimension | One row per program | Defense-oriented program metadata, customer agency, contract vehicle, and status |
| `dim_suppliers.csv` | Dimension | One row per supplier | Supplier profile, tier, synthetic CAGE code, CMMC/NIST posture, ITAR registration, and commodity |
| `dim_facilities.csv` | Dimension | One row per facility | Supplier facility location, type, ERP, quality system, gateway readiness |
| `dim_parts.csv` | Dimension | One row per part/service | Part metadata, commodity, criticality, ITAR control, lead time, and standard unit cost |
| `fact_purchase_orders.csv` | Fact | One row per purchase order line | Program demand, supplier/part order quantity, price, need date, DPAS rating, and order status |
| `fact_shipments.csv` | Fact | One row per shipment | Shipment status, received quantities, accepted/rejected quantities, and late reason |
| `fact_quality_inspections.csv` | Fact | One row per inspection event | Inspection type, defect category, disposition, and corrective action flag |
| `fact_compliance_assessments.csv` | Fact | One row per supplier assessment finding | NIST/CMMC-style assessment score, finding severity, remediation due date, and status |
| `fact_supplier_risk.csv` | Fact | One row per supplier risk snapshot | Risk category, score, likelihood, impact, owner, mitigation, and status |
| `fact_inventory.csv` | Fact | One row per facility/part inventory snapshot | On-hand, allocated, reorder point, safety stock, and inventory health |

## Key fields

### Program

| Field | Meaning |
|---|---|
| `ProgramID` | Synthetic program key |
| `SecurityClassification` | Training label only; not real classification |
| `ContractVehicle` | Fictional contract vehicle pattern |
| `Status` | Program health/status |

### Supplier

| Field | Meaning |
|---|---|
| `SupplierID` | Synthetic supplier key |
| `CAGECode` | Fictional CAGE-style code for training only |
| `CMMCLevel` | Simulated expected maturity level |
| `NIST800171Score` | Simulated assessment score out of 110 |
| `ITARRegistered` | Synthetic indicator for ITAR registration |
| `ApprovedSupplierStatus` | Approved, Conditional, or Watchlist |

### Purchase order

| Field | Meaning |
|---|---|
| `PurchaseOrderID` | Synthetic PO key |
| `ContractLineItem` | Fictional CLIN reference |
| `PriorityRating` | Business priority label |
| `DPASRating` | Synthetic DPAS-style priority rating |
| `POStatus` | Open, Partially Received, or Received |

### Quality and compliance

| Field | Meaning |
|---|---|
| `Disposition` | Accepted, Partial Reject, Rework |
| `CorrectiveActionRequired` | Whether follow-up is needed |
| `Framework` | Training value such as NIST SP 800-171 or CMMC |
| `FindingSeverity` | Low, Medium, High |
| `RemediationDueDate` | Date by which finding should be resolved |

## Recommended relationships

| From table | Column | To table | Column | Cardinality |
|---|---|---|---|---|
| `fact_purchase_orders` | `ProgramID` | `dim_programs` | `ProgramID` | Many-to-one |
| `fact_purchase_orders` | `SupplierID` | `dim_suppliers` | `SupplierID` | Many-to-one |
| `fact_purchase_orders` | `FacilityID` | `dim_facilities` | `FacilityID` | Many-to-one |
| `fact_purchase_orders` | `PartID` | `dim_parts` | `PartID` | Many-to-one |
| `fact_shipments` | `PurchaseOrderID` | `fact_purchase_orders` | `PurchaseOrderID` | Many-to-one |
| `fact_quality_inspections` | `ShipmentID` | `fact_shipments` | `ShipmentID` | Many-to-one |
| `fact_compliance_assessments` | `SupplierID` | `dim_suppliers` | `SupplierID` | Many-to-one |
| `fact_supplier_risk` | `SupplierID` | `dim_suppliers` | `SupplierID` | Many-to-one |
| `fact_inventory` | `FacilityID` | `dim_facilities` | `FacilityID` | Many-to-one |
| `fact_inventory` | `PartID` | `dim_parts` | `PartID` | Many-to-one |

## Suggested inactive date relationships

Use `dim_date[Date]` as a role-playing date table if desired. Keep only one active relationship per fact table unless participants are comfortable with DAX `USERELATIONSHIP`.

Suggested relationships:

- `dim_date[Date]` to `fact_purchase_orders[OrderDate]`
- `dim_date[Date]` to `fact_purchase_orders[NeedByDate]`
- `dim_date[Date]` to `fact_shipments[ShipDate]`
- `dim_date[Date]` to `fact_shipments[ReceivedDate]`
- `dim_date[Date]` to `fact_quality_inspections[InspectionDate]`
- `dim_date[Date]` to `fact_compliance_assessments[AssessmentDate]`
- `dim_date[Date]` to `fact_supplier_risk[RiskDate]`
- `dim_date[Date]` to `fact_inventory[SnapshotDate]`

