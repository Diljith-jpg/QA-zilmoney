# Asynchronous Bulk Processing — Test Case Tracker

- **Branch:** `bulk-payment-testing`
- **Environment:** Staging — https://OCW-24375-SHABEEB.web.ocw.sebipay.com(frontend)
https://OCW-23926-DANISH-ASYNC.api.ocw.sebipay.com(backend)(never production)
- **Jira ticket:** _TBD_
- **Requirements source:** _pending — user to provide requirements .md_
- **Dev task (frontend):** OCW-24375 — branch `OCW-24375-SHABEEB` @ `a7b32ae12a`

## Developer evidence
| Evidence | Source | Date | Key points for QA |
|---|---|---|---|
| [Frontend unit / self-test report](evidence/dev-unit-test/OCW-24375-Self-Test-Report.pdf) | Dev (Shabeeb K) | 2026-10-28 | Dev marks it **not ready for QA**. Only the build, type-check, lint and bundle checks were run. The 166 spec `it()` blocks have never been run (the repo has no test runner), and every functional and edge case is NOT RUN. Settle these first: §8 (does V3 bulk print / sendmail get a `url` or a batch?) and the dead "Download checks" code in `V4PaymentSummaryModal`. |

## How this file is maintained
- Every test case lives here with a stable ID (`BULK-TC-###`). IDs are never reused or renumbered.
- Each testing round gets a column in the results table and a section in the round log.
- Before a new round: re-run / re-check every previous case, then append new cases at the end.
- Status values: `Passed`, `Failed`, `Blocked`, `Not tested`. `Passed` only when observed in the browser in that round.
- Ambiguous requirements go to **Open points**, not into expected results.

## Round summary
| Round | Date | Build / notes | Passed | Failed | Blocked | Not tested | Verdict |
|---|---|---|---|---|---|---|---|

## Test cases
| ID | Requirement | Title | Steps (summary) | Expected result | Added in | R1 | Notes / evidence |
|---|---|---|---|---|---|---|---|

## Defects
| ID | Test case | Summary | Severity | Round found | Status |
|---|---|---|---|---|---|

## Open points / questions
_None yet._

## Round log
_No rounds executed yet._
