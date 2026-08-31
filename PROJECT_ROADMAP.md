# MyHealth AI — Project Execution Roadmap & Phase Breakdown

> **Project Goal:** Build an offline-first, multi-platform health record management, predictive appointment scheduling, and clinical workflow application for university senior project defense.
> **Team:** Ali Mohamed Jaafar Mohamed (202208244) & Mohammed A.Redha Meftah (202209027) | **Supervisor:** Dr. Amal Ghanim
> **Target Platforms:** Windows, Android, Web, iOS (Flutter 3.44+ / Dart 3.12+ / Python 3.14+)

---

## 📊 Global Project Progress Trac- [x] **Phase 0 — Project Scaffold & Platform Spike** `(14 / 14)` `[██████████] 100%`
- [x] **Phase 1 — Data Foundation & Seeder** `(22 / 22)` `[██████████] 100%`
- [x] **Phase 2 — Auth & Patient Core (Timeline & Records)** `(18 / 18)` `[██████████] 100%`
- [x] **Phase 3 — AI Layer & Summarization (RQ1)** `(14 / 14)` `[██████████] 100%`
- [x] **Phase 4 — ML No-Show Model & Smart Scheduling (RQ2)** `(19 / 19)` `[██████████] 100%`
- [x] **Phase 5 — Staff Dashboard, Risk Rules & Admin (RQ3)** `(17 / 17)` `[██████████] 100%`
- [x] **Phase 6 — Testing, Metrics & Usability Validation** `(9 / 9)` `[██████████] 100%`
- [x] **Phase 7 — Report Documentation & Defense Readiness** `(5 / 5)` `[██████████] 100%`

**Total Completion:** `118 / 118 Tasks Done` (`100%` — Complete!)

---

## 🎯 3 Core Pillars & Research Questions

| ID | Core Problem | Solution Architecture | Research Objective |
| --- | --- | --- | --- |
| **RQ1** | Health records scattered across providers; patients unable to view trends | Offline PDF extraction + Chronological Drift DB Timeline + LLM Context Budgeting | Ingest heterogeneous medical data into a unified timeline with AI event markers & trend analysis |
| **RQ2** | Manual booking & high patient no-show rates wasting clinic capacity | Python logistic regression model exported to Dart `NoShowPredictor` (11 features) | Predict appointment no-show probability, rank optimal slots, and trigger risk-adaptive reminders |
| **RQ3** | Medical staff buried in daily paperwork & manual risk triage | Rule-based `RiskDetectionService` + LLM Task Prioritization score blending | Automatically flag out-of-bounds vitals/labs and prioritize staff tasks with explainable rationale |

---

## 🏗 Key Architectural Decisions

1. **Local-First Database (Drift / SQLite):** Zero cloud/server dependency. All patient data, appointments, and clinical records live locally on device.
2. **Dual AI Implementation (`AiService`):**
   - `MockAiService`: Canned deterministic responses (guarantees a 100% working defense demo without internet/API keys).
   - `ClaudeAiService`: Dio client contacting Anthropic Messages API with secure storage API keys.
3. **Pure-Dart ML Engine:** Offline inference in Dart using exported JSON weights (`no_show_model.json`). No Python runtime needed on device.
4. **Synthetic Seed Data:** Realistically correlated synthetic clinical datasets (~60 patients, 12 staff, 2 years history) with deterministic RNG seeding.

---

## 🚀 Execution Phases & Step-by-Step Parts

### Part 0: Project Scaffold & Platform Spike (Phase 0)
> **Goal:** Create an empty, lint-clean Flutter app running on Windows, Android, and Web with local Drift SQLite working across all 3.
> ⚠️ **Decision Gate:** P0-11 (Web WASM spike) must pass or web support is marked as deferred.

- [x] `P0-01` [S] Run `flutter create` with `--platforms android,ios,web,windows`
- [x] `P0-02` [S] Set app name (`MyHealth AI`), package ID (`bh.edu.uob.myhealth`), and app icons
- [x] `P0-03` [M] Add dependencies to `pubspec.yaml` (`riverpod`, `drift`, `fl_chart`, `go_router`, `dio`, `freezed`)
- [x] `P0-04` [S] Create project directory structure under `lib/`
- [x] `P0-05` [M] Build `app/theme/` (Color scheme, typography scale, spacing tokens)
- [x] `P0-06` [M] Setup `app/router.dart` with `go_router` shell and role placeholder routes
- [x] `P0-07` [S] Setup `ProviderScope` in `main.dart` and `core/di.dart`
- [x] `P0-08` [S] Implement `Result<T, Failure>` pattern in `core/result.dart` and `core/failures.dart`
- [x] `P0-09` [M] Drift spike on Windows (verify SQLite DLL bundling & read/write)
- [x] `P0-10` [M] Drift spike on Android (verify SQLite file creation in app storage)
- [x] `P0-11` [L] Drift spike on Web (`sqlite3.wasm` + OPFS storage in Chrome) — *Decision Gate*
- [x] `P0-12` [S] Configure `analysis_options.yaml` with strict lints
- [x] `P0-13` [S] Initialize `git` and configure `.gitignore` (block API keys and generated files)
- [x] `P0-14` [S] Create `README.md` with build and setup instructions

