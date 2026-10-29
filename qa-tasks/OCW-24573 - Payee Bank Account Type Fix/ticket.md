# OCW-24573 — Fix Incorrect Bank Account Type in Bank Account Information Modal-backend

- Type: Sub-task (label: Backend) · Status at test time: In QA · Assignee: NASIYA MK
- Parent: OCW-24572 — Enable editing of check account holder name after instant bank verification (Completed)
- Sibling: OCW-24571 (frontend, Completed)
- Description: none on the ticket.
- Issue as described by QA (user): when adding a payee bank account, the account type was saved/returned
  as `1` regardless of the selected type. Fix: the selected account type is now stored and shown.
- Build under test: staging frontend calling `https://ocw-24573-nasiya.api.ocw.sebipay.com/api/v4/…`
- Jira transition for QA Pass: "QA to QA Pass" (id 61)
