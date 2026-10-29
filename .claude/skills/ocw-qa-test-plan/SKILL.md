---
name: ocw-qa-test-plan
description: Create the QA Test Plan (QA Scheduled phase) for an OCW / Zil Money Jira ticket — reads the QA ticket and its linked dev ticket, maps the change to the Angular frontend repo, and produces <ID>_QA_Test_Plan.pdf in the Zil Money house layout (task summary, objective, scope, acceptance criteria, approach, grouped test cases, regression, traceability, entry/exit). Use when the user shares a Jira ID and asks for a test plan, QA schedule, "QA Scheduled" document, or test case document.
---

# OCW QA Test Plan (QA Scheduled)

Produces the document modelled on `OCW-24254_QA_Test_Plan.pdf`. The plan **is** the test case
document — test cases live in section 6; there is no separate test case file.

Simple tickets may skip this skill entirely and go straight to `ocw-qa-test-report`.

## Hard rules

- **Jira is read-only unless the user approves.** Reading issues is fine. Posting a comment,
  adding a checklist, attaching a file, or moving status requires asking the user **every time**,
  showing exactly what will be posted. Approval for one action never carries to the next.
- **Never invent a requirement.** If an acceptance criterion is missing, ambiguous or contradicts
  the design, write it as an open point (and ask the user) — do not silently resolve it.
- Every case in a plan starts as `Not tested`. The plan never claims a result.
- Never put credentials, tokens, full account numbers or real PII in the document.

## Workflow

### 1. Read the ticket
- Load `mcp__jira__jira_get_issue` via ToolSearch and fetch the ticket the user gave (QA task).
- Follow links / parent / "relates to" to the **development task** and fetch it too. The dev
  ticket's Implementation Guidelines / description is the usual source of acceptance criteria.
- Note design references (Figma, HTML design files, UX task links). If a design file is linked
  but not accessible, ask the user for it (they may have it in Downloads).
- HTML design files are usually JS bundles — read them in Chrome, not as text. Claude in Chrome
  cannot open `file://` URLs, so copy the file to `working\design\` and serve it (run in background,
  stop it when done):
  `powershell -ExecutionPolicy Bypass -File C:\OCW-QA\qa-tools\serve-design.ps1 -Root "<task>\working\design"`
  → `http://localhost:8765/<file>.html`. Then `get_page_text` for every frame's content, click
  through interactive parts (tabs, toggles) the frames don't show, and read computed styles with
  `javascript_tool` for the typography cases.
- When the dev ticket has no acceptance criteria, derive them from the design frames and say so
  in section 4 ("To be confirmed with the PM").
- If Jira access fails, ask the user to paste the ticket text.

### 2. Set up the task folder
Tasks live in `C:\OCW-QA\qa-tasks\`. Folder name: `<TICKET-ID> - <Short Title>` (strip characters
illegal in Windows paths).

Before creating a new folder, grep existing `qa-tasks\*\ticket.md` for the linked **dev task ID** —
if another QA ticket for the same dev task already has a folder, reuse it and tell the user.

```
qa-tasks\<ID> - <Title>\
  ticket.md                  QA ticket + linked dev ticket, captured verbatim (summary, description, AC, links, design refs)
  <ID>_QA_Test_Plan.pdf      output
  evidence\                  screenshots / GIFs / notes from Chrome
  working\                   HTML source of each document, execution-log.md
```

### 3. Map the change to the frontend repo
Repo: `C:\OCW-QA\angular-web.onlinecheckwriter.com` (read `CLAUDE.md` there once per session).
- Find the affected modules/components/routes (`src/app/modules/<feature>/`, `-v4` = new version,
  `src/app/app-routing.module.ts` for routes). Name them in section 3.1, as the sample does.
- For V4 UI work, the repo skills `v4-detail-panel`, `v4-data-table-ui` and `v4-angular` hold the
  expected fonts, sizes, weights, colours and patterns — use them for typography/spacing cases.
- Identify shared components the change touches → these drive the regression section.
- Optional but valuable: open the page on staging in Chrome (`ocw-qa-test-report` skill, "Chrome"
  section) to capture the current baseline. Observed behaviour wins over code; note differences.
- The backend repo may be added later; when present, use it for API/permission cases.

### 4. Write the plan
Copy `C:\OCW-QA\qa-tools\templates\test-plan.html` to `working\<ID>_QA_Test_Plan.html` and fill it.
Set both meta tags: `qa-header` = `QA Scheduled · <ID>`, `qa-footer` =
`Internal — Confidential  ·  Zil Money — <ID> QA Test Plan`.

Sections — keep this order and numbering:

| # | Section | Content |
|---|---|---|
| — | Masthead | Eyebrow `QA Test Plan · QA Scheduled`; title = feature — change; meta `QA task <ID> · Dev task <DEV-ID> · <Interface> · <date>` |
| — | Purpose card | One sentence: what will be tested, how, and against what |
| 1 | Task summary | QA Task, Development Task, Modules, Interface, Design Reference, Status `Pending` |
| 2 | Objective | What the dev task changes; what QA will confirm; "differences raised as open points" |
| 3 | Test scope | 3.1 In scope (table: page · component · view component · design source, + "checks applied to every page" bullets); 3.2 Out of scope with reasons |
| 4 | Acceptance criteria | AC01… derived from the ticket — say which section of which ticket |
| 5 | Test approach | Bold-label bullets: design comparison, functional, responsive, regression, browsers, special notes |
| 6 | Test cases | Grouped 6.1, 6.2 … (e.g. open/close, header/actions, content, page-specific, typography, responsive, states/dark mode, edge & negative, security & compliance). IDs TC01… continuous across groups. Status `Not tested` |
| 7 | Regression scope | RT01… what is checked and why it could be affected |
| 8 | Traceability matrix | Each AC → TC ranges → RT IDs. Every AC must map to ≥1 case |
| 9 | Entry and exit criteria | Entry: dev-complete on staging, unit test evidence, design/test data available. Exit: all executed, no open Critical/High, report delivered with QA Pass |

**No "Open points" section in the plan** (user preference, 29 Sep 2026). Where a rule is undefined,
word the case's expected result as "… to confirm with PM". List the open questions in
`ticket.md` and in the hand-over message to the user instead.

Case writing rules:
- **Test Scenario** = the action; **Expected Result** = observable outcome, specific (exact message
  text, px/weight/colour where the design gives them), never "works correctly".
- Minimal sufficient coverage: one case per distinct behaviour; no duplicates that differ only by data.
- Scale to the ticket. A UI redesign across four pages justified ~85 cases; a one-line bug fix
  needs a handful. Do not pad.
- Include security/PII and permission cases whenever the screen shows money, bank or payee data.
- Include responsive widths (1920, 1536, 1280, 1024, 768, 390) and dark mode for UI tickets.

### 5. Render and review
```
powershell -ExecutionPolicy Bypass -File C:\OCW-QA\qa-tools\render.ps1 -Html "<task>\working\<ID>_QA_Test_Plan.html"
```
Writes `<ID>_QA_Test_Plan.pdf` into the task folder. Then **Read the PDF** and check every page:
header/footer present, no table split badly, no placeholder (`…`, `OCW-00000`) left. Fix and re-render.

DOCX: add `-Docx` only if the user asks — it drives Word via COM and can hang on a hidden Word
dialog. Run it in a separate process with a timeout; if it hangs, kill the WINWORD process that
render started (check StartTime) and deliver PDF only.

### 6. Hand over
Tell the user the file path, the number of ACs / cases / regression checks, and list open points.
Then **ask** whether they want anything posted to Jira — never post without a yes.
