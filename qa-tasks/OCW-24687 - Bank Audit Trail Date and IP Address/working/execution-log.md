# OCW-24687 — Execution log
Env: https://ocw-24687-davood.web.ocw.sebipay.com (dev test link, branch OCW-24687-DAVOOD) · Chrome · signed in by user · company "Diljith NEW" · 2026-10-13
Path: My Accounts → Bank Accounts → account "Daniel" (****6572) → Audit Trail tab (v3.5 UI)

| ID | Scenario | Expected | Actual (observed) | Status | Evidence / notes |
|---|---|---|---|---|---|
| TC01 | v3.5 Audit Trail loads via menu | Table loads, no console errors | 15 rows loaded; headers Date, Status, By, Device, Notes; no console errors | Passed | screenshot ss_57675cqvy |
| TC02 | v3.5 IP address shown per entry | IP visible for each applicable entry | 15/15 rows show an IPv4 value (e.g. 202.83.51.210); 0 empty | Passed | DOM check |
| TC03 | v3.5 Date and time on a single line (AC1) | Date + time on one line | Date and time render on TWO lines in all 15 rows (date 13.5px; time 10px grey on second line; row height 58px). Matches dev's design note but contradicts AC "Date and time must display on a single line" | Failed | DOM: dateLines=2 for 15/15; open point for PO/dev |
| TC04 | v3.5 column header for IP | Header identifies the IP value | Header still reads "Device" while cells show an IP address; device name no longer shown | Failed | heads=[Date,Status,By,Device,Notes] |
| TC05 | v3.5 By column single line | Name on one line | "Diljith" on one line | Passed | |
| TC06 | v3.5 second account (chandi nick ****7444) | Same behaviour | IP in all rows, date/time on two lines; API GET /api/v4/bank-accounts/{id}/activities → 200 | Passed (IP) | ss_0070mcuc0 |
| TC07 | V4 (Version 2.0) Audit Trail loads via menu (Accounts → Bank Accounts → Audit Trail) | Table loads, no console errors | 15 rows; headers DATE, STATUS, BY, DEVICE, NOTES; no console errors; no horizontal scroll | Passed | ss_846359egu |
| TC08 | V4 IP address shown per entry | IP visible per entry | 15/15 rows show IPv4; 0 empty | Passed | DOM check |
| TC09 | V4 Date and time on a single line (AC1) | One line | Two lines in 15/15 rows (date 12px; time 10px grey below) — contradicts AC1 | Failed | DOM check |
| TC10 | V4 column header for IP | Header identifies IP | Header still "DEVICE"; device name no longer shown | Failed | |
| TC11 | V4 other columns alignment/readability (AC4) | No misalignment | Status/By/Notes aligned, By on one line, Notes readable at 1920 | Passed | |
| TC12 | Responsive widths (1280/1024/768) | Date on one line, IP visible | resize_window did not change the page viewport (innerWidth stayed 1920) — could not test | Not tested | tool limitation |
| OBS1 | Observation (not ticket scope) | — | One entry "Bank account has been verified" (05/29/2026) has an empty By value in both UIs — existing data | — | pre-existing |

## Re-test — 2026-10-13 (round 2, same test link, redeployed build)
User direction: the two-line date/time layout is accepted as designed — not to be failed. Scope: IP address and Device correctness, V3 and V4.
Build now has separate columns: Date, Status, By, IP Address, Device, Notes.
Method: captured the GET /api/v4/bank-accounts/{id}/activities response body in-page (XHR hook, no headers/tokens read) and compared every row of the UI table to it, column by header.

| ID | Scenario | Expected | Actual (observed) | Status | Evidence / notes |
|---|---|---|---|---|---|
| R01 | V3 headers | IP Address and Device as separate columns | Date, Status, By, IP Address, Device, Notes | Passed | ss_2749fy1od |
| R02 | V3 IP Address matches API — 10 accounts (****6572, 8445, 7444, 5060, 6789, 3355, 7890, 4444, 5548, 3455) | UI = API ipAddress per row | 0 mismatches across all rows; API ipAddress never empty | Passed | DOM vs API |
| R03 | V3 Device matches API | UI = API deviceName; blank when API blank | 0 mismatches. Names shown where API has them ("Diljith PC", "dfdfdf" on 8445, 5060, 6789, 4444, 5548, 3455); blank where API sends "" (all of 6572, 7444, 3355, 7890) | Passed | ss_70021ubs1 (8445) |
| R04 | V3 By / Notes unaffected | UI = API | 0 mismatches | Passed | |
| R05 | V3 console | No errors | No console errors | Passed | |
| R06 | V4 headers | IP Address and Device as separate columns | DATE, STATUS, BY, IP ADDRESS, DEVICE, NOTES | Passed | ss_6987n2m12 |
| R07 | V4 IP Address matches API — same 10 accounts (fresh page load, one account at a time) | UI = API ipAddress per row | 0 mismatches; API ipAddress never empty | Passed | DOM vs API |
| R08 | V4 Device matches API | UI = API deviceName; blank when API blank | 0 mismatches; same device names as V3 on the same accounts | Passed | |
| R09 | V4 By / Notes unaffected | UI = API | 0 mismatches | Passed | |
| R10 | V4 console | No errors | No console errors | Passed | |
| R11 | V3 vs V4 consistency | Same data in both UIs | Same row counts, IPs and device names per account | Passed | |
Notes: Device is blank wherever the API sends deviceName "" (mostly older entries, e.g. all of ****6572 and ****7444). The frontend renders exactly what the API returns; whether older entries should have a device recorded is a backend/data question, not this build. Today's entries on ****8445 (10/13/2026 01:17–01:18 pm) show IP 49.47.197.137 and device "Diljith PC", so new activity records both values.
Responsive widths: still Not tested (the tool cannot change the viewport).
