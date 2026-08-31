# **MyHealth AI — Task Breakdown** 

Granular execution checklist derived from plan.md. Task IDs are stable — reference them in commits ( <mark>`P2-04: add health timeline` )</mark> and in your progress log. 

**Legend** — `S` ≈ under 2h · `M` ≈ half a day · `L` ≈ full day or more `→` = blocked by 

### **Progress:** 0 / 118 tasks complete 

|**Phase**<br>|**Tasks**|**Proposal**<br>**weeks**|**Theme**|
|---|---|---|---|
|0 — Scafold|14|W1–3|Project skeleton + the<br>Drift spike|
|1 — Data<br>foundation|22|W4–6|Schema, repositories,<br>synthetic seeder|
|2 — Auth +<br>patient core|18|W7|Login, timeline, records,<br>vitals|
|3 — AI layer<br>(RQ1)|14|W7–8|AiService, mock,<br>Claude, summarization|
|4 — ML +<br>scheduling (RQ2)<br>|19|W8–9|No-show model,<br>booking, reminders|
|5 — Staf + admin<br>(RQ3)|17|W9|Dashboards, tasks, risk<br>fags, admin|
|6 — Testing &<br>results|9|W10–12|Tests, metrics, usability<br>study|
|7 — Report &<br>presentation|5|W13–16|Diagrams, chapters,<br>demo script|



#### 

**Goal:** an empty app that builds and runs on Windows, Android, and Chrome, with a working local database on all three. **Do not start Phase 1 until P0-11 passes.** Everything downstream sits on Drift; if web WASM is going to be a problem, it must surface now, not in week 12. 

- ☐ **P0-01** `S` — <mark>`flutter create`</mark> in place with <mark>`--platforms android,ios,web,windows` ;</mark> confirm <mark>`flutter run`</mark> `-d` <mark>`windows`</mark> shows the counter app 

- ☐ **P0-02** `S` — Set app name ( <mark>`MyHealth AI` )</mark> , application id ( <mark>`bh.edu.uob.myhealth` )</mark> , and app icons → P0-01 

- ☐ **P0-03** `M` — Add all dependencies from plan.md to <mark>`pubspec.yaml` ;</mark> <mark>`flutter pub get`</mark> clean → P0-01 

- ☐ **P0-04** `S` — Create the full <mark>`lib/`</mark> folder tree from plan.md with <mark>`.gitkeep`</mark> placeholders 

- ☐ **P0-05** `M` — <mark>`app/theme/` :</mark> color scheme (light + dark), typography scale, spacing/radius tokens, <mark>`ThemeData`</mark> builders 

- ☐ **P0-06** `M` — <mark>`app/router.dart` :</mark> go_router with placeholder routes for every screen; <mark>`app/app.dart`</mark> wired to it → P0-04 

- ☐ **P0-07** `S` — <mark>`ProviderScope`</mark> in <mark>`main.dart` ;</mark> <mark>`core/di.dart`</mark> provider registry → P0-03 

- ☐ **P0-08** `S` — <mark>`core/result.dart`</mark> ( <mark>`Result<T, Failure>` )</mark> + <mark>`core/failures.dart`</mark> failure hierarchy 

- ☐ **P0-09** `M` — **Drift spike, Windows:** minimal one-table DB, write + read a row, confirm the sqlite3 DLL bundles into the build → P0-03 

- ☐ **P0-10** `M` — **Drift spike, Android:** same DB on emulator; confirm file lands in app documents dir → P0-09 

- ☐ **P0-11** `L` — **Drift spike, Web:** <mark>`sqlite3.wasm`</mark> + <mark>`drift_worker.js`</mark> into <mark>`web/` ,</mark> OPFS storage, same read/write test in Chrome. ⚠ **Decision gate** — if this costs more than a day, drop web to "not supported" in the report and move on → P0-09 

- ☐ **P0-12** `S` — <mark>`analysis_options.yaml`</mark> with strict lints; <mark>`flutter analyze`</mark> clean 

- ☐ **P0-13** `S` — <mark>`git init` ,</mark> <mark>`.gitignore`</mark> covering <mark>`*.g.dart`</mark> decisions, build dirs, and **any file that could hold an API key** 

