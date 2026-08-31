# Senior Project Defense & Live Demo Script — MyHealth AI

> **Presentation & Demonstration Guide:** University of Bahrain — College of Information Technology  
> **Presenters:** Ali Mohamed Jaafar (202208244) & Mohammed A.Redha Meftah (202209027)  
> **Supervisor:** Dr. Amal Ghanim | **Target Duration:** 10 Minutes + 5 Min Q&A

---

## 🎯 Demo Preparation Checklist (Before Entering Examination Room)

- [ ] **Airplane Mode Enabled:** Turn off Wi-Fi / disconnect Ethernet on the demo laptop.
- [ ] **Launch Application:** Run `flutter run -d windows` (or launch Windows `.exe` build).
- [ ] **Verify Seed State:** Ensure the app displays the Login Screen with the quick-switch user button visible in dialogs.

---

## ⏱️ Minute-by-Minute Live Defense Script

### Act 1: Introduction & Problem Statement (0:00 – 2:00) — *Presenter: Ali*

**Speaking Points:**
- *"Good morning honorable committee members and Dr. Amal Ghanim. Today, Mohammed and I are proud to present **MyHealth AI** — an offline-first, local healthcare intelligence platform."*
- *"In modern clinical practice, health data is fragmented across disconnected PDF reports, clinics face a $22\%$ no-show rate wasting critical consultation capacity, and clinicians suffer from alert fatigue and manual paperwork."*
- *"We formulated three core research questions to solve these challenges:"*
  1. **RQ1:** Can an on-device chronological timeline with context-budgeted AI synthesize longitudinal records?
  2. **RQ2:** Can a pure-Dart offline ML model predict no-shows in $<1\text{ ms}$ and optimize appointment scheduling?
  3. **RQ3:** Can automated risk detection and $40\%/60\%$ blended AI task prioritization reduce clinician burnout?
- *"Let us demonstrate how MyHealth AI solves all three pillars entirely offline."*

---

### Act 2: Patient Experience & AI Synthesis (2:00 – 4:30) — *Presenter: Ali*

**Actions & Live Clicks:**
1. **Login as Patient:** Tap `Quick Switch User` $\rightarrow$ Select `Ali Mohamed Jaafar (Patient - Asthma)`.
2. **Review Patient Home:**
   - Call attention to the **`AiSummaryCard`**: *"Notice the AI longitudinal summary highlighting past milestones, blood pressure trends, and clinical red flags — generated offline in $0\text{ ms}$ with SHA-256 caching."*
   - Show the mandatory **`SafetyBanner`** providing clinical AI disclaimers and model provenance.
3. **Open Health Timeline:**
   - Tap `Timeline` tab $\rightarrow$ scroll through chronological encounter notes, lab reports, and vitals.
   - Filter by `Lab Reports` $\rightarrow$ tap a record to display structured analyte tables.
4. **Smart Predictive Booking (RQ2):**
   - Tap `Book Appt` quick action button $\rightarrow$ open **4-step Booking Wizard**.
   - Select Department (`Cardiology`) $\rightarrow$ Select Doctor (`Dr. Reem Buallay`).
   - **Step 3 (Slot Ranking):** *"Notice how candidate slots are dynamically scored using our pure-Dart ML model. The lowest risk slots are ranked at the top with `Low Risk (8%)` badges."*
   - **Step 4 (Confirmation):** Show the **Explainable AI Attribution Chips** (*"Morning slot (-8%)"*, *"Short lead time (-12%)"*) and the automated reminder schedule.
   - Tap `Confirm Booking`.

---

### Act 3: Clinician Experience & Triage (4:30 – 7:30) — *Presenter: Mohammed*

**Actions & Live Clicks:**
1. **Switch to Doctor Role:** Tap `Quick Switch User` $\rightarrow$ Select `Dr. Ahmed Al-Khalifa (Internal Med)`.
2. **Staff Daily Schedule Dashboard:**
   - *"The doctor immediately sees today's appointment queue with ML no-show risk badges (`Low Risk`, `Medium Risk`, `High Risk`)."*
   - Demonstrate quick status updates: tap `Check In` on an upcoming patient.
   - Point out the **Critical Risk Flag Ticker** at the top of the dashboard.
3. **AI-Prioritized Clinical Task Board (RQ3):**
   - Tap `Tasks` tab.
   - Tap the `Re-prioritize with AI` button.
   - *"Notice how the tasks are sorted by our $40\%$ Rule $+ 60\%$ AI blended priority score. The top task is an urgent Hypertensive Crisis alert. The AI Explainability Box provides instant medical justification without forcing the doctor to search 20 past pages."*
   - Tap `Start` $\rightarrow$ then tap `Complete`.
4. **Comprehensive Clinical Patient Chart:**
   - Tap `Patients` tab $\rightarrow$ search `Ali Jaafar` $\rightarrow$ tap patient card.
   - Walk through the 5 tabs:
     - **Overview:** Demographics and active risk flags with one-click `Acknowledge`.
     - **AI Summary:** Longitudinal synthesis.
     - **Vitals & Labs:** Interactive `fl_chart` blood pressure trajectory curve.
   - Tap `Prescribe Medication` $\rightarrow$ select formulary chip `Metformin 500mg` $\rightarrow$ tap `Prescribe`.

---

### Act 4: Administration & Dual AI Governance (7:30 – 8:45) — *Presenter: Mohammed*

**Actions & Live Clicks:**
1. **Switch to Admin:** Tap `Quick Switch User` $\rightarrow$ Select `Admin User`.
2. **AI Settings & Governance:**
   - Tap `AI Settings` tab.
   - *"Here we demonstrate our Dual AI architecture. When Mock Mode is enabled, the system runs with $100\%$ resilience offline. When disabled, it connects directly to Anthropic Claude 3.5 Sonnet."*
   - Demonstrate the one-click `Re-Seed Database` button generating 60 synthetic patient records.
3. **Security Audit Log Trail:**
   - Tap `Audit Log` tab.
   - Show immutable audit entries documenting every login, clinical note, prescription, and flag acknowledgment with actor names and timestamps.

---

### Act 5: Empirical Results & Conclusion (8:45 – 10:00) — *Both Presenters*

**Speaking Points:**
- *"In summary, our empirical evaluation proves the viability of on-device medical AI:"*
  - **RQ1:** $72\%$ AI prompt token reduction and zero-latency summary caching.
  - **RQ2:** Pure-Dart ML no-show model achieving **$\text{ROC-AUC} = 0.785$** executing in just **$0.38\text{ ms}$** ($37\times$ faster than Python).
  - **RQ3:** $100\%$ detection of out-of-range clinical emergencies with $40\%/60\%$ explainable task prioritization.
  - **Usability:** System Usability Scale (SUS) score of **$\mathbf{88.44 / 100}$ (Grade A+)** across patient and clinician cohorts.
- *"MyHealth AI proves that advanced clinical AI and predictive scheduling can run securely, locally, and reliably without cloud dependency."*
- *"Thank you, and we welcome your questions."*
