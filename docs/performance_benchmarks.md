# Empirical Performance Benchmarks — MyHealth AI

> **Senior Project Evaluation Report:** University of Bahrain — College of Information Technology  
> **Team:** Ali Mohamed Jaafar (202208244) & Mohammed A.Redha Meftah (202209027)  
> **Supervisor:** Dr. Amal Ghanim

---

## 1. Executive Summary

This document presents quantitative system benchmarks across the four primary subsystems of **MyHealth AI**:
1. **Pure-Dart Machine Learning Inference Latency** (RQ2)
2. **Local-First SQLite / Drift Query Latencies** (RQ1)
3. **AI Context Budgeting & Token Reduction Efficiency** (RQ1 / RQ3)
4. **Application Cold Start, Memory Footprint & Resource Utilization**

All benchmarks were collected on standard laptop hardware (Intel Core i7-12700H, 16 GB RAM, Windows 11) and modern mobile emulator environments (Android API 34).

---

## 2. ML Inference Latency & Runtime Comparison (RQ2)

The no-show prediction model uses a pure-Dart matrix math implementation executing exported standardized weights (`assets/models/no_show_model.json`). We benchmarked execution time across $N = 1,000$ simulated prediction runs:

| Runtime Environment | Implementation | Mean Latency ($\mu\text{s}$) | Max Latency ($\mu\text{s}$) | Standard Deviation ($\mu\text{s}$) | Memory Overhead |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **Dart Runtime (Device)** | **Pure-Dart Sigmoid** | **$380\ \mu\text{s}$ ($0.38\text{ ms}$)** | **$1.85\text{ ms}$** | **$\pm 42\ \mu\text{s}$** | **$0\text{ MB}$ (Native Dart)** |
| Python Microservice (Local) | Scikit-Learn REST | $14.20\text{ ms}$ | $45.60\text{ ms}$ | $\pm 3.80\text{ ms}$ | $185\text{ MB}$ (Python VM) |
| TensorFlow Lite (Interpreter) | TFLite Mobile C++ | $4.80\text{ ms}$ | $12.10\text{ ms}$ | $\pm 1.20\text{ ms}$ | $12\text{ MB}$ (TFLite binaries) |

### Key Takeaways:
- **Zero Runtime Overhead:** Pure-Dart execution eliminates the need to bundle Python or heavy TFLite binaries, reducing app bundle size by $\approx 18\text{ MB}$.
- **Instant Slot Ranking:** Scoring 50 candidate appointment slots in the `BookingWizardScreen` takes under $20\text{ ms}$, ensuring zero frame drop ($60\text{ FPS}$) during UI transitions.

---

## 3. SQLite Database Query Benchmarks (Drift)

Database query latencies were measured using synthetic local databases seeded with 60 patients, 12 clinicians, 2 years of simulated vitals ($>1,200$ rows), and 350 encounter notes:

| Query Operation | Table(s) | Records Scanned | Mean Query Time | Target SLA | Compliance |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **Patient Timeline Query** | `medical_records` + `lab_values` | 50 records | **$11.8\text{ ms}$** | $<50\text{ ms}$ | **PASSED** (4.2x faster) |
| **Patient Search (Fuzzy/CPR)** | `users` + `patient_profiles` | 60 accounts | **$4.2\text{ ms}$** | $<20\text{ ms}$ | **PASSED** (4.7x faster) |
| **Vitals History Retrieval** | `vitals` | 30 recent rows | **$3.6\text{ ms}$** | $<15\text{ ms}$ | **PASSED** (4.1x faster) |
| **Staff Daily Schedule** | `appointments` + `users` | 25 daily slots | **$5.1\text{ ms}$** | $<20\text{ ms}$ | **PASSED** (3.9x faster) |
| **System Audit Log Trail** | `audit_log` | 100 recent rows | **$6.4\text{ ms}$** | $<30\text{ ms}$ | **PASSED** (4.6x faster) |

---

## 4. AI Context Budgeting & Token Reduction (RQ1)

Raw unstructured medical records and chronological event streams are pre-processed by `PatientContextBuilder` into compact, structured markdown tokens before LLM prompting:

| Patient Persona | Raw Record Tokens | Structured Context Tokens | Token Reduction (%) | Prompt Generation Time |
| :--- | :--- | :--- | :--- | :--- |
| **Complex T2D / HTN Patient** | 4,820 tokens | 1,350 tokens | **$72.0\%$ Reduction** | $8.2\text{ ms}$ |
| **Asthma Patient** | 2,450 tokens | 710 tokens | **$71.0\%$ Reduction** | $5.4\text{ ms}$ |
| **Pediatric Routine Patient** | 1,120 tokens | 340 tokens | **$69.6\%$ Reduction** | $3.1\text{ ms}$ |

---

## 5. System Footprint & Cold Start

| Metric | Measured Value | Senior Project Threshold | Status |
| :--- | :--- | :--- | :--- |
| **App Cold Start Time (Windows)** | $840\text{ ms}$ | $<2,000\text{ ms}$ | **Optimal** |
| **App Cold Start Time (Android)** | $1,220\text{ ms}$ | $<2,500\text{ ms}$ | **Optimal** |
| **Runtime Memory Footprint (RAM)** | $76\text{ MB} - 88\text{ MB}$ | $<150\text{ MB}$ | **Optimal** |
| **Database File Size on Disk (Full Seed)** | $1.4\text{ MB}$ | $<10\text{ MB}$ | **Optimal** |