- ☐ **P0-14** `S` — <mark>`README.md` :</mark> how to run per platform, how to seed, 

how to add the AI key 

## **Phase 1 — Data foundation** 

**Goal:** a fully populated database. By the end of this phase you can query realistic patients, appointments, and records — with no UI yet. 

### **Schema** 

- ☐ **P1-01** `M` — <mark>`data/db/tables/users.dart` :</mark> users, patient_profiles, staff_profiles, departments 

- ☐ **P1-02** `M` — <mark>`tables/appointments.dart` :</mark> appointments, schedule_templates, reminders 

- ☐ **P1-03** `M` — <mark>`tables/records.dart` :</mark> medical_records, lab_values, vitals, medications 

- ☐ **P1-04** `M` — <mark>`tables/ai.dart` :</mark> risk_flags 

- ☐ **P1-05** `S` — <mark>`tables/system.dart` :</mark> audit_log, app_settings 

- ☐ **P1-06** `M` — <mark>`app_database.dart` :</mark> assemble tables, <mark>`schemaVersion`</mark> `= 1` , migration strategy, platform-aware connection → P1-01…P1-05 

- ☐ **P1-07** `S` — <mark>`build_runner`</mark> generation clean; DB opens on all three platforms → P1-06 

### **Domain** 

- ☐ **P1-08** `M` 

- ☐ **P1-09** `M` — freezed entities for appointment/record/lab value/ vitals/medication 

- ☐ **P1-10** `S` 

- ☐ **P1-11** `M` — Abstract repository interfaces in <mark>`domain/ repositories/`</mark> (auth, patient, appointment, record, vitals, task, risk, admin) — **interfaces only, no Drift imports** 

### **DAOs + repositories** 

- ☐ **P1-12** `M` — <mark>`daos/user_dao.dart`</mark> + <mark>`AuthRepositoryImpl` ,</mark> 

<mark>`UserRepositoryImpl`</mark> → P1-11 

- ☐ **P1-13** `M` — <mark>`daos/appointment_dao.dart`</mark> + <mark>`AppointmentRepositoryImpl`</mark> (incl. slot availability query) → P1-11 

- ☐ **P1-14** `M` — <mark>`daos/record_dao.dart`</mark> + <mark>`RecordRepositoryImpl`</mark> (timeline query: records + labs + vitals merged, sorted, paginated) → P1-11 

- ☐ **P1-15** `S` — <mark>`daos/vitals_dao.dart`</mark> + <mark>`VitalsRepositoryImpl`</mark> (series queries for charts) → P1-11 

- ☐ **P1-16** `S` — <mark>`daos/task_dao.dart` ,</mark> <mark>`daos/risk_dao.dart`</mark> + implementations → P1-11 

- ☐ **P1-17** `S` — <mark>`AuditRepositoryImpl`</mark> + a helper that any write path can call → P1-11 

- ☐ **P1-18** `S` — Register every repository in <mark>`core/di.dart`</mark> → P1-12…P1-17 

### **Seeder** 

- ☐ **P1-19** `M` — <mark>`data/seed/vocab/` :</mark> Bahraini/Arabic + English name lists, conditions, medications, lab analytes with real reference ranges, department names 

- ☐ **P1-20** `L` — <mark>`seeder.dart` :</mark> staff, 5 departments, 2 years of appointment history. **Correlated, not random** — chronic patients have more visits, some patients have genuinely high no-show rates, lab values drift over time → P1-19, P1-07 

- ☐ **P1-21** `S` — Seeder is idempotent + re-runnable ( <mark>`seedVersion`</mark> in app_settings); "reset demo data" path works → P1-20 

- ☐ **P1-22** `M` — Export the ERD to <mark>`docs/erd.png`</mark> schema → P1-06 

## **Phase 2 — Auth + patient core** 

**Goal:** a patient can log in and browse their entire health history. No AI yet. 

- ☐ **P2-01** `M` — <mark>`services/auth/password_hasher.dart` :</mark> 

salted SHA-256 (+ iteration count). Document in the report that production would use Argon2/bcrypt 

- ☐ **P2-02** `M` — Login screen + controller; validation, error states → P2-01 

- ☐ **P2-03** `M` <mark>`patient_profiles` )</mark> → P2-01 

