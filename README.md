# MyHealth AI 🏥

> **University of Bahrain — Senior Project (Semester 2, 2025/2026)**  
> **Authors:** Ali Mohamed Jaafar Mohamed (202208244) & Mohammed A.Redha Meftah (202209027)  
> **Supervisor:** Dr. Amal Ghanim

An offline-first, multi-platform healthcare management and clinical triage application powered by local Drift (SQLite) storage, a pure-Dart machine learning no-show predictor, and an Anthropic Claude LLM summarization pipeline (with an offline `MockAiService` fallback).

---

## 📱 Supported Platforms

- **Windows Desktop:** Primary fast iteration & local demo environment (`sqlite3_flutter_libs` FFI).
- **Android:** Mobile emulator & physical device target with full notification support.
- **Web:** Chrome browser target using WebAssembly (`sqlite3.wasm`) with OPFS / IndexedDB storage.
- **iOS:** Configured for Apple devices (buildable on macOS).

---

## 🚀 Quick Start

### 1. Prerequisites
Ensure you have the following installed:
- Flutter SDK (v3.44.4+ / Dart 3.12.2+)
- Python (v3.11+ / v3.14+ for ML training scripts in `tools/ml/`)
- Git

### 2. Install Dependencies
```bash
flutter pub get
```

### 3. Generate Database & Model Code
```bash
dart run build_runner build --delete-conflicting-outputs
```

### 4. Run the Application

#### On Windows Desktop:
```bash
flutter run -d windows
```

#### On Android Emulator:
```bash
flutter run -d android
```

#### On Chrome (Web):
```bash
flutter run -d chrome
```

---

## 🔑 AI Key Configuration

MyHealth AI operates with a **dual AI architecture**:
1. **Mock Mode (Default):** The app works completely offline with zero API key. Deterministic clinical summaries and slot rankings are produced automatically, ensuring a 100% resilient defense demo.
2. **Live Claude Mode:**
   - Log in with the **Admin** role (`admin@myhealth.uob`).
   - Navigate to **Admin Settings → AI Configuration**.
   - Paste your Anthropic API Key (`sk-ant-...`).
   - The key is securely stored in `flutter_secure_storage` (never logged, never committed to VCS).

---

## 🗄️ Synthetic Seed Data & Reset

The app includes an idempotent synthetic data seeder generating:
- 60 Patients with correlated medical conditions and histories
- 12 Healthcare Staff across 5 Departments
- 2 Years of past appointments with realistic no-show distributions
- Vitals, Lab records, and Medication histories

To reset demo data at any time:
1. Navigate to **Admin → AI & Data Settings**.
2. Click **Re-Seed Demo Data**.

---

## 📂 Project Architecture

```
lib/
├── app/
│   ├── app.dart              # MaterialApp.router root
│   ├── router.dart           # Role-gated GoRouter shells (Patient, Staff, Admin)
│   └── theme/                # Clinical Teal palette, Outfit typography, Spacing tokens
├── core/
│   ├── result.dart           # Sealed Result<T, Failure> functional pattern
│   ├── failures.dart         # Standardized AppFailure hierarchy
│   ├── di.dart               # Riverpod provider dependency injection registry
│   └── utils/                # Date and clinical formatting helpers
├── domain/
│   ├── entities/             # Freezed domain entity models
│   └── repositories/         # Abstract repository interfaces (pure domain)
├── data/
│   ├── db/                   # Drift SQLite schema, migrations & DAOs
│   │   └── connection/       # Cross-platform connection (Native FFI + Web WASM)
│   ├── repositories/         # Concrete repository implementations
│   └── seed/                 # Correlated synthetic dataset generator
├── features/                 # Feature-first UI screens & controllers
│   ├── auth/                 # Login & Registration
│   ├── patient_home/         # Patient dashboard & health summary card
│   ├── timeline/             # Chronological Health Timeline + AI event markers
│   ├── records/              # Medical record details & PDF text extractor
│   ├── vitals/               # Vitals logging & fl_chart trend visualizations
│   ├── booking/              # ML-ranked smart appointment booking wizard
│   ├── staff_dashboard/      # Daily schedule + no-show badges + risk flags
│   ├── patient_chart/        # Staff patient chart & note creation
│   ├── tasks/                # AI-prioritized staff task board
│   └── admin/                # User management, department templates, AI settings
└── services/
    ├── ai/                   # AiService interface, MockAiService & ClaudeAiService
    ├── ml/                   # Pure-Dart NoShowPredictor & FeatureExtractor
    ├── notifications/        # Risk-adaptive local notifications & web banners
    └── ingestion/            # PDF report text extraction
```
