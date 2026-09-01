# MyHealth AI — Broadsheet redesign, part 3 of 3

The admin console. Apply parts 1 and 2 first.

## Files

    lib/features/admin/admin_shell.dart
    lib/features/admin/user_management_screen.dart
    lib/features/admin/ai_settings_screen.dart
    lib/features/admin/audit_log_screen.dart

`department_schedule_screen.dart` is untouched — it still occupies the
second rail slot and inherits the new tokens.

## What changed

**Shell.** Same four destinations, same `adminNavIndexProvider`, same
indices — nothing to grep this time. The rail loses its tinted circle avatar
and picks up a hairline edge.

**Users.** The screen listed clinicians only, as a stack of bordered cards
with a Switch on each. It is now a table: name, role, department, licence,
last activity, with the active toggle at the row's end. A patient lookup
sits above it and calls `searchPatients` once you type two characters —
previously there was no way to reach a patient account from admin at all,
even though the repository method existed. Counts print in the masthead.

**AI settings.** Three stacked cards become one column of stated settings.
The mock-mode switch keeps its exact behaviour but the copy drops the
"100% defense insurance" framing for what it actually does: deterministic
on-device summarisation, no network call. The API key field, model
dropdown and re-seed action are unchanged in function; the re-seeder now
prints what it will destroy before you press it, and its confirm dialog
reads as a sentence rather than a title and a warning colour.

**Audit trail.** The per-action colour map is gone — it assigned six hues
to actions with no ranking between them. Entries now read as a log:
timestamp in the margin in tabular figures, action in small caps, entity
and actor in the line. The filter field is unchanged.

## Note on the re-seeder

`_reSeedDatabase` calls `DatabaseSeeder(db).seedAll()` exactly as before.
I did not change what it does — only what it says it will do.
