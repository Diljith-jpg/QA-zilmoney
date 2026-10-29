# OCW-24805 — Display AML screening results on the SEON AML Analysis screen

- Type: Task (System Improvement, P2) · Status at QA: In QA · Priority: Medium
- Assignee: Midhun Binoy · Reporter: Nihad (raised from ATS)
- Attachment: OCW-24805-unit-test-report.md (dev)
- QA comment on ticket: test video (Loom) posted by QA on 20 Oct 2026

## Problem
Reviewers open "SEON Status" → "SEON AML Analysis" during transaction verification. The AML Screening
section sits under "Payer Information" and must be expanded to see screening info (extra clicks).

## What needs to be done
- Display AML screening status by default on the SEON AML Analysis screen.
- Clearly indicate "Matches Found" or "No Matches" based on the screening response.
- Display relevant match information directly on the screen if matches exist.
- Clearly identify pending or unavailable screening results.

## Acceptance criteria
1. AML screening results are visible by default when the SEON AML Analysis screen opens.
2. The result clearly indicates Matches Found or No Matches, based on the screening response.
3. When matches exist, the relevant match information appears within the same screen without additional clicks.
4. Pending or unavailable screening results are clearly identified and are not displayed as No Matches.

## Suggestions (not acceptance criteria)
- Visual cues (e.g. colour-coding) for matches.
- Investigate performance impact.

## Open question (from ticket)
- Is there a specific API endpoint to retrieve AML screening results for a transaction ID?
