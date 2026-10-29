# OCW-24700 — Draft defect (NOT created in Jira — awaiting approval)

**Title:** Payments Out – Reference ID blank for some wallet Mail check payments (Mailed / Completed)

- **Environment:** Staging web (API build ocw-24700-danish), company "Diljith NEW", Chrome. Old and new UI.
- **Steps:**
  1. Payments Out (new UI, `/v4/manage/payments-out/detailed/all`) or Payments (Classic, `/manage/payments-table/index`) → All tab.
  2. Source = WALLET, Status = Check › Mailed.
  3. Look at Reference ID for "Alan bb $80.00" (wallet diljith rr, created 10/14/2026 11:54 am, mailed 11:56 am).
  4. Open the row (new UI detail panel → Payment details → Reference ID).
- **Expected:** Reference ID shows the wallet check's number, the same as the other wallet mailed checks (13606, 13529).
- **Actual:** Reference ID is blank in the grid (both UIs) and in the new-UI detail panel; the header has no "Ref:".
  The same applies to "Alan bb $126.00" (diljith rr, MAIL, mailed 10/14 10:52 am, now Completed).
  Wallet mail payments created from 10/14 12:09 pm onward do show a Reference ID.
- **Severity:** Medium (display/traceability; filter itself works).
- **Evidence:** OCW-24700-TC03-newUI-80-AlanBB-refid-blank.jpg, OCW-24700-TC04-newUI-126-AlanBB-completed-refid-blank.jpg, OCW-24700-TC07-oldUI-wallet-mailed-filter.jpg
- **Question for dev:** Is the reference ID only stored for checks mailed after the fix was deployed? If yes, should existing wallet mail checks be backfilled?

**Withdrawn 2026-10-16:** QA confirmed these are pre-fix records, so a blank Reference ID is expected (no backfill). Not a defect.