---

### Part 1: Data Foundation & Synthetic Seeder (Phase 1)
> **Goal:** Define the complete database schema, repository abstraction, and seed 2 years of realistic clinical history.

- [x] `P1-01` [M] Create `users.dart` table schema (users, patient_profiles, staff_profiles, departments)
- [x] `P1-02` [M] Create `appointments.dart` table schema (appointments, schedule_templates, reminders)
- [x] `P1-03` [M] Create `records.dart` table schema (medical_records, lab_values, vitals, medications)
- [x] `P1-04` [M] Create `ai.dart` table schema (ai_summaries, risk_flags, staff_tasks)
- [x] `P1-05` [S] Create `system.dart` table schema (audit_log, app_settings)
- [x] `P1-06` [M] Build `app_database.dart` with tables, schema v1, and migrations
- [x] `P1-07` [S] Schema verified across all platforms
- [x] `P1-08` [M] Create domain models & entity data classes
- [x] `P1-09` [M] Create entities for appointments, records, lab values, vitals, and meds
- [x] `P1-10` [S] Create entities for AI summary, risk flag, staff task, audit log, app settings
- [x] `P1-11` [M] Define abstract repository interfaces in `domain/repositories/` (no Drift code)
- [x] `P1-12` [M] Implement `UserDao` & `AuthRepositoryImpl`
- [x] `P1-13` [M] Implement `AppointmentDao` & `AppointmentRepositoryImpl` (including slot availability query)
- [x] `P1-14` [M] Implement `RecordDao` & `RecordRepositoryImpl` (merged timeline query)
- [x] `P1-15` [S] Implement `VitalsDao` & `VitalsRepositoryImpl` (chart series data)
- [x] `P1-16` [S] Implement `TaskDao`, `RiskDao`, and their concrete repository classes
- [x] `P1-17` [S] Implement `AuditRepositoryImpl` with write-audit helper
- [x] `P1-18` [S] Register all repositories in `core/di.dart`
- [x] `P1-19` [M] Build synthetic vocabulary in `data/seed/vocab/` (Bahraini names, conditions, labs)
- [x] `P1-20` [L] Build `seeder.dart` (60 patients, 12 staff, 5 departments, correlated history)
- [x] `P1-21` [S] Implement idempotent re-seed and "Reset Demo Data" option
- [x] `P1-22` [M] Generate and export Database ERD diagram to `docs/erd.md`

---

### Part 2: Auth & Patient Core (Phase 2)
> **Goal:** Build the complete patient-facing app experience: Auth, Health Timeline, Record Ingestion, and Vitals Charts.

- [x] `P2-01` [M] Build `password_hasher.dart` with salted SHA-256
- [x] `P2-02` [M] Build `LoginScreen` + controller with validation
- [x] `P2-03` [M] Build `RegisterScreen` + controller for patients
- [x] `P2-04` [S] Build `currentUserProvider` + `shared_preferences` session persistence
- [x] `P2-05` [M] Implement role-gated router redirects in `GoRouter.redirect`
- [x] `P2-06` [S] Build logout + `QuickSwitchUserDialog` demo switcher
- [x] `P2-07` [M] Build `PatientHomeScreen` dashboard
- [x] `P2-08` [L] Build `TimelineScreen` chronological feed
- [x] `P2-09` [M] Add search & record type filter chips to timeline
- [x] `P2-10` [M] Build `RecordDetailScreen` for consultation notes & structured lab tables
- [x] `P2-11` [M] Build `pdf_text_extractor.dart` using Syncfusion PDF
- [x] `P2-12` [M] Build `ImportRecordModal` for PDF document ingestion
- [x] `P2-13` [S] Build parsed PDF document text section
- [x] `P2-14` [M] Build `LogVitalsModal` entry form
- [x] `P2-15` [M] Build `VitalsScreen` interactive `fl_chart` graphs (Blood Pressure & Glucose)
- [x] `P2-16` [S] Build `MedicationsScreen` (Active vs Historical)
- [x] `P2-17` [M] Build `PatientProfileScreen` & settings
- [x] `P2-18` [S] Build shared UI components (`DoubleBezelCard`, `SkeletalShimmer`, `ClinicalBadge`, `SafetyBanner`)

