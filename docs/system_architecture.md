# System Architecture & UML Design Specifications — MyHealth AI

> **Senior Project Technical Documentation:** University of Bahrain — College of Information Technology  
> **Team:** Ali Mohamed Jaafar (202208244) & Mohammed A.Redha Meftah (202209027)  
> **Supervisor:** Dr. Amal Ghanim

---

## 1. System Architecture Overview

**MyHealth AI** is engineered as a high-performance, local-first medical intelligence platform. The architecture eliminates external server/cloud database dependencies by embedding a high-speed SQLite database on-device using Drift (with WebAssembly/OPFS support on the web) and executing a pure-Dart Machine Learning engine for sub-millisecond inference.

```mermaid
flowchart TD
    subgraph Presentation Layer [Presentation Layer (Flutter 3.44 / Riverpod)]
        PatientUI[Patient Shell & Timeline]
        StaffUI[Staff Shell & Patient Charts]
        AdminUI[Admin Console & Audit Trail]
        SharedUI[Design Tokens, DoubleBezelCard, ClinicalBadge]
    end

    subgraph State & Controller Layer [State & Business Logic Layer]
        AuthController[AuthController]
        NavState[Navigation Providers]
        TimelineState[Timeline & Record Streams]
        TaskState[Staff Task Providers]
    end

    subgraph Domain & Service Layer [Pure Domain & Service Layer (Pure Dart)]
        AuthRepo[Auth Repository Interface]
        RecordRepo[Record Repository Interface]
        SchedService[SchedulingService (RQ2)]
        MLPredictor[NoShowPredictor (Pure-Dart ML)]
        FeatureExtract[FeatureExtractor (11 Features)]
        RiskService[RiskDetectionService (RQ3)]
        TaskPrioritize[TaskPrioritizationService (RQ3)]
        ContextBuilder[PatientContextBuilder (RQ1)]
        AiCache[AiResultCache Proxy]
    end

    subgraph Dual AI Layer [Dual AI Infrastructure (RQ1 / RQ3)]
        MockAI[MockAiService (Offline Defense Insurance)]
        ClaudeAI[ClaudeAiService (Anthropic Messages API)]
    end

    subgraph Data & Storage Layer [Local-First Data Layer (Drift / SQLite)]
        AppDB[(AppDatabase SQLite)]
        UserDao[UserDao]
        RecordDao[RecordDao]
        AppointmentDao[AppointmentDao]
        TaskDao[TaskDao]
        SystemDao[SystemDao]
    end

    Presentation Layer --> State & Controller Layer
    State & Controller Layer --> Domain & Service Layer
    Domain & Service Layer --> Dual AI Layer
    Domain & Service Layer --> Data & Storage Layer
```

---

## 2. Comprehensive System Use-Case Diagram

```mermaid
flowchart LR
    subgraph Actors
        Patient((Patient))
        Clinician((Healthcare Staff))
        Admin((System Admin))
    end

    subgraph Patient Use Cases
        UC1[View Unified Health Timeline]
        UC2[Import Medical PDF Records]
        UC3[Read AI Longitudinal Summary]
        UC4[Book Appointment with AI Optimal Slots]
        UC5[Log Daily Vitals & View Trajectories]
        UC6[Manage & Reschedule Appointments]
    end

    subgraph Clinician Use Cases
        UC7[View Daily Clinic Schedule & ML Risk Badges]
        UC8[Review AI Prioritized Task Board]
        UC9[Inspect 5-Tab Clinical Patient Chart]
        UC10[Document SOAP Encounter Notes & Lab Orders]
        UC11[Prescribe Formulary Medications]
        UC12[Acknowledge Clinical Risk Alerts]
        UC13[View Department Analytics]
    end

    subgraph Administrator Use Cases
        UC14[Manage Staff Accounts & Departments]
        UC15[Configure AI Provider & Model Selection]
        UC16[Re-Seed Database with 60 Patients]
        UC17[Inspect Security Audit Log Trail]
    end

    Patient --> UC1
    Patient --> UC2
    Patient --> UC3
    Patient --> UC4
    Patient --> UC5
    Patient --> UC6

    Clinician --> UC7
    Clinician --> UC8
    Clinician --> UC9
    Clinician --> UC10
    Clinician --> UC11
    Clinician --> UC12
    Clinician --> UC13

    Admin --> UC14
    Admin --> UC15
    Admin --> UC16
    Admin --> UC17
```

---

## 3. Core Sequence Diagrams

### Sequence 1: Patient PDF Record Ingestion & Chronological Extraction (RQ1)

```mermaid
sequenceDiagram
    autonumber
    actor Patient
    participant UI as ImportRecordModal
    participant Repo as RecordRepository
    participant DAO as RecordDao
    participant DB as SQLite AppDatabase
    participant Audit as AdminRepository

    Patient->>UI: Selects and imports PDF health record
    UI->>UI: Extracts raw text and metadata
    UI->>Repo: importPdfRecord(patientId, title, path, text, date, facility)
    Repo->>DAO: insertRecord(MedicalRecordsCompanion)
    DAO->>DB: INSERT INTO medical_records
    DB-->>DAO: recordId: 402
    Repo->>Audit: logAudit("IMPORT_PDF", "MedicalRecord", 402)
    Audit->>DB: INSERT INTO audit_log
    Repo-->>UI: Success(MedicalRecord)
    UI-->>Patient: Refreshes Timeline with new record milestone
```

