# PR Quality Summary

## Summary

This PR updates the Sales Performance semantic model and executive overview report page. It adds DAX test metadata and a deployment manifest for release review.

## Changed areas

- Semantic model: `Revenue`, `Gross Margin`, `Gross Margin %`
- Report page: Executive Overview
- Governance assets: `dax-tests.json`, `deployment-manifest.json`

## Validation evidence

- PBIP readiness scan: passed with warnings
- Dataset quality rules: passed
- Report quality rules: one warning for visual density
- DAX test metadata: passed
- Deployment manifest: provided

## Reviewer focus

1. Confirm `Gross Margin %` uses safe division.
2. Review Executive Overview visual density.
3. Confirm DAX test owners and severity.
4. Confirm Dev/Test/Prod workspace mappings.
5. Confirm the temporary visual density exception is acceptable.

## Recommendation

Approve with review if the BI lead accepts the temporary visual density exception and the mitigation owner confirms the redesign plan.

