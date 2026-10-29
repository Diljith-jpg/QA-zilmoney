# Unit Testing / Self-Test Report

**Dev task:** OCW-24687 - Fix Audit Log Date Display and Missing IP Address
**Type:** Frontend
**Environment:** branch `OCW-24687-DAVOOD`, commit `fd42f41233`; app NOT served in this session
**Build:** `npx tsc --noEmit -p tsconfig.app.json` → exit 0; `npx ngc -p tsconfig.app.json --noEmit` → no errors mentioning the two touched components (`strictTemplates: false`, so templates are only loosely checked)
**Files touched:**

- src/app/modules/bank/bank-v3/v35-components/bank-accounts-details-ocw-v35/bank-accounts-details-ocw-v35.component.html
- src/app/modules/bank/bank-v3/v35-components/bank-accounts-details-ocw-v35/bank-accounts-details-ocw-v35.component.ts
- src/app/modules/bank/bank-v4/v4-components/bank-details-v4/bank-details-v4.component.html
- src/app/modules/bank/bank-v4/v4-components/bank-details-v4/bank-details-v4.component.ts

---

## Summary of changes tested

1. v4 Audit Trail: Date column now uses shared `<app-pd-date-time>` (date on line 1, time on line 2, no brackets, smaller/lighter); By column `whitespace-nowrap`.
2. v35 Audit Trail: same layout via new `splitAuditDateTime()` which reuses `Utils.splitDateTime` after turning `(` into `-` and dropping `)`; time uses `text-[10px] text-secondary-text-color`; By column `whitespace-nowrap`.
3. Both tables: Device column cell now renders `item.ipAddress` instead of `item.deviceName` (included in the commit; the column header still reads "Device").

---

## 1. Functional validation — NOT RUN

| # | Test | Expected | Actual (evidence) | Result |
|---|---|---|---|---|
| 1.1 | v4 Audit Trail date on two lines | date, then time without brackets, time smaller/lighter | App not opened in a browser this session | NOT RUN (dev to run) |
| 1.2 | v35 Audit Trail date on two lines | same | App not opened in a browser | NOT RUN (dev to run) |
| 1.3 | By column single line (v4, v35) | name on one line | Not viewed | NOT RUN |
| 1.4 | IP address shown in Device column | IP value visible | Not viewed; `ipAddress` is NOT declared on `IBankAuditTrial` (`src/app/models/bank.ts:220`, only `deviceName`) and I did not inspect the API response | NOT RUN |
| 1.5 | `splitAuditDateTime('09/22/2026(09:00 am)')` → `['09/22/2026','09:00 am']` | as stated | Standalone execution failed (Utils imports Angular modules); only reasoned from code, which is not evidence | NOT RUN |

## 2. Edge cases and error scenarios — NOT RUN

| Case | Expected | Actual (evidence) | Result |
|---|---|---|---|
| Date with no time part | date only, no empty second line | Not executed | NOT RUN |
| Empty / null `formattedCreatedAt` | no crash | Not executed | NOT RUN |
| Empty IP address | blank cell | Not executed | NOT RUN |
| Skeleton / empty states | unchanged | Not viewed | NOT RUN |

## 3. Security — N/A (display-only)

- Input validation: N/A, no inputs added.
- Authentication / authorization: N/A, no routes or calls changed.
- Sensitive data exposure: IP address is now displayed; whether the backend should expose it to all actor types is not confirmed by me. Backend owns that decision.
- Injection / XSS: values rendered via Angular interpolation (escaped).

## 4. Performance and optimization — NOT RUN

- New queries / API calls: none added (code review only, not observed in network tab).
- Rendering / change detection: v35 template calls `splitAuditDateTime()` once per row per change-detection pass; not measured.
- Subscriptions cleaned up: none added.

## 5. Code quality — PARTIAL

- Follows existing patterns: reused `PdDateTimeComponent` (v4) and `Utils.splitDateTime` (v35). Used `@if … as` because the app is Angular 17 (`@let` unsupported).
- Dead code / unused assets: none introduced. Pre-existing: unused `V4TransferFundsModalComponent` import in the v4 component.
- `npx eslint` on the two `.ts` files → 2 errors, both on lines not touched by this change: `import/order` at `bank-details-v4.component.ts:59`, `no-underscore-dangle` at `:636`. HTML files not linted. v35 `.ts` produced no errors.

## 6. Error handling and logging — N/A

No error paths or logging changed.

## 7. Database migrations and rollback — N/A

Frontend only.

## 8. API backward compatibility — NOT RUN

- Contracts changed: none by me, but the template now reads `ipAddress`, a field absent from the typed model; presence in the API response is unverified.
- New endpoints: none.

## 9. UI responsiveness and browser/device compatibility — NOT RUN

- Desktop: not viewed.
- Mobile breakpoints: not viewed.
- Browsers: not run.
- Light/dark theme and white-label brands: not checked (shared v4 component unchanged; v35 uses existing `--secondary-text-color`).

## 10. Console errors and warnings — NOT RUN

App not run; browser console not observed.

## 11. Regression / no breaking impact — NOT RUN

Open (handed to QA):

- Other consumers of `app-pd-date-time` are unchanged (component not edited), but not viewed.
- Device name is no longer shown anywhere in these two tables; confirm this is intended.

## 12. Acceptance criteria — NOT RUN

| AC | Result (evidence) |
|---|---|
| Audit log date shown correctly (two lines) | NOT RUN |
| IP address no longer missing | NOT RUN |

(Ticket body not read in this session; ACs not confirmed.)

---

## Defects found during self-testing

| # | Defect | Fix | Re-verified |
|---|---|---|---|
| 1 | `item.ipAddress` is used in both templates but `IBankAuditTrial` has no `ipAddress`; undetected by compiler because `strictTemplates` is false | Not fixed | No |

---

## Sign-off

| Item | Result |
|---|---|
| Build / type-check | PASS (tsc exit 0; ngc no errors on touched files) |
| Functional validation | NOT RUN |
| Edge cases | NOT RUN |
| Security | N/A |
| Performance | NOT RUN |
| Code quality | PARTIAL (2 pre-existing lint errors in v4 .ts) |
| Error handling | N/A |
| Database migrations | N/A |
| API compatibility | NOT RUN |
| Responsiveness | NOT RUN |
| Console warnings | NOT RUN |
| Regression | NOT RUN |
| **Ready for QA** | **No** |

**Defects found and fixed during unit testing:** 0 (1 found, open)

**Open items for QA:**

1. Click through Bank → account details → Audit Trail in v4 and v35; confirm date/time layout, By on one line, IP shown.
2. Add `ipAddress` to `IBankAuditTrial` and confirm the API returns it.
3. Confirm dropping the device name is intended and the "Device" header should not become "IP Address".

**Tested by:** Claude (code-level checks only) · **Date:** 2026-10-13
