## MyHealth AI — Implementation Plan

## Context

Senior Project Proposal (University of Bahrain, College of IT — Ali Mohamed Jaafar Mohamed 202208244 & Mohammed A.Redha Meftah 202209027, Supervisor Dr. Amal Ghanim) defines "MyHealth: Develop an application to manage health records, appointments, and medical staff with the power of AI."

The proposal identifies three problems and turns each into a research question with a matching objective:

| RQ | Problem | Objective |
| --- | --- | --- |
| RQ1 | Records are | Ingest heterogeneous data (PDF |
|   | scattered across | reports, clinician notes) and produce a |
|   | hospitals and clinics; | unified, timeline-based health |
|   | patients can't find | profile with highlighted key events |
|   | them | and trends |
| RQ2 | Booking is manual | An AI-driven scheduler using a |
|   | and frustrating; no- | predictive model (history, visit type) to |
|   | shows waste clinic | recommend optimal slots and drive |
|   | capacity | dynamic reminders |
| RQ3 | Staff buried in | AI assistance for daily task |
|   | paperwork instead of | prioritization and early |
|   | care | identification of patient risks |

C:\Users\m7mef\OneDrive\Desktop\flutter_senior currently contains only the proposal PDF — this is a greenfield build. Toolchain


verified present: Flutter 3.44.4 / Dart 3.12.2, Python 3.14.4, Node 24.11.0.

## Decisions locked in with the user:

- Storage: local-only (Drift/SQLite). No server, no cloud account, no network dependency for core function.

- AI: real API behind an interface. An AiService abstraction; the API key gets dropped in later, and a mock implementation makes the whole app work with zero key.

- Data: synthetic seeded dataset. No ethics/IRB exposure, fully reproducible demos.

- Roles: patient, staff, admin.

- Platforms: all of them (Android, Windows, Web, iOS).

## One architectural consequence to state up front

Local-only storage means "doctor opens patient's chart" happens within one device's database, not across a network. This is a legitimate and defensible design for the project — but it must be named in the report rather than glossed over. The plan handles it by:

