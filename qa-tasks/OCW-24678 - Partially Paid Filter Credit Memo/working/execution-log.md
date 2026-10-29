# OCW-24678 — Execution log
Run: 2026-10-13 · Staging (https://staging.web.ocw.sebipay.com/) · company "Diljith NEW" · Chrome (Claude in Chrome)
Build: requests served by ticket API `ocw-24678-danish.api.ocw.sebipay.com` (v4 ag-grid/11, credit-memos/get-count, all 200).
Scope this run: Invoice > Credit Memo only (per user). Credit Note and Invoice-page status filter NOT covered.
Test data (pre-existing, nothing created): 7 credit memos — #2, #522 Partially Paid; #1145, #888, #8854 New; #150 Voided; #543 Completed.

| ID | Scenario | Expected | Actual (observed) | Status | Evidence / notes |
|---|---|---|---|---|---|
| TC01 | V3 Credit Memo, Status = All | All 7 records | 7 of 7 shown | Passed | |
| TC02 | V3 Status = Partially Paid | #2 and #522 only | 2 of 2: #2 ($175/$155), #522 ($100/$40) | Passed | evidence/OCW-24678-TC02-V3-partially-paid.jpg |
| TC03 | V3 regression: New / Void / Completed | 3 / 1 / 1 matching | New 3 (#1145,#888,#8854); Void 1 (#150); Completed 1 (#543) | Passed | no console errors |
| TC04 | V4 Credit Memo, Status = Partially Paid | #2 and #522 only | 2 of 2: #2, #522 | Passed | evidence/OCW-24678-TC04-V4-partially-paid.jpg |
| TC05 | V4 regression: New / Void / Completed | 3 / 1 / 1 matching | New 3; Void 1 (#150); Completed 1 (#543) | Passed | |
| TC06 | V4 Partially Paid + Payee search "alan" (Enter) | #522 only | 1 of 1: #522 | Passed | Payee search applies on Enter |
| TC07 | V4 clear Status (×) with Payee "alan" | All 5 alan records | 5 of 5 (#1145,#150,#8854,#522,#543) | Passed | no console errors |
| TC08 | Empty state (status with no matches) | Empty message only when no matches | V3 "Sorry! No results found"; V4 "No results found" | Passed | used "Mark as Completed" option |

## Observations (not failures of the fix)
- OBS1: Status dropdown (V3 and V4) offers "Mark as Completed" / "Mark As Completed" — reads like an action, not a record status; returns 0 rows here.
  Relevant to AC "dropdown options correctly correspond to the available record statuses" — confirm with dev whether it maps to a real status.
  Evidence: evidence/OCW-24678-OBS-V3-mark-as-completed-option.jpg, evidence/OCW-24678-OBS-V4-mark-as-completed-option.jpg
- OBS2: V3 footer on empty result reads "Showing 1 to 0 of 0 results" (V4 reads "Showing 0 results"). Cosmetic.
- OBS3: Option label "Void" vs row status "Voided" (works, label mismatch only).
