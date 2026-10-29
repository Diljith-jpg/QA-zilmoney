# OCW-24676 — Execution log

- Date: 13 Oct 2026 · Build: https://ocw-24676-hari.web.ocw.sebipay.com · Company: Diljith NEW (signed in by user)
- Browser: Chrome (Claude in Chrome), 1568 px viewport
- Service worker + Cache Storage cleared and page reloaded before V3.5 re-check (1 SW was registered).
- No records created/edited. Recharge dialogs opened and cancelled without submitting.

| ID | Scenario | Expected | Actual (observed) | Status | Evidence / notes |
|---|---|---|---|---|---|
| TC01 | V2.0 Wallets › All Wallets — hover "Transfer Funds" | "Transfer the funds from your wallets or accounts" | Tooltip "Transfer the funds from your wallets or accounts" (DOM text, no trailing period) | Passed | TC01-wallet-transfer-tooltip.png. User-supplied text ends with "."; UI has none — confirm |
| TC02 | V2.0 Wallets › single wallet (fgh) — hover "Transfer" | Same updated text | "Transfer money to your wallets or accounts" | Passed | TC02-single-wallet-transfer.png. Updated (destination clarified) but wording differs from TC01 — open point |
| TC03 | V2.0 Wallets › All Wallets — Recharge Credits dialog | Wallet field placeholder "Select Wallet" (not "From Wallet Account") | Label "From Wallet *", placeholder "Select Wallet" | Passed | TC03-recharge-placeholder.jpg |
| TC04 | V2.0 single wallet — Recharge, clear prefilled wallet | Placeholder "Select Wallet" | Wallet prefilled (fgh); after clearing, placeholder "Select Wallet" | Passed | TC04-recharge-single-wallet.png |
| TC05 | V2.0 Bank Accounts › All Accounts — hover "Transfer" | "Transfer the funds from your wallets or accounts" | Exactly that text | Passed | TC05-bank-transfer-tooltip.png |
| TC06 | V2.0 Bank Accounts › single account (Daniel) — hover Transfer icon | Updated text | "Transfer money to your wallets or accounts" | Passed | TC06-single-bank-transfer.png. Same wording difference as TC02 |
| TC07 | V2.0 Bills — hover "Import Bills" | "Import bills from your connected third-party apps" | Exactly that text (DOM; no trailing " .") | Passed | TC07-import-bills-tooltip.png |
| TC08 | V2.0 Bills — click Import Bills (sanity of tooltip wording vs feature) | Dialog offers connected third-party apps | Dialog "Import Payments": Connected Apps (QuickBooks Online – Connected), Connect New (Xero, Zoho Books, Bill.com, Sage, Odoo…) | Passed | TC08-import-modal-apps.jpg. Contradicts ticket note "not … from connected third-party apps" |
| OBS1 | V3.5 (classic) Wallets — Transfer tooltip & Recharge | — (not in user's scope) | Still old: "Transfer the fund from your wallet"; Recharge placeholder "From Wallet Account" (after SW/cache clear + reload) | Observation | OBS-v35-wallet-transfer-old.png. Change appears to be V2.0-only — confirm intended |
| — | Console errors on V2.0 Bills page | None | None reported | — | read_console_messages (tracking started on Bills page) |