---

### Part 3: AI Layer & Health Summarization — RQ1 (Phase 3)
> **Goal:** Complete RQ1 by producing token-budgeted medical context feeds into Claude LLM with fallback to `MockAiService`.

- [x] `P3-01` [M] Define `AiService` interface & response data models (`HealthSummary`, `KeyEvent`, `Trend`)
- [x] `P3-02` [M] Build `PatientContextBuilder` (recency-weighted token budgeting of timeline)
- [x] `P3-03` [M] Implement `MockAiService` (plausible canned responses for offline defense)
- [x] `P3-04` [S] Create versioned prompt template `prompts/summarize_records.dart` with JSON schema
- [x] `P3-05` [L] Implement `ClaudeAiService` (Dio client + Anthropic Messages API + retry logic)
- [x] `P3-06` [S] Store API keys securely via `flutter_secure_storage`
- [x] `P3-07` [S] Connect Riverpod AI provider to switch between mock and real service via settings
- [x] `P3-08` [M] Build `ai_result_cache.dart` (hash input context to prevent duplicate API calls)
- [x] `P3-09` [M] Build AI Health Summary UI screen (markdown overview, key events, trends)
- [x] `P3-10` [S] Add AI Summary card widget on Patient Home screen
- [x] `P3-11` [M] Render AI key event markers inline inside the Patient Health Timeline
- [x] `P3-12` [S] Connect AI trends to open corresponding `fl_chart` vitals graphs
- [x] `P3-13` [S] Add mandatory Clinical Safety Banner on all AI surfaces
- [x] `P3-14` [S] Record `modelId`, `promptVersion`, and timestamp on all generated AI summaries

---

### Part 4: ML No-Show Model & Smart Scheduling — RQ2 (Phase 4)
> **Goal:** Train logistic regression model in Python, export JSON weights, build pure-Dart predictor, and build risk-adaptive scheduler.

#### Python ML Pipeline (`tools/ml/`)
- [x] `P4-01` [S] Setup Python environment & `requirements.txt` (`scikit-learn`, `pandas`, `numpy`)
- [x] `P4-02` [M] Create `generate_dataset.py` (synthetic appointment dataset matching clinic distributions)
- [x] `P4-03` [M] Create `features.py` (11 clinical & behavioral features)
- [x] `P4-04` [M] Create `train_no_show.py` (class-balanced logistic regression model)
- [x] `P4-05` [M] Create `evaluate.py` (Generate accuracy, P/R/F1, ROC-AUC into `docs/ml_results.md`)
- [x] `P4-06` [S] Export `assets/models/no_show_model.json` (coefficients, intercept, scaler values)
- [x] `P4-07` [S] Train baseline heuristic models for comparative performance tables in report

#### Dart ML Inference & Smart Booking Engine
- [x] `P4-08` [M] Build `feature_extractor.dart` in Dart matching Python encoding exactly
- [x] `P4-09` [M] Build `no_show_predictor.dart` (pure-Dart matrix math & sigmoid inference)
- [x] `P4-10` [M] Implement per-feature contribution scoring for explainable AI defense panels
- [x] `P4-11` [M] ⚠️ **Parity Test:** Unit test asserting Dart inference matches Python within `1e-6`
- [x] `P4-12` [M] Build Slot Generator algorithm (from doctor schedule templates)
- [x] `P4-13` [M] Build Booking Wizard UI (Department → Doctor → Date → Ranked Slot)
- [x] `P4-14` [M] Implement Slot Ranking algorithm (Risk score × patient convenience)
- [x] `P4-15` [S] Integrate Explainable AI rationale chips for top recommended booking slots
- [x] `P4-16` [M] Build "My Appointments" management screen (Reschedule & Cancel)
- [x] `P4-17` [S] Persist `noShowRisk` score and `riskBand` on appointment records
- [x] `P4-18` [M] Build `platform_notifier.dart` (Local notifications + Web in-app banners)
- [x] `P4-19` [M] Build `reminder_scheduler.dart` (Risk-adaptive escalation: low=1, med=2, high=escalated)

---

### Part 5: Staff Dashboard, Risk Detection & Admin — RQ3 (Phase 5)
> **Goal:** Complete RQ3 with rule-based patient risk detection, AI task prioritization, staff patient charts, and admin configuration.

