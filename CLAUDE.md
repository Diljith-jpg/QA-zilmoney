# OCW QA workspace

QA workspace for OnlineCheckWriter / Zil Money. The user is a QA engineer; Claude assists with
test planning, browser testing and QA documents.

## Layout
- `angular-web.onlinecheckwriter.com/` — frontend repo (Angular 17). **Read-only for QA** — never
  edit, commit or run install/build in it. Its own `CLAUDE.md` and `.claude/skills/` (v4-detail-panel,
  v4-data-table-ui, v4-angular) describe modules and the V4 design system.
- Backend repo — to be added.
- `Zi-Money-Agentic-QA-Guide.md` — the company QA process guide (principles, status vocabulary,
  security boundaries). Follow it.
- `qa-tools/` — `render.ps1` (HTML → PDF via headless Chrome; `-Docx` opt-in via Word, can hang),
  `qa-doc.css` house style, `templates/` for the plan and report.
- `qa-tasks/<TICKET-ID> - <Short Title>/` — one folder per ticket: `ticket.md`, the PDFs,
  `evidence/`, `working/` (HTML sources, `execution-log.md`). QA tickets for the same dev task share
  one folder.

## Skills
- `ocw-qa-test-plan` — QA Scheduled: test plan PDF (includes the test cases).
- `ocw-qa-test-report` — test on staging in Claude in Chrome, then the test report PDF. Simple
  tickets go straight here without a plan.
- Checklist — sample pending from the user.

## Rules
- **Jira: read freely; ask before every write** (comment, checklist, attachment, transition, new
  bug). Show the exact content. Approval never carries over to the next action.
- Test only on staging: https://staging.web.ocw.sebipay.com/ — never production.
- The user signs in; Claude never types or stores credentials.
- No "Passed" without observing it in the browser in this run. Unexecuted = `Not tested`/`Blocked`.
- Don't invent requirements — ambiguities become open points / questions.
- No secrets, tokens, full account numbers or real PII in any document or evidence.