- 1. Building a repository layer (domain/repositories/*.dart) that all features talk to, with Drift as the only implementation. A future networked implementation is a swap of one class, not a rewrite. This is the answer to "how would this scale to a real hospital?" at the defense.

- 2. Framing it in the report as offline-first architecture — a real and current pattern in clinical software, where the device works with no connectivity and reconciles later.

- 3. Listing "multi-device synchronization" explicitly under Future Work.

## Architecture

Pattern: feature-first structure over a three-layer core (presentation → domain → data), Riverpod for state, Drift for persistence, go_router for


```
lib/
main.dart
app/
app.dart MaterialApp.router, theme
router.dart go_router: role-gated rou
theme/ color scheme, typography,
core/
result.dart Result<T, Failure> — no r
failures.dart
di.dart Riverpod provider registr
utils/ date, formatting, validat
domain/
entities/ Patient, Appointment, Med
repositories/ abstract interfaces ONLY
data/
db/
app_database.dart Drift DB, schema version
tables/ one file per table group
daos/ query logic, kept out of
repositories/ Drift implementations of
seed/
seeder.dart synthetic data generator
vocab/ condition/med/lab name li
features/
auth/ patient_home/ timeline/ records/ ai_summary
booking/ appointments/ vitals/
staff_dashboard/ patient_chart/ tasks/
admin/ settings/
└ each: presentation/ (screens, widgets) + applicat
services/
ai/
ai_service.dart the interface — 3 methods
claude_ai_service.dart HTTP implementation, key
mock_ai_service.dart deterministic canned resp
prompts/ versioned prompt template
ai_result_cache.dart
ml/
```


```
no_show_predictor.dart pure-Dart inference
feature_extractor.dart Appointment+history → fea
notifications/
reminder_scheduler.dart risk-adaptive reminder lo
platform_notifier.dart local notifications + in-
ingestion/
pdf_text_extractor.dart PDF → text for RQ1
assets/
models/no_show_model.json trained weights (see tool
seed/
tools/ml/ Python — offline training
generate_dataset.py
train_no_show.py
evaluate.py
RESULTS.md
docs/
test/
```

## Packages

metrics table for the rep ERD, use-case diagrams, s

| Concern | Package |
| --- | --- |
| State | flutter_riverpod, riverpod_annotation |
| DB | drift, drift_flutter, sqlite3_flutter_libs, |
|   | drift_dev, build_runner |
| Models | freezed, json_serializable |
| Nav go_router |   |
| Charts | fl_chart (vitals trends, admin analytics) |
| Notifications | flutter_local_notifications, timezone |
| HTTP dio |   |
| Security | crypto (password hash+salt), |
|   | flutter_secure_storage (API key) |


| Files | file_picker, path_provider, |
| --- | --- |
|   | syncfusion_flutter_pdf (pure-Dart PDF text |
|   | extraction) |
| Misc | intl, uuid, shared_preferences, |
|   | google_fonts |

## Data model (Drift)

Core tables — this doubles as the ERD chapter of the report:

- users — id, role (patient/staff/admin), fullName, email, passwordHash, passwordSalt, phone, dob, gender, nationalId, isActive, createdAt

- patient_profiles — userId FK, bloodType, allergies, chronicConditions, emergencyContact

- staff_profiles — userId FK, specialty, departmentId FK, licenseNo, jobTitle

- departments — id, name, description

- schedule_templates — staffId, weekday, startTime, endTime, slotMinutes

- appointments — id, patientId, staffId, departmentId, slotStart, slotEnd, visitType, status (booked/confirmed/completed/ cancelled/noShow), reasonText, bookedAt, noShowRisk (double), riskBand, remindersSent, checkedInAt

- medical_records — id, patientId, authorStaffId, recordType (visitNote/labResult/imaging/prescription/ vaccination/discharge/referral), title, body, occurredAt, sourceFacility, attachmentPath, extractedText

- lab_values — id, recordId FK, analyte, value, unit, refLow, refHigh, abnormalFlag

- vitals — id, patientId, recordedAt, systolic, diastolic, heartRate, tempC, weightKg, heightCm, spo2, glucose

- medications — id, patientId, prescriberId, name, dose, frequency, startDate, endDate, isActive

- ai_summaries — id, patientId, generatedAt, modelId, promptVersion, summaryMarkdown, keyEventsJson, trendsJson,


redFlagsJson, inputHash (cache keyed on inputHash → identical demo output every run, and no wasted API calls)

- staff_tasks — id, staffId, patientId, title, kind, dueAt, status, aiPriorityScore, aiRationale, ruleScore

- risk_flags — id, patientId, kind, severity, rationale, detectedAt, source (rule/ai), acknowledgedBy

- reminders — id, appointmentId, scheduledFor, channel, sentAt, kind (standard/escalated/confirmRequest)

- audit_log — id, actorUserId, action, entityType, entityId, at (feeds the security/privacy chapter)

- app_settings — singleton row: aiEnabled, mockMode, modelId, seedVersion

## The three AI modules

Interface (services/ai/ai_service.dart) — exactly three methods, one per research question, so the code maps 1:1 onto the report:

```
abstract class AiService {
Future<Result<HealthSummary>> summarizeRecords(Patient
Future<Result<SlotRanking>> rankSlots(BookingContext
Future<Result<TaskRanking>> prioritizeTasks(StaffWor
}
```

Two implementations, chosen by a Riverpod provider reading app_settings.mockMode:

- MockAiService — deterministic, plausible responses. The app is fully demoable with no key and no internet. This is the defense insurance policy.

- ClaudeAiService — Dio → Anthropic Messages API. Key read from flutter_secure_storage, entered in Admin → AI Settings (never hardcoded, never committed). Requests JSON- structured output, parses into typed models, degrades to mock on any failure.


## RQ1 — Record summarization

Pipeline: gather records for a patient → PDF attachments passed through pdf_text_extractor → build a compact structured context (chronological, token-budgeted, most-recent-weighted) → prompt → parse {summary, keyEvents[], trends[], redFlags[]} → persist to ai_summaries keyed by inputHash. UI: patient Health Timeline shows the AI summary card at top; key events render as highlighted markers inline in the timeline; trends link to the corresponding fl_chart vitals graph.

## RQ2 — No-show prediction + smart scheduling

This is the one place where a real trained model belongs, because RQ2 is the question that demands measurable accuracy in the report.

- Trained offline in Python (tools/ml/train_no_show.py) — logistic regression, class-balanced, with a proper train/test split.

- Exported as assets/models/no_show_model.json (coefficients + intercept + feature schema + scaler params).

- Inference is pure Dart (no_show_predictor.dart) — no Python at runtime, no server, works offline on every platform. Small enough to be transparent, and a linear model gives you per- feature contributions → an explainable "why is this patient high- risk" panel, which is far stronger at a defense than an opaque score.

Features: lead-time days, patient prior no-show rate, prior appointment count, age band, visit type, day-of-week, hour-of-day, is-first-visit, days- since-last-visit, has-chronic-condition, reminders-acknowledged.

Consumed in three places:

- 1. Booking — candidate slots ranked by predicted risk × patient convenience; top suggestions surfaced first with a plain-language reason.

- 2. Staff dashboard — risk badge on each of today's appointments; overbooking suggestion when a block is high-risk.


- 3. Reminders — reminder_scheduler escalates by risk band: low = one reminder; medium = two; high = early reminder + confirm-or-release prompt.

## RQ3 — Task prioritization + risk detection

- RiskDetectionService — deterministic rules first: out-of- range vitals, abnormal lab flags, medication gaps, overdue follow- ups → writes risk_flags. Runs with no AI at all, so the staff dashboard is never empty.

- AiService.prioritizeTasks — LLM ranks the staff's open tasks with a written rationale per task, blended with the rule score (configurable weight) so output is never wholly unexplainable.

- Staff dashboard: prioritized task board, risk-flag panel, today's schedule with no-show badges.

## Clinical safety (deliberate, and worth a report subsection)

Every AI-generated surface carries a "AI-generated — informational only, not medical advice; verify with your clinician" banner. AI never auto-books, auto-cancels, auto-prescribes, or auto-diagnoses — every action needs human confirmation. Every stored AI output records modelId + promptVersion + timestamp for traceability.

## Feature scope by role

Patient — login/register · home (next appointment, active meds, latest AI summary) · unified health timeline w/ type filters + search · record detail + PDF import · AI health summary · vitals charts · book appointment (department → doctor → AI-recommended slots → confirm) · my appointments (cancel/reschedule) · risk-adaptive reminders · profile & settings

Staff — dashboard (today's schedule + no-show badges, AI-prioritized tasks, risk-flag panel) · patient search → patient chart (timeline, AI


summary, vitals, meds) · add clinical note / prescription / lab order · task board with AI rationale · my schedule · panel analytics (no-show rate, utilization)

Admin — user management (create/deactivate staff, reset passwords) · departments & schedule templates · system analytics dashboard · audit log viewer · AI settings (API key entry, model, mock-mode toggle) · re-seed / reset demo data

## Platform strategy (all four requested)

| Platform Windows Android |   | Status Primary dev target Primary demo target |   |   | Fastest iteration loop; DLL. Best defense fallback. notification support. | Notes sqlite3_flutter_libs bundles the Emulator + physical phone. Full |   |   |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Web |   | Supported |   |   | Drift needs sqlite3.wasm + | drift_worker.js in web/ with OPFS |   |   |
|   |   |   |   |   |   | storage — verify this in Phase 0, not Phase 6. Local notifications unavailable on web → platform_notifier falls |   |   |
|   |   |   |   |   | back to in-app banners. |   |   |   |
| iOS |   | Configured, build deferred | skipped. |   |   | Project structure and plugins are all iOS- compatible, but building requires a Mac. If no Mac is available, this is stated as a known limitation rather than silently |   |   |

platform_notifier.dart exists specifically to keep this from leaking into feature code: one capability check, notifications where supported, in-app banners where not.


## Build phases (keyed to the proposal's W1– W16, not calendar dates)

Phase 0 — Scaffold (proposal W1–3, alongside requirements/lit review) flutter create with all platforms · package install · folder structure · theme + design tokens · go_router shell with role guards · spike: verify Drift runs on Windows, Android, and Web-WASM before anything else is built on top of it.

Phase 1 — Data foundation (W4–6, "Design") All Drift tables + migrations · domain entities (freezed) · repository interfaces + Drift implementations · DAOs · synthetic seeder: ~60 patients, 12 staff, 5 departments, 2 years of appointment history with realistic no-show patterns, records, labs, vitals, meds. Seeded RNG → byte-identical data every run. · ERD exported to docs/.

Phase 2 — Auth + patient core (W7) Registration/login (salted hash), session, role routing · patient home · health timeline · record detail · PDF import + text extraction · vitals charts.

Phase 3 — AI layer (W7–8) AiService interface · MockAiService first (so UI is never blocked on a key) · ClaudeAiService · prompt templates · summary caching · RQ1 fully wired end to end.

Phase 4 — ML + scheduling (W8–9) Python: generate_dataset.py → train_no_show.py → evaluate.py → export weights JSON + RESULTS.md · Dart NoShowPredictor + FeatureExtractor + unit tests asserting Dart inference matches Python within tolerance · booking flow with ranked slots · reminder scheduler · RQ2 fully wired.

Phase 5 — Staff + admin (W9) Rule-based risk detection · staff dashboard · patient chart · task board with AI prioritization · clinical note entry · admin screens incl. AI settings · audit logging · RQ3 fully wired.

Phase 6 — Testing & results (W10–12) Unit tests (predictor, feature extractor, repositories, prompt parsing) · widget tests on key screens · integration test of the booking flow · ML metrics table · small usability test (5–8 users, SUS questionnaire) · performance measurements · accessibility pass.


Phase 7 — Report & presentation (W13–16) docs/: ERD, use-case + sequence diagrams, architecture diagram, screenshots · results chapter · demo script with an exact click path · presentation deck.

## Verification

## Every phase:

```
flutter analyze # must be clean
dart format --set-exit-if-changed lib test
flutter test
```

## Cross-platform smoke (run at the end of Phase 1 and again at Phase 6 — not only at the end):

```
flutter run -d windows
flutter run -d <android-emulator>
flutter run -d chrome
```

Each must: launch → seed → log in as patient → open timeline → book an appointment → log in as staff → see the dashboard.

## ML verification:

```
cd tools/ml
python generate_dataset.py && python train_no_show.py &&
```

evaluate.py prints accuracy / precision / recall / F1 / ROC-AUC + confusion matrix into RESULTS.md. A Dart unit test then feeds fixed feature vectors through NoShowPredictor and asserts the output matches the Python model's prediction to within 1e-6 — this is what proves the exported weights are correct.

AI verification: run the full app once in mock mode and once with a live key; confirm identical UI behaviour, that failures fall back to mock


cleanly, and that ai_summaries caching prevents duplicate API calls for unchanged input.

Defense readiness: rehearse the full demo script on Windows and Android, in airplane mode with mock AI, to prove the app cannot fail from a bad conference-room network.

## Risks

|   |   |   |   |   |   | Risk |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   | Mitigation |   |   |   |   |   |   |   |   |   |   |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
|   |   |   |   | Drift-on-Web WASM setup fights back |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   | Spiked in Phase 0, before dependent work | exists. Web is the drop-candidate if it proves costly — Android + Windows carry the demo. |   |   |   |   |   |   |   |   |   |   |   |
|   |   |   |   | internet at | No API key / no |   |   |   |   |   |   |   |   |   |   |   |   |   |   | stub. Rehearsed in airplane mode. |   |   |   | Mock mode is a first-class implementation, not a |   |   |   |   |   |   |   |   |   |   |
|   |   |   | defense |   |   |   |   |   |   |   |   |   |   |   |   |   |   | iOS needs a Mac Configured but deferred; declared as a limitation |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |
|   |   |   |   | Scope creep across 3 roles |   |   |   |   |   |   |   |   |   |   | if no Mac materializes. |   |   |   |   |   |   |   |   | Patient → staff → admin, in that order. Admin is the thinnest surface and the first to be trimmed. |   |   |   |   |   |   |   |   |   |   |
|   |   |   | defense | looks fake at | Synthetic data |   |   |   |   |   |   |   |   |   |   |   |   |   |   | (chronic patients have more visits, etc.). |   | value distributions, and correlated histories | Seeder uses realistic clinical vocab, plausible |   |   |   |   |   |   |   |   |   |   |   |
|   |   |   |   | LLM returns |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   | Typed parsing with validation, one retry, then |   |   |   |   |   |   |   |   |   |   |   |
|   |   |   |   |   |   | malformed JSON |   |   |   |   | screen. |   |   |   |   |   |   |   |   |   | automatic mock fallback. Never crashes a |   |   |   |   |   |   |   |   |   |   |   |   |   |

## Open item

The proposal is dated Semester 2, 2025/2026 (submitted 1/2/2026), but


the current date is August 2026. All phases above are keyed to the proposal's relative week numbers (W1–W16) rather than calendar dates. Confirm the actual deadline and the phases can be re-scaled to fit.