- ☐ **P2-04** `S` — Session provider (current user) + persistence across restarts → P2-02 

- ☐ **P2-05** `M` — **Role-gated routing** different shells; deep links guarded → P2-04, P0-06 

- ☐ **P2-06** `S` — Logout + "switch user" (needed constantly during the demo) 

- ☐ **P2-07** `M` — Patient home: next appointment card, active medications, quick actions, empty states 

- ☐ **P2-08** `L` — **Health timeline** : chronological merged feed (visits, labs, imaging, prescriptions, vaccinations), grouped by month, lazy-loaded → P1-14 

- ☐ **P2-09** `M` P2-08 

- ☐ **P2-10** `M` — Record detail screen per type; lab results render as a table with abnormal values flagged → P2-08 

- ☐ **P2-11** `M` — <mark>`pdf_text_extractor.dart` :</mark> PDF → plain text, with page-count and size guards 

- ☐ **P2-12** `M` — Import a record: <mark>`file_picker`</mark> → copy into app documents dir → extract text → create <mark>`medical_records`</mark> row → P2-11 

- ☐ **P2-13** `S` — Attachment viewer / open-externally 

- ☐ **P2-14** `M` — Vitals list + manual entry form → P1-15 

- ☐ **P2-15** `M` — Vitals charts with <mark>`fl_chart` :</mark> BP (dual line), weight, glucose, heart rate; range selector → P1-15 

- ☐ **P2-16** `S` — Medications list, active vs. past → P1-09 

- ☐ **P2-17** `M` toggle) 

- ☐ **P2-18** `S` — Shared widgets: empty state, error state, loading skeleton, confirmation dialog, section header 

**Phase 3 — AI layer (RQ1)** 

**Goal:** RQ1 answered end to end. Build <mark>`MockAiService`</mark> **before** the real one so no screen is ever blocked waiting on a key. 

- ☐ **P3-01** `M` — <mark>`ai_service.dart` :</mark> the 3-method interface + freezed request/response models ( <mark>`HealthSummary` ,</mark> <mark>`KeyEvent` ,</mark> <mark>`Trend` ,</mark> <mark>`RedFlag` )</mark> 

- ☐ **P3-02** `M` — <mark>`PatientContext`</mark> builder: gather records, **tokenbudget them** (recency-weighted, truncate oldest), produce a compact structured text block → P1-14 

- ☐ **P3-03** `M` — <mark>`MockAiService` :</mark> deterministic responses derived from actual patient data so it _looks_ real in a demo → P3-01 

- ☐ **P3-04** `S` — <mark>`prompts/summarize_records.dart` :</mark> versioned template, strict JSON output contract → P3-01 

- ☐ **P3-05** `L` — <mark>`ClaudeAiService` :</mark> Dio client, Anthropic Messages API, typed JSON parsing, timeout + one retry, **automatic fallback to mock on any failure** → P3-04 

- ☐ **P3-06** `M` — API key storage in <mark>`flutter_secure_storage` ;</mark> never logged, never in source, never committed → P3-05 

- ☐ **P3-07** `S` — <mark>`aiServiceProvider`</mark> selects mock vs. real from <mark>`app_settings.mockMode`</mark> → P3-03, P3-05 

- ☐ **P3-08** `M` — <mark>`ai_result_cache.dart` :</mark> hash the input context, reuse <mark>`ai_summaries`</mark> row on match → P1-04 

- ☐ **P3-09** `M` — AI summary screen: markdown summary, key events, trends, red flags → P3-02, P3-08 

- ☐ **P3-10** `S` — Summary card on patient home + "regenerate" action → P3-09 

- ☐ **P3-11** `M` — Key events rendered as highlighted markers **inline in the timeline** → P3-09, P2-08 

- ☐ **P3-12** `S` — Trends link through to the matching vitals chart → P3-09, P2-15 

- ☐ **P3-13** `S` — ⚠ **Safety banner** component on every AI surface: _"AI-generated — informational only, not medical advice; verify with your clinician"_ 

- ☐ **P3-14** `S` — Persist <mark>`modelId`</mark> + <mark>`promptVersion`</mark> + timestamp with every AI output (traceability for the report) → P3-08 

## **Phase 4 — ML + scheduling (RQ2)** 