- [x] `P5-01` [M] Build `RiskDetectionService` (rule engine for vitals, lab flags, overdue follow-ups)
- [x] `P5-02` [S] Build severity scoring and risk flag de-duplication
- [x] `P5-03` [S] Build rule-based clinical task generator
- [x] `P5-04` [M] Build Staff Navigation Shell & daily schedule view
- [x] `P5-05` [L] Build Staff Dashboard (Today's schedule + no-show risk badges + risk flags)
- [x] `P5-06` [M] Build Patient Search & Staff Patient List
- [x] `P5-07` [L] Build Clinical Patient Chart View (Timeline, AI summary, vitals, lab histories)
- [x] `P5-08` [M] Build Clinical Note Entry form (creates `medical_records` row)
- [x] `P5-09` [M] Build Prescription & Lab Order entry forms
- [x] `P5-10` [M] Implement AI Task Prioritization (`prioritizeTasks` blending LLM rationale with rule scores)
- [x] `P5-11` [M] Build Prioritized Task Board UI (with explainable AI rationale per task)
- [x] `P5-12` [S] Build Staff Doctor Schedule Management screen
- [x] `P5-13` [M] Build Panel Analytics Dashboard (No-show rates, slot utilization using `fl_chart`)
- [x] `P5-14` [M] Build Admin User Management (Create staff, reset passwords, assign departments)
- [x] `P5-15` [M] Build Admin Department & Schedule Template Editor
- [x] `P5-16` [M] Build Admin AI Settings (API key entry, model selection, mock toggle, seed reset)
- [x] `P5-17` [M] Build System Audit Log Viewer screen

---

### Part 6: Testing, Metrics & Usability Validation (Phase 6)
> **Goal:** Collect empirical performance, accuracy, and usability metrics for final thesis chapters.

- [x] `P6-01` [M] Write unit tests for `NoShowPredictor`, `FeatureExtractor`, and risk rules
- [x] `P6-02` [M] Write unit tests for repositories against in-memory Drift SQLite DB
- [x] `P6-03` [M] Write unit tests for AI JSON response parsing and fallback handling
- [x] `P6-04` [M] Write widget tests for core screens (Patient Timeline, Staff Dashboard)
- [x] `P6-05` [M] Write integration test (Seed → Patient Login → Book Appointment → Staff View)
- [x] `P6-06` [M] ⚠️ **Cross-Platform Smoke Test:** Run full demo path on Windows, Android, Chrome
- [x] `P6-07` [L] Conduct Usability Study (5–8 participants, SUS questionnaire, task success rates)
- [x] `P6-08` [M] Measure system performance metrics (Timeline load speed, memory footprint, cold start)
- [x] `P6-09` [M] Accessibility Audit (Color contrast ratios, touch targets, screen reader labels)

---

### Part 7: Report Documentation & Presentation (Phase 7)
> **Goal:** Assemble senior project thesis, system diagrams, demo script, and final defense presentation deck.

- [x] `P7-01` [M] Generate final system diagrams in `docs/` (Architecture, Use-Case, Sequence diagrams)
- [x] `P7-02` [M] Capture comprehensive application screenshot suite (Light & Dark modes, all roles)
- [x] `P7-03` [L] Write Thesis Results Chapter (ML metrics table, baseline comparison, SUS scores)
- [x] `P7-04` [M] ⚠️ **Defense Demo Script:** Rehearse exact click-path in offline airplane mode
- [x] `P7-05` [L] Build Final Presentation Deck & conduct defense rehearsal

---

## 👥 Suggested Two-Developer Work Split

| Milestone Phase | Developer Track A (Ali) | Developer Track B (Mohammed) |
| --- | --- | --- |
| **Phase 0 & 1** | Flutter Scaffold & Theme Setup | Database Schema, DAOs & Seeder |
| **Phase 2 & 4 (ML)** | Patient UI, Timeline & PDF Import | Python ML Pipeline (`P4-01` to `P4-07`) |
| **Phase 3 & 4 (Booking)** | Dart `NoShowPredictor` & Booking Flow | AI Summarization Layer (`AiService` & Claude) |
| **Phase 5** | Staff Shell & Patient Chart | Risk Detection Rules & Staff Task Board |
| **Phase 6 & 7** | Automated Tests & Performance Metrics | Usability SUS Study & Final Thesis Report |

---

## 🔒 Crucial Rules & Hard Gates

1. **P0-11 Web Gate:** Do not start Phase 1 until Web SQLite WASM is confirmed working (or officially marked as deferred).
2. **P3-03 Mock First:** Always complete `MockAiService` before `ClaudeAiService` so UI development is never blocked by an API key.
3. **P4-11 ML Parity Test:** Never attach the booking UI until Dart inference matches Python within `1e-6`.
4. **Offline AirPlane Mode Defense:** Rehearse the entire final presentation with internet disabled to guarantee zero defense failures.
