# Draft defects — OCW-24258 (not filed in Jira; awaiting approval)

## BUG01 — Payee view: "Added" date disappears from header after Edit → Update
- Environment: https://ocw-24008-davood.web.ocw.sebipay.com (dev build OCW-24008), Chrome, company ARJUN 2, 29 Sep 2026
- Steps: Payees → click view (eye) on "ABC TEST PAYEE 123" → header shows "Added: 04/01/2026 · Location: New York, KL" → ⋮ → Edit → Update (no changes) → "Success! Payee Updated." → panel reloads
- Expected: header still shows "Added: 04/01/2026"
- Actual: header shows only "Location: New York, KL"; Added line missing (confirmed in DOM text). Closing and reopening the panel restores it.
- Reproducibility: 1/1
- Severity: Low (cosmetic, self-corrects on reopen)
- Evidence: evidence/OCW-24258-BUG01-added-date-missing-after-update.jpg