**Goal:** RQ2 answered with **real, reportable accuracy numbers** . This is the phase that produces your results chapter. 

### ( <mark>`tools/ml/` ,</mark> never shipped in the app) 

- ☐ **P4-01** `S` — <mark>`requirements.txt`</mark> + venv (scikit-learn, pandas, numpy, matplotlib) 

- ☐ **P4-02** `M` — <mark>`generate_dataset.py` :</mark> synthetic appointment history with **realistic, learnable no-show signal** — must mirror the Dart seeder's logic → P1-20 

- ☐ **P4-03** `M` — <mark>`features.py` :</mark> the 11 features from plan.md; **this encoding must match** **<mark>`feature_extractor.dart`</mark> exactly** → P4-02 

- ☐ **P4-04** `M` — <mark>`train_no_show.py` :</mark> scaler, class-balanced logistic regression → P4-03 

- ☐ **P4-05** `M` — <mark>`evaluate.py` :</mark> accuracy, precision, recall, F1, ROC-AUC, confusion matrix, ROC curve PNG → <mark>`RESULTS.md`</mark> → P4-04 

- ☐ **P4-06** `S` — Export <mark>`assets/models/no_show_model.json` :</mark> coefficients, intercept, scaler mean/scale, feature schema, model version → P4-04 

- ☐ **P4-07** `S` — Baseline comparison (majority-class + simple heuristic) so the model's value is demonstrable, not assumed → P4-05 

### **Dart — inference** 

- ☐ **P4-08** `M` — <mark>`feature_extractor.dart` :</mark> appointment + patient history → feature vector, **identical encoding to P4-03** → P4-03 

- ☐ **P4-09** `M` — <mark>`no_show_predictor.dart` :</mark> load JSON weights, scale, sigmoid, → probability + risk band → P4-06 

- ☐ **P4-10** `M` — **Per-feature contribution breakdown** scaled value) — this is your explainability story at the defense → P4-09 

- ☐ **P4-11** `M` — ⚠ **Parity test** Python and Dart, assert agreement within <mark>`1e-6` .</mark> This is the proof the export is correct → P4-08, P4-09 

#### 

- ☐ **P4-12** `M` — Slot generator from <mark>`schedule_templates`</mark> minus booked appointments → P1-13 

- ☐ **P4-13** `M` — Booking wizard: department → doctor → date → 

- ☐ **P4-14** `M` — Slot ranking: predicted risk × patient convenience; top picks surfaced with a plain-language reason → P4-09, P4-12 

- ☐ **P4-15** `S` — Optional LLM rationale layer via <mark>`AiService.rankSlots`</mark> (degrades silently if unavailable) → P3-01, P4-14 

- ☐ **P4-16** `M` — My appointments: upcoming/past, cancel, reschedule → P1-13 

- ☐ **P4-17** `S` — Store <mark>`noShowRisk`</mark> + <mark>`riskBand`</mark> on the appointment row at booking time → P4-09 

### **Reminders** 

- ☐ **P4-18** `M` — <mark>`platform_notifier.dart` :</mark> where supported, **in-app banner fallback on web** → P0-11 

- ☐ **P4-19** `M` — <mark>`reminder_scheduler.dart` :</mark> risk-adaptive escalation — low = 1 reminder, medium = 2, high = early reminder + confirm-or-release prompt → P4-17, P4-18 

#### 

**Goal:** RQ3 answered. must be useful with the AI switched off entirely. 

### **Risk detection (deterministic)** 

- ☐ **P5-01** `M` — <mark>`RiskDetectionService` :</mark> out-of-range vitals, abnormal lab flags, medication gaps, overdue follow-ups → writes <mark>`risk_flags`</mark> → P1-16 

- ☐ **P5-02** `S` same thing daily) → P5-01 

- ☐ **P5-03** `S` — Rule-based task generator: follow-ups due, unreviewed abnormal labs, unsigned notes → P5-01 

#### 

- ☐ **P5-04** `M` 

- ☐ **P5-05** `L` **no-show risk badges** , prioritized task list, risk-flag panel → P4-17, P5-01 

- ☐ **P5-06** `M` — Patient search + patient list → P1-12 

