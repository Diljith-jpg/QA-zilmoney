# OCW-24010 — Draft defects (NOT created in Jira — awaiting approval)
> 2026-09-30: QA accepted BUG-1..BUG-3 as expected behaviour — not raised in Jira. Kept for reference only.

Environment: https://OCW-24010-MIDHUN.web.ocw.sebipay.com (V4 / Version 2.0), Chrome, company "Diljith NEW", 2026-09-30.

## BUG-1 — Bill detail panel: "Clone Bill" action missing from ⋮ menu
- Severity: Medium
- Steps:
  1. Payables › Bills (V4) › All Bills.
  2. Click the eye icon on a Due bill (e.g. Invoice 1120) → detail panel opens.
  3. Click ⋮ (More actions) next to Pay.
  4. Repeat on a Voided bill (e.g. Invoice 856).
- Expected: Due bill menu = Print, Edit, Void, Delete, Mark As Paid, **Clone Bill**; Voided bill menu = Print, **Clone Bill**, Delete
  (reference UI ViewPanels-Latest.html; Clone Bill is also offered in the row ⋮ menu for the same bill).
- Actual: Due bill menu = Print, Edit, Void, Delete, Mark As Paid. Voided bill menu = Print, Delete. No Clone Bill.
- Evidence: OCW-24010-TC02-bill-due-actions-menu.jpg, OCW-24010-TC13-bill-voided-menu.png, OCW-24010-TC02-row-menu-has-clone.jpg

## BUG-2 — Vendor Credit detail panel: "Mark As Reconciled" missing from ⋮ menu
- Severity: Medium
- Steps:
  1. Bills › Vendor Credit.
  2. Click the eye icon on a credit with status New (e.g. Credit No 1134).
  3. Click ⋮ next to Edit.
- Expected: The panel offers the same actions the row menu enables for this credit: Edit, Void, Mark As Reconciled, Delete.
- Actual: Panel ⋮ shows Void, Delete only. Row ⋮ menu shows Edit, Void, Mark As Reconciled, Delete.
- Evidence: OCW-24010-TC32-vc-new-panel-menu.png, OCW-24010-TC32-vc-row-menu-new.png

## BUG-3 — Bill panel (Voided): Unvoid button colour differs from design
- Severity: Low
- Steps: Bills › eye on a Voided bill (Invoice 856).
- Expected: Unvoid as a red outline button (reference: border/text --v4-badge-error-text #eb2e2e).
- Actual: Unvoid rendered in brand blue (rgb(32,49,157) border and text).
- Evidence: OCW-24010-TC13-bill-voided-panel.jpg

## Observations / questions (not raised as bugs yet)
- Paid bill mango12: header shows $565.00 (bill amount) while Bill Total and grid Amount show $465.00 (after $100 credit). Which figure should the header show?
- Paid bill mango12: panel Bill To shows "David", grid Bill To shows "david bnk".
- Bill / International Payment / Vendor Credit Attachments tile: File column shows the storage path (`allattachments/bill/…`) instead of the file name (reference shows name + meta).
- Bill: audit log does not refresh after posting a comment until the panel is reopened.
- Vendor Credit: Applied-to-bills Reference shows an internal ID (`z6VoW41QW4589IK`) instead of the bill invoice no. (mango12); date format "Jul 30, 2026 – 08:10 am" differs from MM/DD/YYYY elsewhere; field labels sentence case vs Title Case on Bill/Payment Out.
- Vendor Credit (Reconciled, credit for Payee): "This credit hasn't been applied to any bills yet." while Applied amount = $52.00.
- International Payment: Send proof is offered on a Failed payment — confirm expected.
- Webhook Log panel: no response code / response body for Failed deliveries (grid Response Code column empty too).
- Bill typography: Bill Total value uses Plus Jakarta Sans (reference Funnel Display); status badge weight 400 (reference 700).
- No reference design supplied for Vendor Credit, Webhook Log, API Log.
