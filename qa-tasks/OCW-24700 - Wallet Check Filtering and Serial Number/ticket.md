# OCW-24700 — Wallet Check Filtering and Serial Number Inconsistency

- Type: Task (raised as Bug, P2) · Status: In QA · Assignee: Danish k · Reporter: Ansha Shirin
- Linked issues: none

## Reported
- Wallet checks sometimes display a different serial number than when originally issued.
- Filtering Payment Out by Wallet, then status "Mailed", does not show all mailed checks from that wallet.

## Acceptance criteria (from ticket)
1. Wallet checks consistently display the original serial number.
2. Filtering by Wallet then "Mailed" displays all mailed checks issued from that wallet.
3. Filtering works correctly for both wallet and bank account checks.

## QA brief from user (2026-10-16)
- Fix: Mailed status filter on Payment Out now returns mailed records.
- For Mailed checks, a reference ID is now populated in the Reference ID field.
- Test on both new and old UIs: Wallet + Mailed filtering, and reference ID on the respective wallet check (mail).

## Open points
- Ticket speaks of "serial number"; dev change (per user) is "reference ID". Confirm the reference ID field is the intended fix for AC1.
