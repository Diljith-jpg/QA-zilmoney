# OCW-24700 — Execution log

- Date: 2026-10-16 · Env: Staging web https://staging.web.ocw.sebipay.com/ · API: ocw-24700-danish.api.ocw.sebipay.com (dev build for this ticket)
- Company: "Diljith NEW" (user signed in) · Browser: Chrome (Claude in Chrome), 1568px viewport
- New UI = /v4/manage/payments-out/detailed/all (Payments Out) · Old UI = /manage/payments-table/... (Classic)

| ID | Scenario | Expected | Actual (observed) | Status | Evidence / notes |
|---|---|---|---|---|---|
| TC01 | New UI · Payments Out → All · Source = WALLET + Status = Check › Mailed | Only wallet-sourced mailed checks listed | 3 results, all Source wallet (Master Wallet, diljith rr ×2), all status Mailed: alan $35 (16-Oct), alan $38 (14-Oct), Alan bb $80 (14-Oct). POST /ag-grid/62 → 200 | Passed | TC01-newUI-wallet-mailed-filter.jpg |
| TC02 | New UI · Reference ID on wallet mailed checks (grid + detail panel) | Reference ID populated | $35 Master Wallet → Ref 13606 (grid, header "Ref: 13606", Payment details); $38 diljith rr → Ref 13529 (same 3 places) | Passed | TC02-newUI-ref-13606-detail.jpg, TC02-newUI-ref-13529-detail.jpg |
| TC03 | New UI · Reference ID on wallet mailed check Alan bb $80 (diljith rr, created 10/14/2026 11:54 am, mailed 11:56 am) | Reference ID populated | Reference ID blank in grid and in detail panel Payment details; header has no "Ref:" | Failed (under investigation) | TC03-newUI-80-AlanBB-refid-blank.jpg; Txn ID 3b14695e-… |
| TC00 | New UI · Check tab → Mailed chip | Mailed checks listed | Rows listed, all status Mailed (bank checks). POST /ag-grid/1 → 200 | Passed | screenshot only (not saved) |
| TC04 | New UI · Wallet MAIL payment $126 Alan bb (diljith rr, created 10/14 10:50 am, mailed 10:52, Completed 11:09) | Reference ID populated | Reference ID blank (grid + panel). Status Completed, so correctly not in Mailed filter | Failed (Ref ID) | TC04-newUI-126-AlanBB-completed-refid-blank.jpg; Txn f795610d-… |
| TC05 | New UI · Completeness: Source=WALLET + Type=Mail, Status=All (125 rows, 3 pages) vs Mailed filter | Every Mailed row appears in Mailed filter | Page1: 3 Mailed (13606, 13529, $80); page2: 0 Mailed (Completed 10, Processing 24, Pay 15, Failed 1); page3: 0 Mailed (Processing 15, Completed 10). Mailed filter = same 3 → complete | Passed | TC05-newUI-wallet-type-mail-all-status.jpg |
| obs | Wallet ledger (Wallets → diljith rr): PYMT SENT/MAIL rows ($38 txn 79608, $80 txn 79602, $126 79588) show no Check No; wallet CHECK ISSUED rows carry serials 13534–13542 | — | Ref IDs 13529/13606 fall in the wallet check serial sequence | info | page text only |
| obs | Other wallet MAIL rows with Ref ID: "Wallet payee" $20 diljith rr (created 10/10, updated 10/14 2:42 pm, Completed) → 13550; Email Check $15 Master Wallet → 13607 (matches wallet ledger CHECK ISSUED Check No 13607) | — | — | info | TC05 screenshot |
| TC06 | New UI · All tab · Source=BANK + Status=Check › Mailed | Only bank mailed checks; Ref ID = check # | 28 rows, all Mailed, all bank sources; 0 rows with blank Reference ID (e.g. 2231209, 104385, 900) | Passed | TC06-newUI-bank-mailed.jpg |
| TC07 | Old UI (Switch to Classic) · Payments → All · Source=WALLET + Status=Mailed (native select) | Same wallet mailed set as new UI | Same 3 rows: alan payeee 35.00 (13606, Master Wallet), alan payeee 38.00 (13529, diljith rr), Alan bb 80.00 (Ref blank, diljith rr) | Passed (filter) / Ref blank on $80 as TC03 | TC07-oldUI-wallet-mailed-filter.jpg |
| TC08 | Old UI · Payment View for 13606 | Reference ID visible | Old Payment View page has no Reference ID field (MAIL, WALLET, Master Wallet, statement Mailed, Txn 608fed97-…). Code: v3-payment-view has no Reference ID label → by design, grid only | Not tested (no field) | TC08-oldUI-payment-view-13606.jpg |
| TC09 | Old UI · fresh load · Status=Mailed then Source=BANK | Mailed total = bank + wallet; bank rows have Ref | Mailed alone: 31 rows; +BANK: 28 rows all Mailed, 0 blank Ref. 28+3=31 reconciles | Passed | TC09-oldUI-bank-mailed.jpg |
| TC10 | Check tab → Mailed (old and new UI) | Mailed checks listed | Both: 28 rows, all Mailed, bank accounts only; wallet mail checks 13606/13529 not in Check tab (Check tab has no wallet account filter) | Passed (bank) · open point for wallet | TC10-oldUI-check-tab-mailed.jpg |
| OBS1 | Old UI · after browser Back from Payment View, Source shows "All" while grid still wallet-filtered; then choosing BANK showed Status "Mailed" but grid returned 2604 rows of all statuses | Filter UI and applied filter agree | Mismatch after Back only; not reproduced on fresh load (TC09) | Observation | OBS-oldUI-after-back-filter-not-applied.jpg |
- Console: no errors on old Payments page or new Check tab after filtering. All /ag-grid calls 200.
- No records created, edited or deleted during this run.

## Re-assessment 2026-10-16 (QA clarification, no re-execution)
- QA (user) confirmed: before the fix, Reference ID was not stored for mailed checks; the change applies to checks mailed after the fix, with no backfill. TC03/TC04 rows ($80, $126 Alan bb, both mailed 10/14 before 12:09 pm) are pre-fix records → observed blank Reference ID matches the expected behaviour → re-classified Passed. Verdict changed to QA Pass.
- 2026-10-16: at user's request, Not-tested cases (Classic Payment View Reference ID; AC1 original-number persistence) removed from the report table; Check tab case renumbered TC09.
