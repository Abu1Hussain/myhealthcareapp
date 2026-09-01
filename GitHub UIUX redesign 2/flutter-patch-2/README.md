# MyHealth AI — Broadsheet redesign, part 2 of 2

The eight screen rewrites. **Apply part 1 first** — these files import the
retuned tokens and widgets and will look wrong (or fail to resolve
`AppColors.accent700`) without it.

## Files

    lib/features/shared/broadsheet_bits.dart      (new)
    lib/features/patient_home/patient_shell.dart
    lib/features/patient_home/patient_home_screen.dart
    lib/features/timeline/timeline_screen.dart
    lib/features/ai_summary/ai_summary_screen.dart
    lib/features/vitals/vitals_screen.dart
    lib/features/scheduling/booking_wizard_screen.dart
    lib/features/staff/dashboard/staff_dashboard_screen.dart
    lib/features/auth/login_screen.dart

Copy over the same paths, then `flutter analyze`.

## The 6 to 4 nav change

`patientNavIndexProvider` still exists and still holds an `int`, so nothing
fails to compile — but the indices now mean:

    0  Today     (was Home)
    1  Chart     (was Appts)   — Timeline + Records merged
    2  Book      (was Timeline)
    3  You       (was Vitals)  — Profile + Meds

`MedicationsScreen`, `PatientProfileScreen`, `VitalsScreen` and
`PatientAppointmentsScreen` are no longer tabs. They are pushed routes,
reachable from Today, Chart and You. Use the `PatientTab` constants in
`patient_shell.dart` rather than bare integers from now on.

**Grep before you commit.** Any screen outside this patch that does
`patientNavIndexProvider.notifier).state = <n>` is now pointing at a
different tab. At the time of writing that is `family_section.dart` and
`widgets/ai_summary_card.dart` — both send you to a screen that still
exists, just not the one they meant.

## Real data instead of a hardcoded roster

The booking wizard used to carry a five-department list and a
`_doctorsByDept` map with invented names (Dr. Ahmed Al-Khalifa,
Dr. Mariam Al-Hashimi) that never matched `SeedVocab`. It now loads
departments from `UserRepository.getDepartments()` and clinicians from
`getStaffMembers(departmentId:)`, and books against the selected
department's real id instead of the hardcoded `departmentId: 1`. Each
clinician shows their true specialty and MOH licence number from
`StaffProfile`.

## What each screen does differently

**Patient shell** — four tabs, hairline top rule, no elevation.

**Today** — one screen answering "what do I do today": next appointment with
its reminder plan stated in words, the single most notable clinical figure as
a large tabular numeral, and today's medicine times as a schedule rather than
three identical cards.

**Chart** — the old Timeline, with records grouped under month headings and
lab values rendered as a small table inside the row. Search and type filters
sit above the fold; abnormal flags are the only place magenta appears.

**AI reading** — prose first, set at 16px with the serif's true italic for the
model's qualifying sentences. Trends read as a list with direction stated in
words. The audit footer (model, prompt version, context hash) prints at the
bottom in tabular figures, as it did before but legibly.

**Vitals** — a metric switcher, one large current figure, a hand-drawn trend
line with the reference band printed *behind* it, then the self-logged history
as a table. Data entry stays in `LogVitalsModal`.

**Booking wizard** — same four-step state machine, real roster, and no-show
risk shown as one comparable bar per slot plus a plain-language percentage.
The "★ Top" badge is gone; explainability factors are written out.

**Clinician day** — counts in the masthead, unacknowledged critical flags as a
single ticker line, clinic list sorted urgent-first with a leading stripe, and
the waiting-on-you task column beside it.

**Login** — the repo's split-screen structure kept, teal gradient and
decorative circles dropped, demo account buttons retained.
