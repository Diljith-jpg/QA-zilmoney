# Zi Money

## Agentic QA Guide — Manual, API, UI & Automation

Companion to the *Zi Money Agentic Development Guide — Backend & Frontend*. Same setup, same
`specs/` convention, the same Jira ID as the bridge between Jira and the repo. The difference is
what counts as done: development proves a requirement with a **test**; QA proves it with
**executed evidence**.

Applies to OCW, Zil Money, Zil Remit, Zil Master, the OCW Mobile App, Virtual Card, and the
Admin / Super Admin / Operator surfaces.

**The Iron Law of this guide** (carried over from the team's `unit-test-report` skill):

```
NO PASS WITHOUT EXECUTION AND EVIDENCE
```

Reading code is not executing it. A green build is evidence for exactly one row: the build row.
If Claude did not run it, its status is `NOT RUN` — never `PASS`.

---

## Working principles (Karpathy's guidelines, translated to QA)

Source: https://github.com/multica-ai/andrej-karpathy-skills — the same four principles the backend
`CLAUDE.md` adopts for development, converted to the QA discipline. They bias toward caution over
speed, and toward a smaller, sharper test pass over a bigger one.

1. **Think before testing** — don't assume, don't hide confusion, surface trade-offs. State your
   assumptions about the requirement explicitly; if an acceptance criterion has more than one
   reading, present both rather than silently picking one; if an existing case or an existing
   automated test already covers it, say so instead of writing another; if something is unclear,
   stop and ask. A question before execution is cheap; a bug report rejected as "works as designed"
   is not.

2. **Minimal sufficient coverage** — the fewest cases that actually prove the requirement, nothing
   speculative: no case for a state the system cannot reach, no duplicate that differs only by test
   data, no automation for a screen still in flux, no test data beyond what a case consumes, no
   regression area selected without a reason. If 40 cases could be 15, rewrite the suite. Coverage
   is measured by what a case proves, not by how many rows the sheet has.

3. **Surgical testing** — test what the change touches; clean up only your own mess. Don't rewrite
   the existing suite while testing a ticket; don't "improve" unrelated cases or reformat them;
   match the existing case style even where you'd differ; don't expand into modules the diff never
   touched. **Report pre-existing defects separately — never fold them into this ticket's result.**
   Remove only the test data your run created, and say what you left behind. Every executed case
   traces to a requirement or to a named regression area.

4. **Evidence-driven execution** — turn the task into a verifiable goal and loop until it is met:
   "validate the fix" → reproduce the original bug first, then show it is gone; "test the feature" →
   map each acceptance criterion to a case, execute it, attach the evidence; "check for regression"
   → name the area, say why, run it, record the result. For multi-step work, state the plan as
   `step → verify` pairs, and close each one before moving on.

These are working if the suite gets smaller rather than larger, cases stop being marked `PASS` and
then reopened, invalid and duplicate bug reports drop, and clarifying questions arrive before
execution instead of after a rejected defect.

---

## 1. QA Environment Setup

Do these once per machine, then per repo you test.

1. **Install Claude Code** and sign in. Work from the repo root of the surface under test, not from
   a scratch folder.
2. **Copy the QA `claude.md`** (Section 10) into `<PROJECT_ROOT>/claude.md`. If the repo already has
   a development `CLAUDE.md`, do **not** overwrite it — add a `## QA rules` section to it instead.
   The development `CLAUDE.md` already carries rules QA must obey (the *Never* list, the tenancy
   guardrails, the environment paths). Read it before writing anything.
3. **Copy the required project files** — `specs/`, `.mcp.json`, and the shared agents/skills: the
   same bundle the development guide ships.
4. **Update the spec folder** for your machine:
   - `specs/local-environment.md` — frontend location, Laragon location, Cmder location, local
     database username/password, and the surface-specific login notes (the operator panel is
     `/classic/login` then `/manage/operator/...`; SUA is `/suaadmin/login`).
   - `specs/architecture.md` — read-only for QA; it tells you which module owns the behaviour.
   - When you learn how to reach a surface, write it back into `specs/local-environment.md` **in the
     same session**.
5. **Environments and URLs** — record these in `specs/local-environment.md`, never inside a test case:
   - `<QA_STAGING_URL>` — the staging/QA web app under test
   - `<QA_API_BASE_URL>` — the API base for that environment
   - `<QA_ADMIN_URL>` / `<QA_OPERATOR_URL>` — the admin/SUA and operator panels
   - Local, when testing a dev build: backend `127.0.0.1:8000` · portal `localhost:4200`
6. **Test credentials** — one set per actor, kept in your local env file or password manager and
   referenced in test docs as placeholders only:
   `<TEST_USERNAME>` / `<TEST_PASSWORD>` (owner) · `<TEST_SUBUSER>` · `<TEST_INVITED_CLIENT>` ·
   `<TEST_ADMIN_USER>` · `<TEST_OPERATOR_USER>`. You need at least **two companies** to test
   tenancy: `<TEST_COMPANY_A>` and `<TEST_COMPANY_B>`.
7. **Browser configuration** — Chrome as the primary browser, with the Claude browser extension
   installed and connected. Keep a clean profile for QA (no autofill, no ad blockers) and a second
   private window for logged-out and cross-account checks.
8. **Test database access**, where your role has it — **read-only**. Use Laravel Boost's
   `database-query` / `database-schema` / `tinker` tools rather than raw mysql. The development
   `CLAUDE.md` *Never* rules apply to QA without exception: never `migrate:fresh`, `migrate:refresh`,
   `migrate:reset`, `db:wipe` or `RefreshDatabase`; never `DROP`, `TRUNCATE`, or a `DELETE` without a
   `WHERE` — not in SQL, not in tinker, not in a test.
9. **API tooling** — Postman with an environment pointing at `<QA_API_BASE_URL>`. Keep the collection
   in the QA repo under `qa/api/` and the secrets in a Postman **environment**, never in the
   collection file. The API surfaces differ by actor: customer v3 (`routes/api.php`), customer v4
   (`routes/apiv4.php`), admin (`routes/sua.php`), operator (`routes/operator.php`), partner
   (`routes/partner-api.php`), developer portal (`routes/developer-platform.php`).
10. **Test data** — a prepared, reusable set per module (Step 5). Never production data.
11. **Playwright** — only where the surface already has an automation project. Check first:

    ```
    ls playwright.config.*  &&  grep -n "@playwright/test" package.json
    ```

    If it exists, use that project's language and structure unchanged. If it does not, keep
    automation in the QA repo (`<QA_AUTOMATION_ROOT>`) and agree the framework with the QA lead
    before creating it — do not scaffold a second framework inside the app repo.
12. **MCP servers, agents and skills** to have available:
    - **Laravel Boost** (`.mcp.json`) — `tinker`, `database-query`, `database-schema`,
      `list-routes`, `search-docs`, `browser-logs`. This is the MCP to use *while testing*.
    - **Atlassian MCP** — read the Jira ticket, post the QA comment, move the phase story.
    - **Browser / Chrome extension** — the real browser for UI execution.
    - **Superpowers** — `brainstorming` for requirement questions, `systematic-debugging` for
      isolating a defect before reporting it.
    - Team skills: `qc-checklist` (the QA Scheduled / In QA / QA Passed phases), `unit-test-report`
      (the status vocabulary and evidence rules), `ocw-context` (domain, tenancy, guards — load it
      before reasoning about permissions).
13. **QA-specific config** — add to the repo's `.claude/settings.local.json` only the read-only
    commands you actually run. Never commit credentials, tokens, Postman environments, or `.env`
    files.

---

## 2. QA Project Files

QA artifacts live under `specs/`, the same tracked folder the development guide uses. Jira owns
*what* and *who*; `specs/` owns *how* and *proof*. Every file carries front-matter so one grep finds
a ticket.

```
<PROJECT_ROOT>/
  claude.md                                  QA agent rules (Section 10)
  specs/
    <feature>/                               kebab-case, mirrors the module
      prd.md                                 product source of truth — §5 is the QA script
      <JIRA_TASK_NUMBER>/                    the QA working folder for one ticket
        requirement.md
        test-plan.md
        test-cases.md
        test-data.md
        api-tests.md
        execution-results.md
        bug-report.md
        regression-checklist.md
        automation.md
        qa-signoff.md
        evidence/
```

| File | Purpose |
|---|---|
| `claude.md` | The QA agent's standing instructions — what to verify, what never to touch, how to report. |
| `specs/<feature>/prd.md` | Existing product requirements. **§5 "Manual verification (QA script)" is QA's section** — extend it; do not rewrite §1–§4. |
| `requirement.md` | The ticket verbatim, the acceptance criteria, affected modules, dependencies, and the open questions. |
| `test-plan.md` | Baseline, scope, out of scope, scenario classes, regression areas, browser/device matrix. |
| `test-cases.md` | The numbered cases with steps and expected results. |
| `test-data.md` | The data each case needs, as placeholders and safe dummy values. |
| `api-tests.md` | Endpoints, payloads, status/body expectations, auth and tenancy cases. |
| `execution-results.md` | Actual results per case, with status and evidence links. Written during execution, not after. |
| `bug-report.md` | One structured entry per defect, with the Jira bug key once filed. |
| `regression-checklist.md` | The checklist of Section 9, trimmed to this ticket, with the reason each area was selected. |
| `automation.md` | What was automated, where the spec lives, how to run it, what was deliberately left manual. |
| `qa-signoff.md` | The final QA report (Section 11) and the verdict. |
| `evidence/` | Screenshots, videos, HAR/network captures, console logs, API responses, query output. |

Front-matter on every file:

```
---
feature: <feature>
jira: [<JIRA_TASK_NUMBER>]
type: qa
status: in-progress | qa-pass | qa-failed | qa-blocked
tester: <QA_ENGINEER>
environment: <QA_STAGING_URL>
updated: <YYYY-MM-DD>
---
```

`grep -rl <JIRA_TASK_NUMBER> specs/` must find every QA artifact for that ticket.

---

## 3. Starting a QA Task

1. Go to the `specs` folder and create a directory using the development guide's format:

   `{feature}/{jira-task-number}` — example: `checkprinting/OCW-1005`

   The folder name is the **feature**, never a branch or a sprint. The feature outlives both.

2. If `specs/<feature>/prd.md` does not exist, do not create one — read the Jira ticket and say so in
   `requirement.md`. PRDs belong to the development/BA track.

3. Inside `{feature}/{jira-task-number}`, Claude creates, in this order:

   1. `requirement.md` — the ask, acceptance criteria, and the questions that block testing
   2. `test-plan.md` — after the application has been inspected, not before
   3. `test-cases.md`
   4. `test-data.md`
   5. `api-tests.md` — when the feature has an API surface
   6. `execution-results.md` — filled in *during* execution
   7. `bug-report.md` — only when a failure is confirmed to be a defect
   8. `regression-checklist.md`
   9. `automation.md` — when automation was added or updated
   10. `qa-signoff.md` — last, and only after Section 12 passes
   11. `evidence/` — populated throughout

4. One ticket = one QA folder = one sign-off. If a ticket spans two repos (backend and Angular), keep
   the QA folder in the repo where the behaviour is verified and link it from the other.

---

## 4. QA Workflow

### Step 1 — Understand the Jira task

Claude reads `<JIRA_TASK_NUMBER>` through the Atlassian MCP (or the ticket text pasted in) and writes
`requirement.md` containing:

- The ask, verbatim from the ticket
- Expected behaviour, stated as observable outcomes
- Acceptance criteria, numbered — each one becomes at least one test case
- Affected modules, and the actors they serve (owner · legacy sub-user · owned company · invited
  client · admin/SUA · operator · partner)
- Dependencies: bank partner, KYC/KYB provider, card processor, notification templates, queues,
  scheduled jobs, third-party integrations
- Likely regression areas, with the reason for each
- **Open questions** — a numbered list

**Rules**

- Claude must **not** invent a missing requirement. If an acceptance criterion is absent, ambiguous,
  or contradicts existing behaviour, it goes in Open questions and that area is `BLOCKED` until
  answered.
- Distinguish "the ticket does not say" from "the ticket says nothing should happen". They are
  different test outcomes.

### Step 2 — Analyse the existing application

Before writing a single test case, inspect what is there today. QA tests a change against a
baseline, so establish the baseline first.

Claude should determine:

- Current UI behaviour on the affected screens — opened in the browser, not read from templates
- The existing end-to-end workflow the change sits inside
- Related pages that reach the same data (list, detail, edit, report, export)
- Existing client-side and server-side validations, and their exact messages
- Existing API behaviour — `list-routes` for the endpoints, then a baseline request/response each
- Existing permissions: which guard, whether `VerifyV4Permission:<permission>` is on the v4 route,
  which payee/bank allow-lists apply, and how tenancy (`created_for_id`) scopes the data
- Related features that read or write the same records (wallet/ledger, payee, bank account, invoice,
  bill, report)
- Existing automation coverage, so tests are extended rather than duplicated

Write the findings into `test-plan.md` under **Baseline**. Where observed behaviour contradicts the
PRD or a code comment, the **observed behaviour wins** — record both and raise it as a question.

### Step 3 — Create the test plan

`test-plan.md` contains:

- **Scope** — the modules, screens, endpoints and actors being tested
- **Out of scope** — stated explicitly, with the reason (covered by another ticket, provider sandbox
  unavailable, not changed by this ticket)
- **Functional scenarios** — the main flows, per actor
- **Positive scenarios** — valid data, expected happy paths
- **Negative scenarios** — invalid data, wrong state, wrong order, cancelled mid-flow, duplicate
  submit, expired session, insufficient balance, unsupported rail
- **Boundary scenarios** — amount minimum/maximum, per-transaction and daily limits, zero, negative,
  decimal precision, cut-off times (Same-Day ACH windows, wire cut-off, RTP 24/7), field lengths,
  routing/account number lengths, date edges, pagination first/last page, lists of 0 / 1 / many
- **Validation scenarios** — required fields, formats, inline messages, and server-side rejection of
  a payload that bypassed the UI
- **Permission / security scenarios** — Section 8, one row per actor × surface
- **Integration scenarios** — bank partner, KYC/KYB, card processor, notifications, webhooks, queued
  jobs, scheduled jobs, file generation (NACHA, check PDF, statements)
- **Regression areas** — from Section 9, trimmed, each with the reason it was selected
- **Browser / device coverage** — Chrome as primary; Edge/Firefox/Safari where the ticket touches
  layout or file handling; responsive at ≤785px; the OCW Mobile App where the change reaches it
- **API scenarios** — the endpoint list Step 7 will execute
- **Entry / exit criteria and known blockers**

### Step 4 — Create test cases

`test-cases.md`. One row per case, IDs of the form `<JIRA_TASK_NUMBER>-TC-01`.

| Field | Content |
|---|---|
| Test Case ID | `OCW-1005-TC-01` |
| Scenario | One sentence — the behaviour under test |
| Type | Functional / Negative / Boundary / Validation / Permission / Integration / API / Regression |
| Priority | P1 blocking · P2 major · P3 minor |
| Preconditions | Actor, company, and the state the system must be in |
| Test Data | A reference into `test-data.md`, never a literal secret |
| Steps | Numbered, one action each, reproducible by someone who has not seen the feature |
| Expected Result | The observable outcome — UI state, message text, record state, API status/body |
| Actual Result | Filled in during Step 6. Empty until then. |
| Status | `PASS` · `FAIL` · `BLOCKED` · `N/A` · `NOT RUN` |
| Evidence | Path under `evidence/` |
| Notes | Anything the next tester needs |

**Rules**

- Every acceptance criterion maps to at least one case; put the mapping in a table at the top of the
  file.
- No duplicate cases. One case per distinct behaviour — a scenario that differs only by test data is
  one case with a data table, not five cases.
- Expected Result is specific: "shows the inline error *Amount must be at least $1.00*", not "shows
  an error".
- A case that cannot be executed on this environment is `BLOCKED` with the blocker named, not
  quietly dropped.

### Step 5 — Prepare test data

`test-data.md` lists everything each case needs, and how to create it.

- Use safe dummy data: test payees, test bank accounts with sandbox routing/account numbers, sandbox
  card numbers, test invoices, test KYC/KYB profiles.
- Keep at least two companies (`<TEST_COMPANY_A>`, `<TEST_COMPANY_B>`) so every tenancy case has a
  "wrong company" to attack from.
- Record the data you **create** during a run (payee id, check number, register row) so it can be
  found, reused or cleaned up. Note what was deliberately left in place.

**Never expose or commit** real passwords, API keys, OAuth client secrets, bearer/session tokens,
real banking credentials, real routing or account numbers, real card numbers, real PII, or any
production secret. Use `<PLACEHOLDER>` names in documents and environment variables at runtime. If a
secret reaches an evidence file, redact it in the image and rotate the secret.

**Never test against production, and never modify production data.** If the only reproduction is on
production, the case is `BLOCKED` and escalated — it is not executed.

### Step 6 — Execute manual testing

Claude drives the real browser. For each case, in order:

1. Perform the action.
2. Observe the actual behaviour — the rendered UI, the message text, the record state.
3. Compare it against the Expected Result.
4. Record Actual Result and Status in `execution-results.md` **immediately**, before the next case.
5. Capture evidence per Section 7.
6. Continue with the next scenario.

**Rules**

- Claude must not mark a case `PASS` unless the behaviour was actually observed in this run. Not
  because the code looks right, not because it passed last sprint, not because a similar case passed.
- Status vocabulary — these five only:

  | Status | Means | Required alongside |
  |---|---|---|
  | `PASS` | Executed, expected result observed | Evidence |
  | `FAIL` | Executed, wrong result observed | Evidence + a `bug-report.md` entry |
  | `BLOCKED` | Could not execute | The blocker + who unblocks it |
  | `N/A` | Genuinely does not apply to this change | One line saying why |
  | `NOT RUN` | Not executed | The reason + who should run it |

  `NOT RUN` is a professional outcome. Hiding it is not.
- A partial pass is a `FAIL` with the deviation described — never a `PASS` with a caveat in Notes.
- After any money-moving action, verify the resulting record and the ledger/wallet effect, not just
  the success toast.

### Step 7 — API testing

When the feature has an API surface, write and execute `api-tests.md`.

- Identify the relevant endpoints and which route file/actor they belong to (`list-routes`).
- Validate the request payload contract: required vs optional fields, types, formats, encrypted ids.
- Validate the response status code for each path — 200/201, 400, 401, 403, 404, 409, 422, 429.
- Validate the response body: shape, field names, values, pagination — and that it contains **no**
  data the caller should not see (another company's records, internal ids, secrets, owner PII).
- Test invalid payloads, missing required fields, wrong types, and extra/unknown fields.
- Test boundary values — the same limits as Step 3, asserted at the API rather than in the UI. A
  limit enforced only in the browser is a defect.
- Test **authentication**: no token, malformed token, expired token, revoked/suspended token.
- Test **authorisation**: the wrong guard, a missing `VerifyV4Permission:<permission>`, an invited
  client acting outside its payee/bank allow-list, a customer reaching an admin or operator endpoint.
- Test **tenancy**: request company A's record with company B's token — the only correct outcome is
  404/403, never the record. A client-supplied `company_id`/`user_id` must be ignored.
- Test duplicate/replay where relevant: the same idempotency key, or the same payment submitted
  twice, must not create two payments.
- Verify the resulting database/state change with a **read-only** query, and the async effects (job
  ran, notification sent, file generated).

Use Postman for the collection and the environment; use Chrome DevTools → Network to confirm what the
UI actually sends.

### Step 8 — Automation

Automate what is stable and will be run again. Do not automate a screen still in flux.

Good candidates: smoke paths (login, navigation, core list loads), high-value regression flows,
repetitive data-driven validation, and long manual flows that are slow to repeat.

Rules:

- Follow the project's **existing** framework and language. Playwright Java repo → Playwright Java.
  Playwright TypeScript repo → Playwright TypeScript. Selenium repo → Selenium. Do not introduce a
  second framework without a stated reason and the QA lead's agreement.
- Reuse the existing page objects, fixtures, helpers and config. Add to them rather than forking.
- Prefer stable locators (Section 6).
- No hard waits. Use the framework's auto-waiting and explicit expectations
  (`expect(locator).toBeVisible()`), not `sleep`.
- Handle dynamic content properly: tables that load async, infinite scroll, toasts that disappear,
  amounts and dates that change per run.
- Keep test data maintainable — created by the test or a fixture, referenced by placeholder, never a
  hard-coded production record.
- Keep tests independent: each spec sets up its own state and can run alone and in parallel.
- Never point an automated suite at production.
- Record in `automation.md`: what was added/updated, the file paths, the command to run it, the last
  run output verbatim, and what was deliberately left manual and why.

### Step 9 — Bug reporting

When a case fails, first decide whether it is actually a defect. Re-run it, check the precondition,
check whether the requirement really says otherwise, and use `systematic-debugging` to isolate it. An
environment problem, stale test data, or a misread requirement is not a defect.

Then write the entry in `bug-report.md` and file it in Jira:

```
Jira reference:       <JIRA_TASK_NUMBER>  (bug: <BUG_KEY> once filed)
Title:                <module> — <what is wrong>, <when>
Environment:          <QA_STAGING_URL> · build/commit · browser + version · date
Actor / account:      owner | sub-user | invited client | admin | operator —
                      <TEST_USERNAME>, <TEST_COMPANY_A>
Preconditions:        the state required to reach it
Steps to reproduce:   numbered, minimal, complete
Test data:            placeholders + the ids created during the run
Expected result:      with the requirement or AC it comes from
Actual result:        what was observed, quoted exactly
Reproducibility:      always | intermittent (n of m attempts) | once
Severity:             Critical | High | Medium | Low
Priority (suggested): with a one-line business reason
Evidence:             evidence/<file> — screenshot, video, console, network
API / request info:   method, endpoint, request body (redacted), status, response body
Related:              other affected screens, the suspected module
```

**Rules**

- The title states the defect, not just where it appeared.
- Severity is about impact (money moved wrongly, data leaked across companies, flow blocked), not
  about how annoying it is. Anything that moves money incorrectly or exposes another company's data
  is **Critical**.
- Claude must not report an assumption as a confirmed defect. A suspicion goes in `qa-signoff.md`
  under *Observations*, clearly labelled unverified.
- Do not speculate about the fix in the bug report. Root cause belongs to the developer.

### Step 10 — Retesting

When a fix arrives:

1. Confirm what you are testing — the build/commit that contains the fix, on `<QA_STAGING_URL>`.
2. **Reproduce the original issue first** where the environment still allows it, so the retest proves
   something changed. If it can no longer be reproduced, say so.
3. Execute the original steps exactly as written in the bug report.
4. Test the scenarios around the fix — the same flow with different data, the other actors, the
   adjacent screens.
5. Re-run the negative cases: a fix that stops the error by removing the validation is a worse bug.
6. Check for regression in the module the fix touched (Step 11).
7. Update the case Status and the bug entry: `Retest: PASS on <build> <date>`, or
   `Retest: FAIL — <what still happens>`.
8. Capture fresh evidence. Never reuse the old screenshot.

A bug is closed by QA only after the retest passes **and** its regression scope is clean.

### Step 11 — Regression testing

1. Select the areas. Start from what actually changed — the diff, the endpoints, the shared
   components, the shared service/ledger paths — not from the whole checklist.
2. **Claude must state why each area was selected**, one line each. An area selected without a reason
   is noise; an area skipped without a reason is a risk.
3. Run **targeted regression** first: the changed module, and everything that reads or writes the
   same records.
4. Then broaden — when the change is shared (auth, tenancy, permissions, ledger/wallet, payee, bank
   account, notifications, a shared UI component), or when the targeted pass found a failure.
5. Record the result per area in `regression-checklist.md` using the same status vocabulary.

Typical selection reasons: "the payee dropdown is shared by check, ACH and wire" · "the change writes
to the ledger, so wallet balance and the transaction report are downstream" · "the v4 route gained
`VerifyV4Permission`, so invited-client access must be re-verified".

### Step 12 — QA sign-off

Before the ticket can be marked QA Passed, verify all of the following — and only from
`execution-results.md`, not from memory:

- [ ] Every requirement in `requirement.md` was validated
- [ ] Every acceptance criterion has at least one executed case
- [ ] Positive scenarios passed
- [ ] Negative scenarios were executed
- [ ] Relevant edge/boundary cases were executed
- [ ] Regression impact was checked, and the selection justified
- [ ] All Critical and High defects are resolved and retested
- [ ] Deferred defects are logged with owner and priority
- [ ] Required automation was added or updated and runs green
- [ ] Evidence exists for every `PASS` and `FAIL`
- [ ] No blocking issue remains

Then write `qa-signoff.md` using the report structure in Section 11, and post the summary as a Jira
comment on the ticket. Where the team's `qc-checklist` phases are in use, fill **QA Scheduled**,
**In QA** and **QA Passed** from the same evidence — never claim an item that has no evidence; mark
it a **Gap**. QA Lead sign-off is a human decision: Claude drafts it, a person records it.

---

## 5. Browser-Based Testing

Claude tests the running application through the browser extension. **Verify the actual UI behaviour
— the source code is a hypothesis, the rendered page is the evidence.**

| Situation | How to handle it |
|---|---|
| Navigating | Go through the app's own menu at least once per flow — a deep link can skip a guard the user cannot skip. Confirm the URL, page title and breadcrumb. |
| Login / authentication | Log in as the actor the case names. Confirm which company is active before acting, and re-check after a company switch — most tenancy bugs appear there. |
| Forms | Submit empty, submit invalid, submit valid. Read the inline message text exactly. Confirm which field is actually rejected, and the enabled/disabled state of the submit button. |
| Tables | Verify columns, row count, sorting on each sortable column, and totals against the underlying data. Confirm the row you created is present and correct. |
| Filters | Apply one filter and verify the result set, then combine filters. Clear and confirm the list resets. Check whether the filter survives pagination (and whether it should). |
| Search | Exact match, partial match, no match (empty state), special characters, leading/trailing spaces. Confirm the search is scoped to the current company. |
| Pagination | Page 1, a middle page, the last page, a page-size change, and the count. Confirm no record is duplicated or lost across pages. |
| Modals | Confirm open, cancel, close-by-X, close-by-backdrop and Escape. Verify cancel does **not** save. Verify the underlying page state after close. |
| Drawers / panels | As modals, plus: the drawer shows the record that was actually clicked. |
| Popups / new tabs | Wait for the new page or tab, switch to it, assert on it, then return. Do not assume the popup opened. |
| iFrames | Enter the frame explicitly before locating anything inside it. Embedded processor/KYC widgets are usually iframes — their internal errors will not surface on the parent page. |
| File uploads | Valid file, wrong type, oversized, empty, double extension. Confirm the server rejects what the UI rejects. |
| Downloads | Trigger the download, confirm the file arrives, and **open it** — a check PDF, statement or NACHA file with wrong content still downloads successfully. |
| Auto-suggest fields | Type a partial value, wait for the options, and select from the list rather than typing the full string. Confirm the underlying id was set, not just the visible text. |
| Dynamic content | Wait for the real condition (row visible, spinner gone), never a fixed sleep. Re-read the value after the async update. |
| Toast messages | Read and capture the exact text before it disappears. A success toast is not proof the record was created — verify the record. |
| Loading states | Confirm the skeleton/spinner appears and clears, and that the action cannot be double-submitted while it is in flight. |
| Error states | Confirm the user-facing message is meaningful and the page recovers. Check DevTools Console and Network for what is behind it — a silent 500 behind a friendly toast is a defect. |

Keep the DevTools Console and Network panels open during every session. Console errors and failed
requests are evidence even when the visible flow passed.

---

## 6. Locator Strategy

For Playwright automation, in this order of preference.

1. **`getByRole`** — the default. Buttons, links, headings, checkboxes, radios, dialogs, tables, and
   inputs with an accessible name.
   `page.getByRole('button', { name: 'Create Check' })`
   It survives styling and DOM changes, and a locator that fails here often means a real
   accessibility defect worth reporting.
2. **`getByLabel`** — form fields with a visible or associated label. The way a user finds a field.
   `page.getByLabel('Routing Number')`
3. **`getByText`** — static, meaningful content: validation messages, toasts, empty states, status
   badges. Use `{ exact: true }` where the string is short enough to collide.
4. **`getByPlaceholder`** — only when a field genuinely has no label (search boxes, inline table
   filters).
5. **Stable test IDs** — `getByTestId` for elements with no accessible name and no stable text:
   icon-only actions, rows in a virtualised grid, one card in a repeated list. If an element needs
   one and does not have it, ask the developer to add `data-testid` rather than working around it
   with a fragile selector.
6. **CSS / XPath** — last resort, and only anchored to something stable (a `data-*` attribute, an
   `id`, an `aria-*` attribute). Add a comment saying why the options above did not work.

Scope before you locate. Find the row, then act inside it:

```
const row = page.getByRole('row', { name: <PAYEE_NAME> });
await row.getByRole('button', { name: 'Edit' }).click();
```

**Never** build a locator on: framework-generated or hashed class names (`_ngcontent-*`,
`css-1x2y3z`, Tailwind utility strings); deep DOM paths (`div > div > div:nth-child(3) > span`);
position alone (`.nth(4)` on an unsorted list, "the third button"); text that changes per run
(amounts, dates, generated ids, balances); or temporary state attributes (`aria-expanded`, `.active`,
`.ng-dirty`) used as the element's identity rather than as the assertion.

---

## 7. Test Evidence

Evidence is what makes a result reviewable by someone who was not there. Every `PASS` and every
`FAIL` carries it.

| Capture | When |
|---|---|
| **Screenshot** | Every `PASS` on a P1 case; every `FAIL`, at the moment of failure; every validation message; before and after any money-moving action; any state a reviewer would otherwise have to take on trust. |
| **Video / screen recording** | Multi-step flows, intermittent defects, anything a screenshot cannot show (timing, animation, double-submit), and any Critical bug. |
| **Console errors** | Every session. Capture the full error text and stack for any error present during a failure — and for errors present during a *pass*, which are still defects. |
| **Network failures** | Any non-2xx the UI did not surface, any request that should have fired and did not, any duplicate request on a single click. Capture method, URL, status and timing; export a HAR for a complex failure. |
| **API request / response** | Every API case — the request (secrets redacted), the status code, and the response body. Paste it; do not summarise it. |
| **Logs** | Application/queue logs where a job, notification or file generation is involved: the exact line, with timestamp. |
| **Database results** | Any case whose expected result is a state change — the read-only query and its output, before and after. |

How to store and link:

- Everything goes under `specs/<feature>/<JIRA_TASK_NUMBER>/evidence/`.
- Name the file after the case or bug it proves:
  `OCW-1005-TC-07-fail-amount-validation.png`, `OCW-1005-BUG-02-network.har`,
  `OCW-1005-TC-12-api-response.json`.
- Reference the path in the case's Evidence cell and in the bug's Evidence field. An evidence file
  that no row points at is not evidence.
- **Redact before saving**: tokens, session cookies, API keys, full account/card numbers, real names
  and addresses. Redact inside the image, not by cropping in the viewer.
- Evidence must come from the run it documents. Never reuse a screenshot across runs, or after a
  retest.

---

## 8. Security Testing

Run these before sign-off on anything touching auth, money, permissions, uploads, or customer data.
They are **read-and-verify** checks, on a QA environment, with test accounts.

1. **Authentication** — an unauthenticated request to a protected page or endpoint is rejected
   (redirect / 401), not served. Logging out invalidates the session. A revoked or suspended token
   stops working.
2. **Authorisation** — each actor reaches only its own surface: a customer cannot reach admin/SUA or
   operator routes; a legacy sub-user, an owned company and an invited client each get exactly their
   documented access; a partner token stays pinned to its company.
3. **Role / permission validation** — the permission gates the **action**, not just the menu item.
   Hiding a button is not a control: attempt the action with the permission removed and confirm the
   server refuses. On apiv4 routes, confirm `VerifyV4Permission:<permission>` is enforced.
4. **Tenancy / IDOR-style checks** — log in as `<TEST_COMPANY_B>` and request a record belonging to
   `<TEST_COMPANY_A>` by id, in the URL and in the API payload. The only correct outcome is a
   refusal. Repeat for payee, bank account, check, invoice, bill, card, report export and every
   download link. Confirm a client-supplied `company_id`/`user_id` is ignored in favour of the
   server-derived one. Allow-listed payees and bank accounts must be enforced when **used**, not only
   when listed.
5. **Input validation** — the server rejects what the UI rejects. Send the payload directly with the
   UI's rules bypassed: over-limit amount, negative amount, wrong currency, bad routing number,
   oversized string, wrong type.
6. **XSS-style input handling** — enter a script-like string (e.g. `<script>alert(1)</script>`) in
   free-text fields such as payee name, memo, note, invoice description. Verify it is stored and
   rendered as **text** everywhere it appears — list, detail, PDF, email, export. Report it if it
   executes or if it breaks rendering; do not chain it into anything further.
7. **Sensitive data exposure** — API responses, HTML source, JS bundles, console logs, error messages
   and exported files must not contain secrets, internal ids, full account/card numbers, or another
   company's data. A stack trace shown to a user is a defect.
8. **URL manipulation** — change ids, step parameters and status values in the URL; try to skip a
   step in a multi-step flow; open a step-3 URL directly. The flow must re-validate server-side.
9. **API authorisation** — repeat items 2–4 directly against the endpoints, including with an expired
   token and with no token.
10. **Session behaviour** — idle timeout behaves as specified; the session does not survive logout; a
    company switch leaves none of the previous company's data on screen or in a cached response.
11. **File upload validation** — wrong MIME type, disguised extension, oversized file, empty file,
    and a file whose extension disagrees with its content are all rejected server-side; an accepted
    file is not served back executable.

**Boundaries.** Do not run destructive or unauthorised testing: no load/stress or DoS, no brute force
or credential stuffing, no SQL injection payloads that modify or delete data, no exploitation beyond
proving the access exists, no third-party or provider system, and **never** production. The moment a
real exposure is confirmed, stop, capture the minimum proof, and report it as Critical to the QA lead
and security — do not extend the test to see how far it goes.

---

## 9. Regression Checklist

Copy into `regression-checklist.md` and trim to the ticket. Delete what does not apply, and write the
reason each kept area was selected. Status per row uses the Step 6 vocabulary.

**Authentication** — login, logout, session timeout, password reset, 2FA where enabled, company
switching, "remember me".

**Navigation** — main menu, submenus, deep links, breadcrumbs, back/forward, refresh mid-flow, the
module's landing page.

**Permissions** — owner, legacy sub-user, owned company, invited client, admin/SUA, operator; menu
visibility *and* action enforcement; allow-listed payees and bank accounts.

**Core workflow** — the primary create → review → submit → confirm path for the affected module, end
to end, including cancel and edit.

**Related modules** — everything reading or writing the same records: payee management, bank
accounts, wallet/ledger, invoices, bills, card management, check payments, KYC/KYB status.

**API** — the module's v3/v4 endpoints, plus partner endpoints if the data is exposed there; status
codes, body shape, tenancy scoping.

**Database / state** — the record is created/updated/soft-deleted correctly; the ledger and wallet
balance reconcile; audit rows are written; no orphan rows.

**Notifications** — email and in-app: triggered, to the right recipient, correct content, correct
timing; a missing template must not break the underlying save.

**Reports** — the module's reports and dashboards reflect the change; filters and date ranges;
exports (CSV/PDF) open, and contain the same data as the screen.

**Integrations** — bank partner, KYC/KYB provider, card processor, accounting integrations, webhooks;
queued and scheduled jobs run and retry correctly.

**Payments** — per rail, where touched: ACH, Same-Day ACH (cut-off windows), Wire, RTP,
international, check print, mail check, eCheck, virtual card; limits, fees, cut-off times, status
transitions, cancel/void where supported, returns and failures.

**Error handling** — server error, network drop mid-submit, double submit, expired session during a
flow, provider timeout: the user sees a meaningful message, and no duplicate money movement occurs.

**UI responsiveness** — desktop and ≤785px, light and dark, long values and empty states, the primary
browsers for this ticket; the OCW Mobile App where the change reaches it.

---

## 10. QA Agent Instructions

Put this in `claude.md`, or in the `## QA rules` section of the repo's `CLAUDE.md`.

```
You are working as a QA Engineer on the Zi Money / OnlineCheckWriter ecosystem.

Working principles (Karpathy's guidelines, translated to QA)
1. Think before testing — state assumptions; present both readings of an ambiguous
   acceptance criterion instead of picking one; say when an existing case already
   covers it; stop and ask when unclear rather than guessing.
2. Minimal sufficient coverage — the fewest cases that prove the requirement. No
   unreachable states, no duplicate that differs only by test data, no automation for
   a screen still in flux, no regression area without a reason. If 40 cases could be
   15, rewrite the suite.
3. Surgical testing — test what the change touches. Don't rewrite or reformat the
   existing suite; match its style; don't expand into modules the diff never touched.
   Report pre-existing defects separately — never fold them into this ticket's result.
   Remove only the test data your run created, and say what you left behind.
4. Evidence-driven execution — "validate the fix" means reproduce the bug first, then
   show it is gone. Map each acceptance criterion to a case, execute, attach evidence.
   For multi-step work, state the plan as `step -> verify` pairs and close each before
   moving on.

Mindset
- Think like a QA Engineer: the job is to find where this breaks, not to confirm it works.
- Question unclear requirements. Never assume a missing requirement — ask, and mark the
  area BLOCKED until it is answered.
- Never assume a feature works because the code looks correct. Execute it.
- Look for the negative path, the boundary, the wrong actor and the second company in
  every scenario.
- Consider regression impact on every change, and state why each area was selected.

Execution
- NO PASS WITHOUT EXECUTION AND EVIDENCE. Use only PASS / FAIL / BLOCKED / N/A / NOT RUN.
  NOT RUN is an acceptable answer; a fabricated PASS is not.
- Verify behaviour in the running application, not in the source. Where the code and the
  observed behaviour disagree, the observed behaviour wins — record both.
- Clearly distinguish observed behaviour from inference. Label anything unverified as an
  observation, never as a defect.
- Report every failure with reproducible steps and evidence. Do not speculate about the fix.
- Keep test documentation synchronised with actual execution: results are written during
  the run, not reconstructed afterwards.

Boundaries
- Reuse existing project patterns — the existing automation framework, page objects,
  helpers, Postman collection, and the specs/ conventions.
- Avoid unnecessary code changes. QA changes test code; production code changes belong to
  development. If a fix looks obvious, say so in the bug report; do not commit it.
- Never test against production, and never modify production data.
- Never run destructive database operations: no migrate:fresh / migrate:refresh /
  migrate:reset / db:wipe / RefreshDatabase; no DROP, TRUNCATE, or DELETE without a WHERE
  — not in SQL, not in tinker, not in a test. Database access is read-only.
- Never expose or commit secrets: passwords, API keys, tokens, banking credentials, card
  numbers, real PII. Use placeholders and environment variables. Redact evidence before
  saving it.
- Do not perform destructive or unauthorised security testing (see the Section 8
  boundaries).
```

---

## 11. Final QA Report

At the end of every task, generate this in `qa-signoff.md` and post it as a Jira comment.

```markdown
# QA Report — <JIRA_TASK_NUMBER> <ticket title>

Tester: <QA_ENGINEER> · Environment: <QA_STAGING_URL> · Build/commit: <BUILD> · Date: <YYYY-MM-DD>

## Overview
What was tested, in two or three sentences.

## Scope
Included: modules, screens, endpoints, actors, browsers/devices.
Excluded: what was not tested, and why.

## Testing Performed
- Functional / UI
- Negative, boundary and validation
- API
- Permission / security
- Integration
- Regression
- Cross-browser / responsive
(one line each, naming what was actually executed)

## Test Results
| Total | Pass | Fail | Blocked | N/A | Not run |
|---|---|---|---|---|---|
| n | n | n | n | n | n |

Blocked and Not run are listed individually, with the reason.

## Bugs Found
| Bug | Title | Severity | Status |
|---|---|---|---|
| <BUG_KEY> | … | Critical/High/Medium/Low | Open / Fixed / Retested-Pass / Deferred |

## Regression
Areas covered, why each was selected, and the result.

## Automation
Specs added or updated, the command to run them, and the last run output verbatim.
"None — <reason>" if nothing was automated.

## Evidence
Path: specs/<feature>/<JIRA_TASK_NUMBER>/evidence/ — and what is in it.

## Observations
Unverified findings, risks, and anything the next tester should know. Clearly not defects.

## Status
**QA Pass** | **QA Failed** | **QA Blocked**
One line of justification.
```

**Status meanings**

- **QA Pass** — the feature meets the tested requirements, every acceptance criterion was executed,
  and no blocking issue remains. Deferred non-blocking defects are listed with owner and priority.
- **QA Failed** — one or more blocking issues remain. Name them.
- **QA Blocked** — testing cannot continue because of an external dependency or blocker. Name the
  blocker, who owns it, and exactly what is still untested.

---

## 12. Before QA Sign-Off

The QA equivalent of the development guide's *Before Opening a Pull Request*. Work through it in
order; do not sign off with an unanswered item.

1. Verify the Jira requirements — every one in `requirement.md` was validated, and every open
   question was answered.
2. Verify acceptance criteria — each has at least one executed case, with evidence.
3. Execute functional testing — the core flows, for every affected actor.
4. Execute negative and edge-case testing — invalid data, boundaries, limits, cut-off times, wrong
   state, duplicate submit.
5. Execute applicable API testing — status codes, body, validation, auth, tenancy, duplicates, and
   the resulting state change.
6. Execute targeted regression — and record why each area was selected.
7. Verify permissions and security behaviour — Section 8, including the cross-company attempt from
   `<TEST_COMPANY_B>`.
8. Verify relevant browser and device behaviour — the primary browser always, plus the matrix in
   `test-plan.md`; responsive at ≤785px; the mobile app where the change reaches it.
9. Review automation coverage — new specs run green, existing specs still pass, and `automation.md`
   is updated with the run output.
10. Confirm all blocking defects are resolved and retested, and deferred defects are logged with
    owner and priority.
11. Confirm evidence exists for every `PASS` and `FAIL`, is named after its case, and is redacted.
12. Generate the final QA report (Section 11), commit the QA folder, post the summary on the ticket,
    and move the phase story. QA Lead sign-off is recorded by a person, not by Claude.

---

*Internal Zi Money QA process guide. Replace every `<PLACEHOLDER>` with the value for your
environment, and keep the placeholders in anything committed.*
