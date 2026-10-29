# OCW-24008 — Payee, Cash Expense & Mail Document

| Field | Value |
|---|---|
| Dev task | OCW-24008 (Sub-task, Frontend) — status Done — assignee Davood Ibrahim |
| Parent | OCW-23713 Development — View Panel Modernization — All Data Tables |
| QA Scheduled | OCW-24254 (Done) — plan: `OCW-24254_QA_Test_Plan.pdf` in this folder |
| In QA | OCW-24258 (Completed; parent OCW-23715 is **QA Failed**) |
| Test build | https://ocw-24008-davood.web.ocw.sebipay.com/v4/manage/home (dev branch deploy, provided by user 29 Sep 2026) |
| Jira comment 28 Sep | Automation: "QA returned this task" — unit test evidence reset |

## Description (verbatim)
Update the design of the **Payee, Cash Expense, Mail, and Document Mail story view pages** based on the
requirements and design specifications provided in the linked UX task.

### Implementation Guidelines
- Follow the latest UX design and UI specifications from the linked task.
- Use the existing `/v4-detail-panel` implementation as a reference for the overall detail/view-page structure and behavior.
  - Maintain consistency with the existing **Payment Out** and **Payment In** view pages where applicable.
- Reuse existing V4 components and established layout patterns instead of introducing duplicate UI implementations.
- Ensure the updated pages maintain consistent spacing, typography, actions, responsive behavior, and detail-panel interactions across the V4 experience.
- Do not change existing business logic, API behavior, or functionality unless explicitly required by the linked UX task.

### Pages in Scope
Payee · Cash Expense · Document Mail · Document Mail History

## Components (from Jira attachment image — working/jira-scope-image.png)
- Payee: payee-list-v4, payee-ocw-v4, payee-data-table-v4 → view payee-details-v4
- Cash Expense: cash-expense-v4-main, cash-expense-list-v4 → view cash-expense-detail-panel-v4
- Document Mail: document-mail-list-v4 → view document-mail-detail-panel-v4
- Document Mail History: v4-document-mail-history (route mailing-dashboard/document-mail-history) — no view component

## Dev unit-test report (attachment, 26 Sep) — behaviours claimed, all NOT RUN by dev
- Payee: header meta (Added / Location bold); ⋮ Edit (edit modal) / Delete (confirm; error codes 123/124/126); "+ New" pill;
  collapsible transactions card; Contacts / To-dos empty state with centred Add, top-right Add when data exists;
  comments + attachments via shared lists; comments limit 5; attachments any type ≤ 5 MB, max 5 files. Inline edit pencil commented out.
- Cash expense: header badge inline, Payee / Account lines; Clone / Get receipt / Send proof; ⋮ Edit, Print, Delete;
  details + payee-summary cards (Total cash pill); 4 activity tiles; grid refreshes after comment/attachment add/delete.
- Document mail: header title + Added date; Mail / Download buttons; ⋮ Edit, Delete disabled unless status = New;
  shared comments list; re-open refresh.
- Shared: attachments list accepts `*`; detail-side-panel menu items accept `disabled`.
- Comment max length 190 chars (client side).
