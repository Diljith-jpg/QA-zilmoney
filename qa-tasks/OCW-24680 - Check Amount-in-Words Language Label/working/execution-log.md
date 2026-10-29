# OCW-24680 — Execution log
Env: https://ocw-24680-hari.web.ocw.sebipay.com (dev test link) · Chrome 1920 · signed in by user · company "Diljith NEW" · 2026-10-13
Nothing saved: dropdown opened and closed with Escape; value left as English.

| ID | Scenario | Expected | Actual (observed) | Status | Evidence / notes |
|---|---|---|---|---|---|
| TC01 | V4 field label (Settings → App Settings → General) | Label "Check Amount-in-Words Language" | Label still reads "Language *" (DOM: `<label>Language <span>*</span><lucide-icon …>`) | Failed | OCW-24680-TC02-v4-tooltip.jpg |
| TC02 | V4 tooltip on info icon hover | Tooltip explains purpose (suggested text) | Info icon next to label; hover shows "Select the language used to write the check amount in words. This setting does not change the application language" (mattooltip, position right). Text matches suggestion except missing final "." | Passed | OCW-24680-TC02-v4-tooltip.jpg |
| TC03 | V4 options | English and French kept | Dropdown lists English, French; current value English | Passed | OCW-24680-TC03-v4-options.jpg |
| TC04 | V4 console | No errors | No console errors | Passed | |
| TC05 | V3 field label (Settings → Application Settings → General) | Label "Check Amount-in-Words Language" | Label still reads "Language *" | Failed | OCW-24680-TC06-v3-tooltip.jpg |
| TC06 | V3 tooltip on info icon hover | Tooltip explains purpose | Same tooltip text as V4 (missing final "."), position right | Passed | OCW-24680-TC06-v3-tooltip.jpg |
| TC07 | V3 options | English and French kept | English, French; value English | Passed | OCW-24680-TC07-v3-options.jpg |
| TC08 | V3 console | No errors | No console errors | Passed | |
Pending user decision: label rename (required change #1) not implemented in either version.

## Jira writes (approved by user)
- 2026-10-13: Checklist Text on OCW-24680 set to "# QA Failed Test Cases" with 2 open items (TC03 V4 label, TC06 V3 label). Read back: Checklist 0/2, Not Completed.
- 2026-10-13: Status transitioned In QA → QA Failed (transition 301) at user's request. Confirmed status QA Failed.
