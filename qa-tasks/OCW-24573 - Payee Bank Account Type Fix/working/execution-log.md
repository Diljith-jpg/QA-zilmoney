# OCW-24573 — Execution log (09 Oct 2026, staging, Chrome)

Signed in by user · company: ashbin biju · API host: ocw-24573-nasiya.api.ocw.sebipay.com

| ID | Scenario | Expected | Actual (observed) | Status | Evidence / notes |
|---|---|---|---|---|---|
| TC01 | Payee "assshh pyee" → Bank Accounts → + New, ACH, type Personal Savings, Add | Saved; grid shows Personal Savings | POST /api/v4/payees/bank-accounts → 200; grid row shows "Personal Savings" | Passed | evidence/OCW-24573-TC01-add-personal-savings.jpg |
| TC02 | Reload Payees page, reopen payee | Type persisted as Personal Savings | Row shows "Personal Savings" after full reload | Passed | evidence/OCW-24573-TC02-after-reload.jpg |
| TC03 | Row action → Edit (Bank Account Details modal) | Account Type pre-selected = Personal Savings | Modal dropdown pre-selected "Personal Savings" | Passed | evidence/OCW-24573-TC03-edit-modal-prefill.jpg |
| TC04 | Edit → change type to Business Savings → Update, then reload | Saved and persisted as Business Savings | PUT /api/v4/payees/bank-accounts/{id} → 200; row "Business Savings", still so after reload | Passed | evidence/OCW-24573-TC04-edit-business-savings-after-reload.jpg. First attempt blocked by "Confirm Account Number – This field is required" because my input went to the wrong field (test-input issue, not a defect); modal closed without saving, retried |
| TC05 | Payee "Payee Name" (no prior accounts) → + New, type Personal Checking, Add, reload | Saved and persisted as Personal Checking | Row shows "Personal Checking" after reload | Passed | evidence/OCW-24573-TC05-add-personal-checking.jpg |
| TC06 | Console errors during the flows | None | No console errors/exceptions recorded | Passed | read_console_messages (errors only) |
| TC07 | Business Checking type | Saved as Business Checking | Not executed | Not tested | — |
| TC08 | Reproduce old behaviour (type stored as 1) on build without fix | — | Not executed; only fixed build available | Not tested | Dev Loom on ticket not reviewed by QA tool |

## Plaid flow — executed manually by QA (user), reported in chat 09 Oct 2026
Not observed by Claude; results as reported by the QA engineer.

| ID | Scenario | Expected | Actual (reported by QA) | Status |
|---|---|---|---|---|
| P01 | New design — Plaid checking | Business Checking | Business Checking | Passed |
| P02 | New design — Plaid savings | Personal Savings | Personal Savings | Passed |
| P03 | Classic design — Plaid checking | Business Checking | Business Checking | Passed |
| P04 | Classic design — Plaid savings | Personal Savings | Personal Savings | Passed |
| P05 | Type shown as name, not number | No numeric type | Correct name shown | Passed |

User asked to drop Not tested cases (TC07/TC08) from the report.

## Test data left behind (staging)
- Payee "assshh pyee": bank account routing 021000021, acct ending 3001, type Business Savings (id kM2mzeJL6y48ENb)
- Payee "Payee Name": bank account routing 021000021, acct ending 3002, type Personal Checking
