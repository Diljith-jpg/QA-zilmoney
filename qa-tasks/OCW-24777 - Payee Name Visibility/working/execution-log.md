# OCW-24777 — Execution log (2026-10-16)

Env under test: https://ocw-24777-davood.web.ocw.sebipay.com (bundle main-JWSNKJ7Z)
Baseline: https://staging.web.ocw.sebipay.com (bundle main-4NO6J54Y)
Browser: Chrome (Claude in Chrome), viewport 1920×855. Company: Diljith NEW. Test data created: none.
Scope clarified by user: test in the **new version (Version 2.0 BETA)** → Payments Out (`/v4/manage/payments-out/detailed/*`).

## Run 2 — Version 2.0 (V4) Payments Out — scope of this ticket

| ID | Scenario | Expected | Actual (observed) | Status | Evidence / notes |
|---|---|---|---|---|---|
| TC01 | Switch to Version 2.0 via header toggle → Payments Out → All → open "Select Payee" | Dropdown opens | Opens: Search Payees input, Select All, "0 selected", checkbox list, Cancel / Apply | Passed | TC01-v4-payee-dropdown-open.jpg |
| TC02 | Hover truncated long names "0969 Ocean View Road (0969 Ocean View Road)" and "01219 Plumbing Inc2 (01219 Plumbing Inc2)" | Tooltip shows full name | Dark tooltip above the row with the full "Name (Nickname)" text for both. Span uses mat-tooltip + appEllipsisActive | Passed | TC02-v4-tooltip-0969-ocean-view.png, TC02-v4-tooltip-01219-plumbing.png |
| TC03 | Hover short (non-truncated) name "11 PAY WEB2 (11 PAY WEB2)" | No tooltip | No tooltip; tooltip disabled on non-truncated items | Passed | TC03-v4-short-name-no-tooltip.png |
| TC04 | Compare dropdown with staging (same company, same page) | Wider + taller than staging; staging has no tooltip | Staging: panel 240 px wide, list max-height 160 px, text span 174 px, no tooltip on hover. Branch: panel 250 px, list max-height 190 px, text span 184 px, tooltip shown. Row height 34 px both | Passed | TC04-v4-baseline-staging-no-tooltip.png vs TC01 |
| TC05 | Type "Plumbing" in Search Payees, hover result | Result filtered; tooltip on result | Single result "01219 Plumbing Inc2 (01219 Plum…"; tooltip shows full name | Passed | TC05-v4-search-result-tooltip.png |
| TC06 | Tick result → Apply; then clear (×) | Table filtered by payee; clear restores list | All visible rows = 01219 Plumbing Inc2; chip shows "01219 Plumbing Inc2" with ×; × restored the full list | Passed | TC06-v4-filter-applied.jpg |
| TC07 | Scroll list; hover a lazily loaded long name "ABC Medical Records Inc (ABC Medical Records Inc)" | Scroll works, more items load, tooltip works on loaded items | List scrolls inside 190 px area; items 10 → 20 on scroll; tooltip shown; no page horizontal scroll | Passed | TC07-v4-lazy-loaded-item-tooltip.png |
| TC08 | Check tab and ACH tab → Select Payee → hover long name | Same behaviour on other tabs | Check: 250 px / 190 px, tooltip "0969 Ocean View Road (…)" shown. ACH: 250 px / 190 px, tooltip "01219 Plumbing Inc2 (…)" shown | Passed | TC08-v4-check-tab-tooltip.png |
| TC09 | Dark mode (header toggle) → ACH → hover long name | Tooltip readable in dark theme | Panel dark-themed; tooltip readable; switched back to light after | Passed | TC09-v4-dark-mode-tooltip.jpg |
| TC10 | Responsive widths (1280 / 1024 / 768) | Dropdown + tooltip within viewport | resize_window had no effect (window maximised; viewport stayed 1920) | Not tested | Tool limitation; needs manual check |
| TC11 | Console during the run | No new app errors | Only Chrome-extension "message channel closed" exceptions; no app errors | Passed | |
| TC12 | Wire / Virtual Card / Recurring / QuickBooks tabs | Same behaviour | — | Not tested | Same shared filter component expected; not executed |

## Run 1 — Old version (V1) Payments table — observation, out of scope
- V1 `/manage/payments-table/index` and `/check` "Select Payee" (ng-select): no tooltip, 170×281 px panel, 240 px list — identical to staging V1. The change was not made to the V1 screen.
- V1 page-load console error (pre-existing, not ticket-related): `TypeError: Cannot read properties of undefined (reading 'x')`.
- Evidence: OBS-v1-*.png/jpg
