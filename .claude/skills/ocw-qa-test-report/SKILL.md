---
name: ocw-qa-test-report
description: Execute QA testing for an OCW / Zil Money Jira ticket on staging using Claude in Chrome, log results as they are observed, and produce <ID>_QA_Test_Report.pdf in the Zil Money house layout (task details, overview, issue/requirement, changes, testing & verification, test cases executed, conclusion with QA Pass / QA Fail / QA Blocked). Use when the user shares a Jira ID and asks to test it, run QA, verify a fix, or write/prepare the test report — with or without an existing test plan.
---

# OCW QA Test Report (testing + report)

Produces the document modelled on `OCW-24258_QA_Test_Report.pdf` / `OCW-24284_QA_Test_Report.pdf`.
Works in two modes:
- **Planned ticket** — a `<ID>_QA_Test_Plan` already exists in the task folder: execute its cases.
- **Simple ticket** (no QA schedule) — derive a short case list from the ticket, then execute.

## The Iron Law

```
NO "Passed" WITHOUT OBSERVING IT IN THE BROWSER IN THIS RUN
```

Reading code is not testing. A case not executed is `Not tested` (or `Blocked`, with the reason) —
never `Passed`. A partial pass is `Failed` with the deviation described. The verdict must match
the table: any `Failed` on a core case → `QA Fail`; untestable core cases → `QA Blocked`.

## Hard rules

- **Jira writes need approval every time** — comments, checklists, attachments, status moves,
  bug creation. Show the exact text first; wait for a yes. Reading Jira is fine.
- **Staging only**: `https://staging.web.ocw.sebipay.com/`. Never production.
- **The user logs in.** Never type passwords or handle credentials. If a login page appears, stop
  and ask the user to sign in in Chrome.
- Don't create, edit or delete real-looking financial records beyond what a case needs; note every
  record you created (ID/name) in the execution log so it can be cleaned up.
- Destructive actions (Delete, Void, Cancel payment) and anything that opens a native browser
  `confirm()` dialog: warn the user first — a native dialog freezes the Chrome extension.
- Report pre-existing defects unrelated to the ticket separately (as observations), not as this
  ticket's failure.

## Workflow

### 1. Ticket and folder
- Fetch the ticket (and linked dev task) with `mcp__jira__jira_get_issue` (load via ToolSearch).
- Find or create the task folder under `C:\OCW-QA\qa-tasks\` exactly as described in the
  `ocw-qa-test-plan` skill (step 2) — reuse an existing folder for the same dev task. Write/refresh
  `ticket.md`.
- If a test plan exists in the folder, its cases are the execution list. Otherwise draft a short
  list (scenario + expected result) from the ticket and show it to the user before executing when
  the ticket is ambiguous.

### 2. Chrome
Read the `anthropic-skills:chrome-browser` skill first, then load the tools in one ToolSearch call:
`tabs_context_mcp, tabs_create_mcp, navigate, computer, read_page, find, form_input,
read_console_messages, read_network_requests, gif_creator, resize_window, javascript_tool`
(all `mcp__claude-in-chrome__*`).
- `tabs_context_mcp` first, then open a **new tab** on staging. Confirm the user is signed in and
  which company is active before acting.
- Navigate through the app menu at least once per flow (deep links can skip guards).
- Keep console/network in view: run `read_console_messages` (pattern for errors) after key steps —
  a console error or failed request during a "pass" is still a finding.
- Responsive: `resize_window` to the widths the plan lists (1920, 1536, 1280, 1024, 768, 390).
- Dark mode / version switch: use the app's own toggle.
- Typography checks: use `javascript_tool` to read `getComputedStyle(el)` (font-family, size,
  weight, colour) instead of eyeballing.
- Evidence: take a screenshot at each key state; use `gif_creator` for multi-step flows and any
  failure; save downloadable evidence to `evidence\` when possible, named `<ID>-TC07-<what>.png/.gif`.
  If a capture cannot be saved to disk, describe what was observed in the log — never claim a file
  that does not exist.
- If the extension is disconnected or a step fails 2–3 times, stop and tell the user.

### 3. Log while testing
Append to `working\execution-log.md` **immediately after each case**, before the next one:

```
| ID | Scenario | Expected | Actual (observed) | Status | Evidence / notes |
```
Statuses: `Passed` · `Failed` · `Blocked` · `Not tested`. For `Failed`, record steps to reproduce,
exact message text, console/network errors, and the data used.

For a bug-fix ticket: reproduce the original issue first where possible (before/after), then verify
the fix, then re-run the negative cases around it.

### 4. Defects
When a case fails: re-run it, check preconditions and test data, confirm it is not an environment
issue. Then draft the bug (title, environment, steps, expected, actual, severity, evidence) in
`working\bugs.md` and **ask** the user before creating anything in Jira.

### 5. Write the report
Copy `C:\OCW-QA\qa-tools\templates\test-report.html` to `working\<ID>_QA_Test_Report.html`.
Meta tags: `qa-header` = `ZIL MONEY  |  QA TEST REPORT`; `qa-footer` = `<ID> | <Module — Area> | Internal`.

Sections — this order, **no section numbers**:

| Section | Content |
|---|---|
| Masthead | Eyebrow `QA Test Report`; title `<ID> — <issue / feature>`; meta `Module: … · Environment: Staging · <date>` |
| Purpose card | One sentence: "Confirm that …" |
| Task Details | Field/Detail table: Task ID, Module, Features, Environment, Status (verdict) |
| Task Overview | One paragraph: what the task covers, what was tested, outcome |
| Issue / Requirement Description | Bullets: old behaviour / what was reported; `Requirement:`; `Constraint:` if stated |
| Updates / Changes Implemented | Bullets describing the change as observed in the build |
| Testing & Verification | Sub-headed groups (per page or flow) of "Verified that …" / "Confirmed that …" bullets |
| Test Cases Executed | ID · Test Scenario · Expected Result · Status — from the execution log, TC01… |
| Defects Found | Only if something failed (commented block in the template) |
| Conclusion | What works, where verified; last line `Status: QA Pass` (or QA Fail / QA Blocked) |

Writing rules:
- Report only what was actually done and observed — the log is the source; never add a browser,
  device or case that was not run.
- Report test cases are summarised and user-readable (the sample report has 20 cases against the
  plan's 85): group many plan cases into one report row only when all of them were executed and
  passed; list any `Failed`/`Blocked`/`Not tested` case individually.
- Keep verdict words exact so they colour correctly: `Passed`, `Failed`, `Blocked`, `Not tested`,
  `QA Pass`, `QA Fail`, `QA Blocked`.
- One or two pages is normal for a small fix. Don't pad.

### 6. Render and review
```
powershell -ExecutionPolicy Bypass -File C:\OCW-QA\qa-tools\render.ps1 -Html "<task>\working\<ID>_QA_Test_Report.html"
```
Read the PDF, check every page, fix and re-render. DOCX only on request (`-Docx`, see the
`ocw-qa-test-plan` skill for the hang caveat).

### 7. Hand over
Give the user: file path, verdict, counts (passed/failed/blocked/not tested), defects, test data
left behind, and anything not covered. Then **ask** before posting a Jira comment, adding a
checklist, attaching the PDF or moving the ticket. Close the Chrome tabs you opened.

## Checklist

The QA checklist format is pending a sample from the user. Until then, when a checklist is
requested, draft it in `working\checklist.md` from the executed cases and ask before adding it to
Jira.
