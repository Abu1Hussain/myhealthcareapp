# MyHealth AI — Local Setup & Execution Guide 💻

This guide walks you through setting up and running **MyHealth AI** locally on your laptop.

---

## 📋 1. Prerequisites

Before running the app, ensure the following tools are installed and configured:

1. **Flutter SDK (v3.24+ / v3.47+)**:
   - Download for Windows: https://docs.flutter.dev/get-started/install/windows/mobile
   - Extract the downloaded zip to C:\flutter
   - Add Flutter to your User Path permanently via PowerShell:
     [System.Environment]::SetEnvironmentVariable("Path", [System.Environment]::GetEnvironmentVariable("Path", "User") + ";C:\flutter\bin", "User")
   - Close and reopen PowerShell, then verify:
     flutter doctor

2. **Platform Requirements**:
   - **System Developer Mode (Required for plugin symlinks):** Open settings via PowerShell (start ms-settings:developers) and toggle Developer Mode to ON.
   - **For Web (Fastest):** Google Chrome browser.
   - **For Windows Desktop:** Visual Studio Community with "Desktop development with C++" workload.
   - **For Android:** Android Studio with an Android Emulator or physical phone with USB debugging.
   - **For ML Training scripts:** Python 3.11+ (python --version).

---

## 🚀 2. Step-by-Step Setup Commands

Open your terminal (PowerShell or Command Prompt) and navigate to the project directory:

cd C:\Users\iamxj\OneDrive\Desktop\sen

### Step A: Update & Fetch Packages

flutter pub upgrade
flutter clean
flutter pub get

### Step B: Generate Drift Database & Model Code

dart run build_runner build --delete-conflicting-outputs

---

## 📱 3. Running the App

Choose your preferred target platform:

### Option A: Google Chrome (Web - Recommended)

Runs in your browser using WebAssembly.
flutter run -d chrome

### Option B: Windows Desktop

Fast native SQLite performance (requires Visual Studio C++ workload).
flutter run -d windows

### Option C: Android Phone or Emulator

flutter run -d android

---

## 🔑 4. Demo Login Credentials

The application is pre-seeded with 60 patients, 12 doctors, and 1 admin:

| Role    | Name                    | Email                          | Password    | Clinical Profile / Notes                   |
| :------ | :---------------------- | :----------------------------- | :---------- | :----------------------------------------- |
| Admin   | System Admin            | admin@myhealth.uob             | Admin123!   | Full admin access, audit logs, AI settings |
| Patient | Ali Mohamed Jaafar      | ali.jaafar@student.uob.bh      | Patient123! | Bronchial Asthma profile & timeline        |
| Patient | Mohammed A.Redha Meftah | mohammed.meftah@student.uob.bh | Patient123! | Type 2 Diabetes + Hypertension             |
| Patient | Fatima Ebrahim Al-Alawi | fatima.alawi@demo.bh           | Patient123! | Hyperlipidemia & Hypothyroidism            |
| Doctor  | Dr. Amal Ghanim         | amal.ghanim@myhealth.uob       | Doctor123!  | Consultant Internal Medicine               |
| Doctor  | Dr. Reem Buallay        | reem.buallay@myhealth.uob      | Doctor123!  | Head of Cardiology                         |
| Doctor  | Dr. Fatima Al-Hasan     | fatima.alhasan@myhealth.uob    | Doctor123!  | Head of Endocrinology                      |

---

## 🛠️ 5. Common Troubleshooting

### 'flutter' or 'dart' is Not Recognized

If terminal returns CommandNotFoundException, run this to permanently add Flutter to PATH, then restart PowerShell:
[System.Environment]::SetEnvironmentVariable("Path", [System.Environment]::GetEnvironmentVariable("Path", "User") + ";C:\flutter\bin", "User")

Or set it temporarily for the active session only:
$env:Path += ";C:\flutter\bin"

### Build Runner AST / Analyzer Errors

If build_runner fails with visitDotShorthandPropertyAccess or analyzer package version warnings:
flutter pub upgrade
dart run build_runner build --delete-conflicting-outputs

### Theme Compilation Errors (BoxShadow, Color, Offset missing)

Ensure Material/Cupertino packages are imported at the top of theme files (lib/app/theme/app_spacing.dart and lib/app/theme/app_theme.dart):
library;

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

_(Note: If library; directive is present, it must strictly be placed on Line 1 before all import directives)._

### PowerShell Script Execution Disabled

If PowerShell blocks scripts, run with execution policy bypass:
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass

### Reset Demo Data

To re-seed fresh demo data:

1. Log in as Admin (admin@myhealth.uob).
2. Go to AI & Data Settings.
3. Click "Re-Seed Demo Data".
