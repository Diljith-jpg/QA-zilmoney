# OCW-24805 — Execution log

- Date: 20 Oct 2026
- Executed by: QA (manual testing by the user on staging). Claude did not run these cases in the
  browser; this log and the report record the user's reported result ("It is working fine (I have checked)").
- Evidence: QA test video (Loom) linked in the OCW-24805 Jira comment of 20 Oct 2026.
- Cases are derived one-to-one from the ticket's acceptance criteria.

| ID | Scenario | Expected | Actual (reported by QA) | Status | Evidence / notes |
|---|---|---|---|---|---|
| TC01 | Open the SEON AML Analysis screen from "SEON Status" | AML screening result visible by default, no expanding needed | Working as expected | Passed | QA test video |
| TC02 | Transaction whose screening returned no matches | "No Matches" clearly shown | Working as expected | Passed | QA test video |
| TC03 | Transaction whose screening returned matches | "Matches Found" clearly shown | Working as expected | Passed | QA test video |
| TC04 | Match details for a transaction with matches | Relevant match information on the same screen, no extra clicks | Working as expected | Passed | QA test video |
| TC05 | Screening pending or unavailable | Clearly identified as pending/unavailable, not shown as "No Matches" | Working as expected | Passed | QA test video |
