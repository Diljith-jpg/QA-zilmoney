# OCW-24882 — [Owner] Transaction category missing from V4 Payment Details screen

- Type: Sub-task of OCW-24881 (Task, status Completed)
- Status at QA start: In QA · Priority: Medium · Assignee/Reporter: Midhun Binoy
- Test environment (given by the user): https://OCW-24882-MIDHUN.web.ocw.sebipay.com (feature build on staging API)
- Attachment: unit-test-report.md (dev)

## Requirement
- Show the transaction category on the V4 Payment Details screen when the transaction has one.
- Displayed category must match the transaction's assigned category.
- No category → don't show an empty/misleading value (hidden or per UI conventions).
- Consistent with V3 category visibility/presentation.
- No impact on existing payment-details functionality.

## Open question (from ticket)
- No-category behaviour: hide vs "Uncategorized"? Build hides the row.
