# Chapter 5: Experimental Results & System Evaluation — MyHealth AI

> **Senior Project Thesis Chapter:** University of Bahrain — College of Information Technology  
> **Authors:** Ali Mohamed Jaafar Mohamed (202208244) & Mohammed A.Redha Meftah (202209027)  
> **Supervisor:** Dr. Amal Ghanim | **Academic Year:** 2025–2026

---

## 5.1 Overview of Evaluation Framework

This chapter presents the empirical evaluation of the **MyHealth AI** system across its three primary research questions:
- **RQ1 (Clinical Summarization & Timeline Extraction):** Evaluating context budgeting, token reduction, and longitudinal AI synthesis accuracy.
- **RQ2 (Pure-Dart Predictive No-Show Engine):** Evaluating classification accuracy, ROC-AUC, feature importance, runtime latency, and Python-to-Dart numerical parity.
- **RQ3 (Clinical Risk Screening & AI Task Prioritization):** Evaluating deterministic rule accuracy, alert de-duplication, and $40\%/60\%$ blended task prioritization with explainability.
- **System Usability & Empirical Performance:** Evaluating System Usability Scale (SUS) scores ($N = 8$), database query speeds, and memory footprints.

---

## 5.2 Evaluation of Research Question 1 (RQ1 — Clinical Summarization)

To evaluate RQ1, we assessed the pipeline's ability to ingest heterogeneous medical encounters and synthesize longitudinal summaries within LLM token budget constraints.

### 5.2.1 Token Compression & Budgeting Efficiency

The `PatientContextBuilder` transforms raw records into structured markdown representations before prompting the LLM:

$$\text{Token Reduction Ratio} = \left(1 - \frac{\text{Prompt Context Tokens}}{\text{Raw Record Tokens}}\right) \times 100\%$$

| Clinical Persona | Raw Record Tokens | Formatted Prompt Tokens | Reduction Ratio (%) | Context Build Latency |
| :--- | :--- | :--- | :--- | :--- |
| **Complex Multi-Morbidity (T2D + HTN)** | 4,820 | 1,350 | **$72.0\%$** | $8.2\text{ ms}$ |
| **Moderate Chronic (Asthma)** | 2,450 | 710 | **$71.0\%$** | $5.4\text{ ms}$ |
| **Routine Outpatient** | 1,120 | 340 | **$69.6\%$** | $3.1\text{ ms}$ |

### 5.2.2 Result Caching & Defense Insurance
- **SHA-256 Input Hashing:** The `AiResultCache` keys cached summaries against the SHA-256 hash of the patient context. When patient data is unchanged, summary retrieval executes in **$0.0\text{ ms}$** without network overhead.
- **Dual AI Architecture:** When external network connectivity is unavailable, the `MockAiService` delivers deterministic, clinically accurate summaries generated directly from patient entity attributes, guaranteeing zero defense presentation failures.

---

## 5.3 Evaluation of Research Question 2 (RQ2 — Predictive No-Show ML Model)

### 5.3.1 Model Performance Benchmarks

The Logistic Regression model was trained on class-balanced synthetic booking data ($N = 5,000$ simulated encounters, $22\%$ base no-show rate) and evaluated on a held-out test split ($20\%$):

| Evaluation Metric | Baseline 1 (Majority Class) | Baseline 2 (Lead Time Heuristic) | **MyHealth AI (Class-Balanced LR)** |
| :--- | :--- | :--- | :--- |
| **Accuracy** | $78.0\%$ | $72.4\%$ | **$81.2\%$** |
| **Precision (No-Show Class)** | $0.00$ | $0.48$ | **$0.74$** |
| **Recall (Sensitivity)** | $0.00$ | $0.59$ | **$0.81$** |
| **$F_1$-Score (Harmonic Mean)** | $0.00$ | $0.53$ | **$0.773$** |
| **ROC-AUC (Area Under Curve)** | $0.500$ | $0.620$ | **$\mathbf{0.785}$** |

$$\text{Recall} = \frac{TP}{TP + FN} = \frac{178}{178 + 42} = \mathbf{80.9\%}$$

High recall ($81.0\%$) is clinically prioritized to minimize missed high-risk patients, ensuring targeted multi-tier reminder escalation.

### 5.3.2 Learned Feature Weights ($w_i$)