---

### Sequence 2: AI Summarization Context Budgeting & SQLite Caching (RQ1)

```mermaid
sequenceDiagram
    autonumber
    actor Patient
    participant Card as AiSummaryCard
    participant Cache as AiResultCache
    participant Builder as PatientContextBuilder
    participant AI as AiService (Mock / Claude)
    participant DB as SQLite AppDatabase

    Patient->>Card: Opens Home Screen
    Card->>Cache: getSummary(patientId)
    Cache->>Builder: buildContext(patientId)
    Builder->>DB: Fetches active conditions, vitals, meds, notes
    DB-->>Builder: Raw clinical records
    Builder->>Builder: Formats markdown context & computes inputHash (SHA-256)
    Builder-->>Cache: PatientContext(markdown, inputHash)
    Cache->>DB: SELECT FROM ai_summaries WHERE input_hash = inputHash
    alt Cache Hit (Pre-computed summary exists)
        DB-->>Cache: Cached AiHealthSummary
        Cache-->>Card: Return cached summary (0ms latency)
    else Cache Miss (New data recorded)
        Cache->>AI: generateSummary(markdown)
        AI-->>Cache: AiHealthSummary JSON (Key Events, Trends, Red Flags)
        Cache->>DB: INSERT INTO ai_summaries
        Cache-->>Card: Return fresh AI summary
    end
    Card-->>Patient: Displays summary, trends, and safety banner
```

---

### Sequence 3: ML No-Show Prediction & Escalating Reminder Scheduling (RQ2)

```mermaid
sequenceDiagram
    autonumber
    actor Patient
    participant Wizard as BookingWizardScreen
    participant Sched as SchedulingService
    participant Feat as FeatureExtractor
    participant ML as NoShowPredictor (Pure-Dart)
    participant ApptRepo as AppointmentRepository
    participant Notifier as PlatformNotifier
    participant DB as SQLite AppDatabase

    Patient->>Wizard: Selects Department & Doctor
    Wizard->>Sched: getScoredSlots(patient, doctorId, dateRange)
    Sched->>DB: Fetches doctor schedule templates & booked slots
    DB-->>Sched: 40 candidate open slots
    loop For each candidate slot
        Sched->>Feat: extract(patient, slotStart, priorNoShows, meds, lastVisit)
        Feat-->>Sched: 11-element feature vector x
        Sched->>ML: predict(x)
        ML->>ML: Standardize (x - mean)/std -> z = w*x + b -> Sigmoid P
        ML-->>Sched: NoShowPrediction(prob, riskBand, contributions)
    end
    Sched->>Sched: Sort slots by lowest probability (Low Risk at top)
    Sched-->>Wizard: List<ScoredSlot> (Ranked)
    Patient->>Wizard: Selects slot & confirms booking
    Wizard->>ApptRepo: bookAppointment(patientId, doctorId, slot, prob, riskBand)
    ApptRepo->>DB: INSERT INTO appointments (no_show_risk, risk_band)
    DB-->>ApptRepo: appointmentId: 501
    Wizard->>Sched: generateReminders(slotStart, riskBand, appointmentId)
    Sched->>Notifier: Schedule 1, 2, or 3 escalating reminders
    Wizard-->>Patient: Booking confirmed with risk badge
```

---

### Sequence 4: Acute Vitals Threshold Breach $\rightarrow$ Alert De-duplication $\rightarrow$ AI Task Prioritization (RQ3)

```mermaid
sequenceDiagram
    autonumber
    actor Patient
    actor Clinician
    participant VitalsModal as LogVitalsModal
    participant RiskService as RiskDetectionService
    participant PrioritizeService as TaskPrioritizationService
    participant TaskBoard as TaskBoardScreen
    participant DB as SQLite AppDatabase

    Patient->>VitalsModal: Logs acute BP (185/115 mmHg)
    VitalsModal->>DB: INSERT INTO vitals
    VitalsModal->>RiskService: scanVitals(patientId, vitals)
    RiskService->>RiskService: Checks clinical rules: Sys >= 180 -> Hypertensive Crisis (Critical)
    RiskService->>DB: Checks active unacknowledged flags (De-duplication)
    alt Flag not already active
        RiskService->>DB: INSERT INTO risk_flags (kind, severity: Critical, rationale)
        RiskService->>DB: INSERT INTO staff_tasks (title, kind: reviewAbnormalLab, ruleScore: 0.95)
    end

    Clinician->>TaskBoard: Opens Clinical Task Board
    TaskBoard->>PrioritizeService: prioritizeTasks(tasks)
    loop For each task
        PrioritizeService->>PrioritizeService: Calculate AI Score (0.96) & Explainable Rationale
        PrioritizeService->>PrioritizeService: Blended Priority = (0.95 * 0.4) + (0.96 * 0.6) = 0.956
        PrioritizeService->>DB: UPDATE staff_tasks (ai_score, ai_rationale)
    end
    TaskBoard-->>Clinician: Renders #1 Urgent Task with explainability chip
```
