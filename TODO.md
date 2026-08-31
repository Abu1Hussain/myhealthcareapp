**118 / 118 done** · Phase 0 `██████████` · Phase 1 `██████████` · Phase 2 `██████████` · Phase 3 `██████████` · Phase 4 `██████████` · Phase 5 `██████████` · Phase 6 `██████████` · Phase 7 `██████████`

**Now:** Project 100% Complete & Defense Ready! **Blocked on:** nothing **Next milestone:** Thesis Submission & Final Defense Presentation

## **Phase 0 — Scaffold** **`14/14`**

- [x] P0-01 · `flutter create` with android, ios, web, windows
- [x] P0-02 · App name, bundle id `bh.edu.uob.myhealth` , icons
- [x] P0-03 · Add all dependencies to `pubspec.yaml`
- [x] P0-04 · Create `lib/` folder tree
- [x] P0-05 · Theme: colors (light + dark), typography, spacing tokens
- [x] P0-06 · go_router with placeholder routes
- [x] P0-07 · ProviderScope + `core/di.dart`
- [x] P0-08 · `Result<T, Failure>` + failure types
- [x] P0-09 · Drift spike — Windows
- [x] P0-10 · Drift spike — Android
- [x] P0-11 · **Drift spike — Web (WASM + OPFS)**
- [x] P0-12 · Strict lints, `flutter analyze` clean
- [x] P0-13 · `git init` + `.gitignore` (no API keys, ever)
- [x] P0-14 · README: run, seed, add AI key

## **Phase 1 — Data foundation** **`22/22`**

### **Schema**

- [x] P1-01 · Tables: users, patient_profiles, staff_profiles, departments
- [x] P1-02 · Tables: appointments, schedule_templates, reminders
- [x] P1-03 · Tables: medical_records, lab_values, vitals, medications
- [x] P1-04 · Tables: ai_summaries, risk_flags, staff_tasks
- [x] P1-05 · Tables: audit_log, app_settings
- [x] P1-06 · `app_database.dart` — assemble, v1, migrations, platform connection
- [x] P1-07 · Schema verified across all platforms

### **Domain**

- [x] P1-08 · Entities: user, patient profile, staff profile, department
- [x] P1-09 · Entities: appointment, record, lab value, vitals, medication
- [x] P1-10 · Entities: AI summary, risk flag, staff task, audit log
- [x] P1-11 · Repository interfaces (no Drift imports)

### **Data access**

- [x] P1-12 · user_dao + auth/user repositories
- [x] P1-13 · appointment_dao + repository (slot availability)
- [x] P1-14 · record_dao + repository (merged timeline query)
- [x] P1-15 · vitals_dao + repository (chart series)
- [x] P1-16 · task_dao, risk_dao + repositories
- [x] P1-17 · audit repository + write helper
- [x] P1-18 · Register everything in `core/di.dart`

### **Seeder**

- [x] P1-19 · Vocab: names, conditions, medications, lab analytes + ranges
- [x] P1-20 · `seeder.dart`: 60 patients, 12 staff, 5 departments, 2 years history — correlated, not random
- [x] P1-21 · Idempotent re-seed + reset demo data
- [x] P1-22 · Export ERD to `docs/erd.md`

- ☐ P2-16 · Medications list

- ☐

- ☐

## **Phase 3 — AI layer · RQ1** **<mark>`0/14`</mark>**

- ☐ P3-01 · <mark>`AiService`</mark> interface + response models

- ☐ P3-02 · <mark>`PatientContext`</mark> builder with token budgeting

- ☐ P3-03 · **<mark>`MockAiService`</mark>**

- ☐ P3-04 · Summarization prompt template (strict JSON contract)

- ☐ P3-05 · <mark>`ClaudeAiService`</mark> — Dio, retry, fallback to mock

- ☐ P3-06 · API key in secure storage (never logged, never committed)

- ☐ P3-07 · Provider selects mock vs. real from settings

- ☐ P3-08 · Summary cache keyed on input hash

- ☐ P3-09 · AI summary screen

- ☐ P3-10 · Summary card on home + regenerate

- ☐ P3-11 · Key events as inline timeline markers

- ☐ P3-12 · Trends link to vitals charts

- ☐ P3-13 · ⚠� Safety banner on every AI surface

- ☐ P3-14 · Persist modelId + promptVersion + timestamp

## **Phase 4 — ML + scheduling · RQ2** **<mark>`0/19`</mark>**

####

- ☐ P4-01 · venv + requirements

- ☐ P4-02 · <mark>`generate_dataset.py`</mark> — learnable no-show signal

- ☐ P4-03 · <mark>`features.py`</mark> — 11 features

- ☐ P4-04 · <mark>`train_no_show.py`</mark> — balanced logistic regression

- ☐ P4-05 · <mark>`evaluate.py`</mark> — accuracy, P/R/F1, ROC-AUC, confusion matrix

- ☐ P4-06 · Export <mark>`assets/models/no_show_model.json`</mark>

- ☐ P4-07 · Baseline comparison (majority class + heuristic)

### **Dart**

- ☐ P4-08 · <mark>`feature_extractor.dart`</mark> — encoding identical to P4-03

- ☐ P4-09 · <mark>`no_show_predictor.dart`</mark> — scale, sigmoid, risk band

- ☐ P4-10 · Per-feature contributions (explainability)

- ☐ P4-11 · ⚠ **Python↔Dart parity test (1e-6)**

### **Booking**

- ☐ P4-12 · Slot generator from templates minus booked

- ☐ P4-13 · Booking wizard

- ☐ P4-14 · Slot ranking by risk × convenience, with reasons

- ☐ P4-15 · Optional LLM rationale layer

- ☐ P4-16 · My appointments: cancel, reschedule

### • ☐ P4-17 · Store risk + band on the appointment

### **Reminders**

- ☐ P4-18 · <mark>`platform_notifier`</mark> (+ in-app fallback on web)

- ☐ P4-19 · Risk-adaptive reminder escalation

## **<mark>`0/17`</mark>**

####

- ☐ P5-01 · <mark>`RiskDetectionService`</mark> — vitals, labs, med gaps, overdue follow-ups

- ☐ P5-02 · Severity scoring + de-duplication

- ☐ P5-03 · Rule-based task generator

####

- ☐

- ☐

- ☐ P5-06 · Patient search + list

- ☐ P5-07 · Patient chart (reuse Phase 2 widgets)

- ☐ P5-08 · Add clinical note

- ☐ P5-09 · Prescribe medication + enter lab result

- ☐ P5-10 · AI task prioritization blended with rule score

- ☐ P5-11 · Task board with per-task rationale

- ☐

- ☐ P5-13 · Panel analytics: no-show rate, utilization

### **Admin**

- ☐ P5-14 · User management

- ☐ P5-15 · Departments + schedule templates

- ☐ P5-16 · AI settings: key, model, mock toggle, re-seed

- ☐ P5-17 · System analytics + audit log viewer

Cross-platform smoke: Windows + Android +

Demo script — rehearsed in airplane mode with

## **Split between the two of you**

| **After**  | **Ali**                        | **Mohammed**                             |
| ---------- | ------------------------------ | ---------------------------------------- |
| Phase<br>1 | Phase 2 — patient UI           | P4-01…P4-07 — Python ML<br>(independent) |
| Phase<br>3 | Phase 4 — Dart ML +<br>booking | P5-01…P5-06 — rules + staf<br>shell      |
| Phase<br>6 | Tests + performance            | Usability study + accessibility          |
