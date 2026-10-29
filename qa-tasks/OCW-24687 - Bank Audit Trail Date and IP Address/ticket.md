# OCW-24687 — Fix Audit Log Date Display and Missing IP Address

- Type: Task · Priority: Medium · Status: In QA · Assignee (dev): DAVOOD IBRAHIM · Reporter: Nihad
- Test link: https://OCW-24687-DAVOOD.web.ocw.sebipay.com (branch `OCW-24687-DAVOOD`, commit `fd42f41233`)

## Description
Improve the Audit Log table by fixing the date/time display and ensuring the IP address is shown.
Context: the Date value wraps to a second line (insufficient column space); IP Address is not displayed.

## Acceptance criteria
- Date and time must display on a single line.
- Adjust the Date column/font/spacing as needed to prevent wrapping.
- Display the IP Address for each applicable audit log entry.
- Changes must not affect alignment or readability of other audit log columns.
- Verify across screen sizes (date stays on one line, IP consistently visible).
- Original report: Loom https://www.loom.com/share/39b376bf3db4497fb08de95eb45664a9

## Dev notes (unit-test-report.md attachment)
Files: bank-accounts-details-ocw-v35 (.html/.ts), bank-details-v4 (.html/.ts).
- v4: Date uses `<app-pd-date-time>` — date line 1, time line 2. By column nowrap.
- v35: same via `splitAuditDateTime()`.
- Both: Device column cell now renders `item.ipAddress` (header still "Device").
- Dev self-test: functional NOT RUN; "Ready for QA: No".

## Open points
1. AC says date+time on ONE line; dev implemented date/time on TWO lines.
2. Device column replaced by IP but header still "Device" — is device name meant to be dropped?
