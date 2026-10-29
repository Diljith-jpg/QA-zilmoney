# OCW-24882 — Execution log

- Date: 20 Oct 2026 · Tester: QA (Claude in Chrome, user's signed-in session)
- Env: https://ocw-24882-midhun.web.ocw.sebipay.com (feature build, API staging.api.ocw.sebipay.com)
- Company: Diljith NEW · Browser: Chrome, 1920 px window, light + dark mode
- V4 reached via `/v4/manage/payments-out/detailed/all` (the route the "Switch to the new version" button uses — the button was not rendered in the V3 header for this account).
- Method: for every payment opened, the panel's own GET `/api/v4/checks/{id}` and `/api/v4/zil-payments/{id}` responses were captured in-page (read-only) and the category in them was compared with the Category row in the panel.
- No records created, edited or deleted.

| ID | Scenario | Expected | Actual (observed) | Status | Evidence / notes |
|---|---|---|---|---|---|
| TC01 | ACH payment with category (Alan bb, $45, ref 144) | Category row shows assigned category | API `category.name = Consulting`; panel Payment details shows "Category: Consulting" between Method and Created Date | Passed | TC01-ACH-Consulting.jpg |
| TC02 | Email check with category (11 PAY WEB2, $12, 900208) | Category row shows "fgh" | API `categoryName = fgh`; panel shows "Category: fgh" | Passed | TC02-Check-900208-fgh.jpg |
| TC03 | Other category values (checks ref 1022 / 1024) | Each panel shows its own category | "zil bank" (0044TEST $101, ref 1022), "realm estate" (abc $30, ref 1022 and alan $3,500, ref 1024), "zil wallet" (0969 Ocean View Road $101, ref 1024) — panel = API for all; checks and zil-payments endpoints carry the same category ID | Passed | TC03-Check-1022-zil-bank.jpg |
| TC04 | Voided check with category (0044TEST $22, 2231312, Canceled) | Category still shown | "Category: fgh" shown | Passed | TC04-Voided-2231312-fgh.jpg |
| TC05 | Expanded (full) detail view | Category also shown in expanded layout | Expanded view of 900208 shows "Category: fgh" | Passed | TC05-Expanded-view.jpg |
| TC06 | Payments with no category | No Category row, no empty/placeholder value | 46 of 50 on page 1 of All + 11 of 13 (ref 1022) + 11 of 13 (ref 1024) have `category: null`; none showed a Category row or blank value (2 ref-1024 rows rechecked by hand after a sweep timeout) | Passed | TC06-No-category-hidden.jpg |
| TC07 | Bulk accuracy sweep — page 1 of All (50 payments: Check, ACH, Email/Mail check, LVD, International) | Panel category = API category for each | 50/50 match (4 with category, 46 without); 0 mismatches | Passed | in-page sweep |
| TC08 | Parity with V3 | Same category per transaction as V3 | V3 Check List "Category" column: 900208 = fgh, 2231313 = fgh, 2231312 = fgh, 900214 = blank — same as V4. V3's check view page (/manage/cheque/view) shows no Category field; V3 only shows it in the list column | Passed | TC07-V3-check-view.jpg |
| TC09 | Styling / dark mode | Category row matches other rows | Label 11px/400 slate, value 11px/600, Plus Jakarta Sans — identical to the Method row; readable in dark mode | Passed | TC08-Dark-mode.jpg |
| TC10 | Existing panel content unaffected | Reference ID, Transaction ID, Method, Source, Memo, check preview, timeline, payee details still render | All present on every panel opened | Passed | — |
| TC11 | V3 "Payroll" category (recurring email checks 1022–1024, status For-Email-Recurring) | — | These checks are not listed in V4 Payments Out (V4 shows them as recurring schedules), so no V4 payment-details panel to check | Not tested | outside this panel |
| TC12 | Split / multiple categories (`categoryDetails`) | — | No test data: every payment opened had `categoryDetails: []` | Not tested | open point |
| TC13 | Responsive widths | — | Chrome window is maximized; resize to 768 px had no effect | Not tested | — |

## Observations (not this ticket)
- Console: repeated `TypeError: Cannot read properties of null (reading 'clearRect')` (fabric canvas, chunk-PLLXAY34.js) while opening panels with check preview. Panels render fine. Likely pre-existing; not related to category.
- "Switch to the new version" button not rendered in V3 header for this account.
