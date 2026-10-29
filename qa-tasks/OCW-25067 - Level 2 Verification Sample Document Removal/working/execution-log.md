# OCW-25067 — execution log

Source: the QA tester ran these cases manually on staging and reported them all working (26 Oct 2026).
Evidence: the tester's Loom video (Jira comment 120095). Claude did not run tests in the browser.

| ID | Scenario | Expected | Actual (reported by tester) | Status | Evidence / notes |
|---|---|---|---|---|---|
| TC01 | Formation document step | Generic sample section not shown | Not shown | Passed | Loom |
| TC02 | Generic PDF download | No download option | None | Passed | Loom |
| TC03 | "View examples" | State-specific examples shown | Shown | Passed | Loom |
| TC04 | Rest of Level 2 workflow | Outdated sample nowhere | Not found | Passed | Loom |
| TC05 | Upload formation document | Works as before | Works | Passed | Loom |
| TC06 | Submit Level 2 | Works as before | Works | Passed | Loom |
| TC07 | Layout after removal | No gap or misalignment | OK | Passed | Loom |
