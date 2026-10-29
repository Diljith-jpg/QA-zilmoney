# OCW-24638 — Execution log
Environment: Staging (https://staging.web.ocw.sebipay.com/), V4 (Version 2.0 BETA), Chrome, company "Diljith NEW", 10 Oct 2026.
Page: Bulk Payment Center → My Groups (navigated from the V4 sidebar "Bulk Payment Center"). Baseline: 43 groups.

| ID | Scenario | Expected | Actual (observed) | Status | Evidence / notes |
|---|---|---|---|---|---|
| TC01 | Payments Count filter = 2 | Only groups with count 2 | 15 of 15 results, every row count 2 | Passed | evidence/OCW-24638-TC01-payments-count-filter.jpg |
| TC02 | Clear Payments Count filter | Full list returns | "Showing 1 to 43 of 43 results" | Passed | — |
| TC03 | Total Amount filter = 150 | Only groups totalling $150.00 | 5 of 5 results, all $150.00 (counts 5,3,1,1,3) | Passed | evidence/OCW-24638-TC02-total-amount-filter.jpg |
| TC04 | Payments Count = 3 + Total Amount = 150 | Only groups matching both | 2 results: "abc group", "test achreq" (3 / $150.00) | Passed | evidence/OCW-24638-TC03-combined-filter.jpg |
| TC05 | Total Amount = 987654 (no match) | Empty state, no error | "No results found", "Showing 0 results" | Passed | evidence/OCW-24638-TC04-no-results.jpg |
| TC06 | Clear all filters | Full list returns | "Showing 1 to 43 of 43 results" | Passed | — |
| TC07 | Console during filtering | No app errors | No console errors after filtering (only a 3rd-party Shopify App Bridge error on the V3 page load, unrelated) | Passed | — |

Observation: the column filter applies when Enter is pressed; typing alone (waited 3 s) did not refresh the list.
No test data created.