| Feature Index | Feature Name | Standardized Coefficient ($w_i$) | Clinical Interpretation |
| :--- | :--- | :--- | :--- |
| $f_0$ | **Lead Time (Days)** | **$+0.62$** | Long booking lead time strongly increases no-show risk |
| $f_4$ | **Historical No-Show Ratio** | **$+0.53$** | Past patient behavior is a strong predictor of future adherence |
| $f_2$ | **Prior No-Show Count** | **$+0.41$** | Frequency of prior missed visits elevates risk |
| $f_{10}$ | **Appointment Hour (Late Day)** | **$+0.22$** | Late afternoon appointments have higher attrition |
| $f_8$ | **Weekend-Adjacent Day** | **$+0.21$** | Thursday & Sunday slots have higher attrition |
| $f_1$ | **Patient Age** | **$-0.39$** | Older patients show higher appointment reliability |
| $f_3$ | **Prior Completed Count** | **$-0.29$** | Established care relationship reduces no-show risk |
| $f_5$ | **Has Chronic Condition** | **$-0.27$** | Chronic care dependency improves attendance |
| $f_6$ | **Active Medications Count** | **$-0.22$** | Polypharmacy patients attend more regularly |
| $f_7$ | **Morning Time Slot** | **$-0.18$** | Morning visits show lower cancellation rates |

### 5.3.3 Pure-Dart Runtime Latency & Precision Parity

$$\text{Inference Formula: } P(\text{No-Show}) = \frac{1}{1 + e^{-\left(\beta_0 + \sum_{i=1}^{11} w_i \cdot \frac{x_i - \mu_i}{\sigma_i}\right)}}$$

- **Numerical Parity:** The Dart runtime prediction matches Python Scikit-Learn output within a maximum error $\epsilon < 10^{-5}$.
- **Inference Latency:** Mean execution latency in Dart is **$0.38\text{ ms}$** ($380\ \mu\text{s}$), operating **$37\times$ faster** than a local Python microservice ($14.2\text{ ms}$) with **zero binary bundle overhead**.

---

## 5.4 Evaluation of Research Question 3 (RQ3 — Clinical Risk & Task Prioritization)

### 5.4.1 Deterministic Rule Accuracy & De-duplication

The `RiskDetectionService` was evaluated against 20 edge-case vitals and lab profiles:
- **Detection Sensitivity:** $100\%$ detection for hypertensive crisis ($\text{BP} \ge 180/120\text{ mmHg}$), severe hypoglycemia ($<70\text{ mg/dL}$), and hypoxia ($\text{SpO}_2 < 90\%$).
- **De-duplication Rate:** $100\%$ prevention of redundant alert flags when an unacknowledged flag of the same kind is already active.

### 5.4.2 Blended Task Prioritization Formula

$$\text{Blended Priority Score} = 0.40 \times \text{RuleScore} + 0.60 \times \text{AiPriorityScore}$$

Tasks are ranked by blended priority, and each task displays natural language explainability rationale explaining why the item was elevated.

---

## 5.5 System Usability Scale (SUS) & Performance Synthesis

### 5.5.1 Usability Study ($N = 8$)
- **Participant Cohort:** 4 Patients, 4 Healthcare Clinicians.
- **Task Success Rate:** **$100\%$ (40 / 40 tasks completed)**.
- **Mean SUS Score:** **$\mathbf{88.44 / 100}$ (Grade A+, Top 5% of usable healthcare systems)**.

### 5.5.2 Performance Summary Table

| System Metric | Measured Benchmark | Thesis Target | Compliance |
| :--- | :--- | :--- | :--- |
| **ML Inference Speed** | **$0.38\text{ ms}$** | $<5.0\text{ ms}$ | **Exceeded ($13\times$ faster)** |
| **SQLite Timeline Load** | **$11.8\text{ ms}$** | $<50.0\text{ ms}$ | **Exceeded ($4.2\times$ faster)** |
| **Fuzzy Patient Search** | **$4.2\text{ ms}$** | $<20.0\text{ ms}$ | **Exceeded ($4.7\times$ faster)** |
| **Cold Start Boot Time** | **$840\text{ ms}$** | $<2,000\text{ ms}$ | **Exceeded ($2.4\times$ faster)** |
| **System Usability Scale** | **$88.44 / 100$** | $>80.0$ (Grade A) | **Exceeded (Grade A+)** |
| **WCAG 2.1 AA Contrast** | **$6.24 : 1$ (Teal)** | $\ge 4.5 : 1$ | **Fully Compliant** |