- ☐ **P5-07** `L` — **Patient chart** (read view): timeline, AI summary, vitals charts, medications, labs — reuse Phase 2 widgets, don't rebuild → P2-08, P3-09 

- ☐ **P5-08** `M` — Add clinical note (creates a <mark>`medical_records`</mark> row, authored by staff) → P1-14 

- ☐ **P5-09** `M` — Prescribe medication + order lab result entry → P1-09 

- ☐ **P5-10** `M` — <mark>`prioritizeTasks`</mark> prompt + parsing; **blend AI score with rule score** at a configurable weight → P3-01, P5-03 

- ☐ **P5-11** `M` — Task board: priority order, per-task AI rationale shown, mark done → P5-10 

- ☐ **P5-12** `S` → P1-13 

- ☐ **P5-13** `M` — Panel analytics: no-show rate, slot utilization, risk distribution ( <mark>`fl_chart` )</mark> → P4-17 

### **Admin** 

- ☐ **P5-14** `M` password, assign department → P1-12 

- ☐ **P5-15** `M` — Departments + schedule template editor → P1-13 

- ☐ **P5-16** `M` — **AI settings** : API key entry, model selection, mockmode toggle, connection test, re-seed/reset demo data → P3-06, P1-21 

- ☐ **P5-17** `M` by actor/entity/date) → P1-17 

## **Phase 6 — Testing & results** 

**Goal:** evidence. Every number that goes in the report gets produced here. 

- ☐ **P6-01** `M` — Unit tests: <mark>`NoShowPredictor` ,</mark> <mark>`FeatureExtractor` ,</mark> risk rules, password hashing 

- ☐ **P6-02** `M` — Unit tests: repositories against an in-memory Drift DB 

- ☐ **P6-03** `M` — Unit tests: AI response parsing — valid JSON, **malformed JSON** , timeout, empty response → all must fall back cleanly 

- ☐ **P6-04** `M` dashboard 

- ☐ **P6-05** `M` — Integration test: seed → login → book → verify persisted → staff sees it 

- ☐ **P6-06** `M` — ⚠ **Cross-platform smoke on Windows + Android + Chrome** , full demo path each. Do not leave this to the final week 

- ☐ **P6-07** `L` — Usability study: 5–8 participants, task list, **SUS questionnaire** , write up scores + observations 

- ☐ **P6-08** `M` — Performance: timeline load with 2 years of data, summary generation latency, cold start, DB size 

- ☐ **P6-09** `M` — Accessibility pass: contrast ratios, touch targets, screen-reader labels, text scaling 

## **Phase 7 — Report & presentation** 

- ☐ **P7-01** `M` — <mark>`docs/` :</mark> architecture diagram, use-case diagram, sequence diagrams (booking flow, AI summarization flow) → P1-22 

- ☐ **P7-02** `M` — Screenshot set covering every major screen, both roles, light + dark 

- ☐ **P7-03** `L` — Results chapter: ML metrics table, baseline comparison, SUS score, performance figures → P4-05, P4-07, P6-07, P6-08 

- ☐ **P7-04** `M` — ⚠ **Demo script** : exact click path, rehearsed on Windows _and_ Android, **in airplane mode with mock AI** — a bad conference-room network must not be able to sink the defense 

- ☐ **P7-05** `L` — Presentation deck + rehearsal 

## **Suggested execution order** 

The dependency graph allows some parallelism if you and Mohammed split work: 

|**Track**|**Owner A**|**Owner B**|
|---|---|---|
|After<br>Phase 1|Phase 2 (patient<br>UI)|Phase 4 Python track (P4-01…<br>P4-07) — fully independent|
|After<br>Phase 3|Phase 4 Dart +<br>booking|Phase 5 rules + staf shell (P5-01…<br>P5-06)|
|Phase 6|Tests +<br>performance|Usability study + accessibility|



### **Hard sequencing rules — don't break these:** 

1. **P0-11 gates everything.** Settle web/Drift before building on it. 

2. **P3-03 (mock) before P3-05 (real).** Never let UI work block on an API key. 

3. **P4-11 (parity test) before any booking UI consumes the model.** A silently mis-exported model produces confidently wrong 

numbers in your report. 

4. **P5-01 (rules) before P5-10 (AI tasks).** The dashboard must work 

