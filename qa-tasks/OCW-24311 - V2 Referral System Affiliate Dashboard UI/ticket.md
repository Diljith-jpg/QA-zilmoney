# OCW-24311 — QA Scheduled: V2 Referral System UI Implementation (Dashboard)

| Field | Value |
|---|---|
| QA task | OCW-24311 (Sub-task, To Do) — assignee JAS MON T — parent OCW-22812 QA Scheduled — Net Revenue-Based Referral System |
| Dev task | OCW-24304 V2 Referral System UI Implementation (Dashboard) — In Progress — Davood Ibrahim — label Frontend |
| Dev parent | OCW-22811 Development — Net Revenue-Based Referral System (subtasks: OCW-22917 DB & schema Done; OCW-22918 Superadmin settings/dashboard/payout release On-Hold; OCW-23163 Net revenue calc Done; OCW-23864 Referral link for Trade Credit Services Done; OCW-24210 Cost breakdown NP & TP To Do) |
| UX task | OCW-22810 UI/UX — Net Revenue-Based Referral System (Done) |
| Design | "Affiliate Dashboard - States (2).html" (attached to OCW-22810 on 29 Sep 2026, user copy in Downloads) → working/design/affiliate-dashboard-states.html |

## Description (verbatim, OCW-24304 and OCW-24311)
"mplement Referral System UI in ZilMoney V2 Based on Approved Designs"

No acceptance criteria in either ticket — ACs in the plan are derived from the design state frames.

## Design frames (from the HTML)
- A · Desktop light 1536×840: A1 empty state · A2 populated · A3 Request to payout · A4 Payout request submitted · A5 Withdrawal history (new pending) · A6 Share referral link · A7 Commission structure · A8 Credit adjustment information · A9 Coupon enabled · A10 Terms and conditions
- B · Desktop dark: B1 populated · B2 empty · B3 payout modal · B4 share
- C · ≤785px light: C1 populated reflow · C2 navigation drawer · C3 payout modal · C4 withdrawal history cards
- D · ≤785px dark: D1 populated · D2 payout modal
- Earnings tab not shown as a frame; clicking it in the design shows Date / Referral / Commission / Amount / Status.

## Existing implementation (staging repo, regression baseline)
- Route `manage/affiliate` (classic) and `v4/manage/affiliate` → `modules/more/more.module`
- Components: affiliate-pap-dashboard, affiliate-pap-insight, affiliate-pap-my-link, affiliate-pap-set-coupon, affiliate-pap-dashboard-table, affiliate-pap-welcome, affiliate-join, affiliate-tree; modals request-to-payout-modal, share-referral-link, affilate-terms-and-condition; pages affiliate-pap, affiliate-report, referal-activity
- Coupon code: required, minLength 4, maxlength 10; credit chosen from getAvailableDiscounts (dropdown)
- Payout: amount prefilled; server errors shown as warning alert

## Open questions for PM / UX / Dev (not in the plan — user preference)
1. Confirm AC01–AC11 derived from the design (ticket has none).
2. Payout: "greater than $100" — is $100.00 allowed? Max = approved balance? Decimals?
3. Withdraw state when approved balance is > $0 but ≤ $100.
4. Coupon rules: code length/characters (existing 4–10), case sensitivity, credit range (tiers end at $450); design uses free-text credit vs existing server list — API support?
5. Coupon status toggle effect; can a coupon be deleted; Applied users "0" vs "—".
6. Edit (✎) on referral link — what can change?
7. Share: what Email / SMS / WhatsApp open and the message text.
8. Earnings tab has no frame; footer "1–5 of 46" with 4 rows.
9. Click details shows full visitor IP addresses — compliance OK?
10. Back arrow destination; do tab filters persist across tabs?
