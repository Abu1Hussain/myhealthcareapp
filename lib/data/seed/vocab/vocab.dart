/// Realistic medical and demographic vocabulary for the synthetic data generator.
/// Focuses on Bahraini / GCC demographics with authentic names, standard lab reference ranges,
/// and correlated chronic health conditions.
abstract final class SeedVocab {
  // ── Departments ────────────────────────────────────────────────────
  static const List<Map<String, String>> departments = [
    {
      'name': 'Internal Medicine',
      'description': 'Comprehensive adult healthcare, chronic disease management, and diagnostic workups.',
    },
    {
      'name': 'Cardiology',
      'description': 'Cardiovascular health, hypertension management, ECG, and heart disease diagnostics.',
    },
    {
      'name': 'Endocrinology',
      'description': 'Specialized diabetes care, thyroid disorders, and metabolic health.',
    },
    {
      'name': 'Pediatrics',
      'description': 'Child healthcare, routine vaccinations, and developmental assessments.',
    },
    {
      'name': 'Orthopedics',
      'description': 'Musculoskeletal injuries, joint health, and physical rehabilitation.',
    },
  ];

  // ── Staff (12 Doctors / Clinicians) ────────────────────────────────
  static const List<Map<String, dynamic>> staffMembers = [
    {
      'name': 'Dr. Amal Ghanim',
      'email': 'amal.ghanim@myhealth.uob',
      'gender': 'F',
      'deptIndex': 0, // Internal Medicine
      'specialty': 'Consultant Internal Medicine',
      'licenseNo': 'MOH-BH-10492',
      'jobTitle': 'Chief Medical Consultant',
    },
    {
      'name': 'Dr. Tariq Al-Alawi',
      'email': 'tariq.alalawi@myhealth.uob',
      'gender': 'M',
      'deptIndex': 0,
      'specialty': 'Senior Specialist Internal Medicine',
      'licenseNo': 'MOH-BH-10583',
      'jobTitle': 'Senior Specialist',
    },
    {
      'name': 'Dr. Reem Buallay',
      'email': 'reem.buallay@myhealth.uob',
      'gender': 'F',
      'deptIndex': 1, // Cardiology
      'specialty': 'Consultant Interventional Cardiology',
      'licenseNo': 'MOH-BH-20194',
      'jobTitle': 'Head of Cardiology',
    },
    {
      'name': 'Dr. Khalid Al-Doseri',
      'email': 'khalid.aldoseri@myhealth.uob',
      'gender': 'M',
      'deptIndex': 1,
      'specialty': 'Cardiologist',
      'licenseNo': 'MOH-BH-20231',
      'jobTitle': 'Specialist Cardiologist',
    },
    {
      'name': 'Dr. Fatima Al-Hasan',
      'email': 'fatima.alhasan@myhealth.uob',
      'gender': 'F',
      'deptIndex': 2, // Endocrinology
      'specialty': 'Consultant Endocrinologist',
      'licenseNo': 'MOH-BH-30812',
      'jobTitle': 'Head of Endocrinology',
    },
    {
      'name': 'Dr. Yasser Mansoor',
      'email': 'yasser.mansoor@myhealth.uob',
      'gender': 'M',
      'deptIndex': 2,
      'specialty': 'Diabetologist',
      'licenseNo': 'MOH-BH-30944',
      'jobTitle': 'Specialist Diabetologist',
    },
    {
      'name': 'Dr. Noor Al-Jowder',
      'email': 'noor.aljowder@myhealth.uob',
      'gender': 'F',
      'deptIndex': 3, // Pediatrics
      'specialty': 'Consultant Pediatrician',
      'licenseNo': 'MOH-BH-40129',
      'jobTitle': 'Senior Pediatrician',
    },
    {
      'name': 'Dr. Isa Al-Qassab',
      'email': 'isa.alqassab@myhealth.uob',
      'gender': 'M',
      'deptIndex': 3,
      'specialty': 'General Pediatrics',
      'licenseNo': 'MOH-BH-40283',
      'jobTitle': 'Resident Pediatrician',
    },
    {
      'name': 'Dr. Salman Fakhro',
      'email': 'salman.fakhro@myhealth.uob',
      'gender': 'M',
      'deptIndex': 4, // Orthopedics
      'specialty': 'Consultant Orthopedic Surgeon',
      'licenseNo': 'MOH-BH-50119',
      'jobTitle': 'Head of Orthopedics',
    },
    {
      'name': 'Dr. Zainab Al-Arrayed',
      'email': 'zainab.alarrayed@myhealth.uob',
      'gender': 'F',
      'deptIndex': 4,
      'specialty': 'Sports Medicine & Joint Rehabilitation',
      'licenseNo': 'MOH-BH-50294',
      'jobTitle': 'Specialist Orthopedic Surgeon',
    },
    {
      'name': 'Dr. Ahmed Al-Mahmood',
      'email': 'ahmed.almahmood@myhealth.uob',
      'gender': 'M',
      'deptIndex': 0,
      'specialty': 'General Practice & Preventative Medicine',
      'licenseNo': 'MOH-BH-10992',
      'jobTitle': 'Clinical Fellow',
    },
    {
      'name': 'Dr. Maryam Janahi',
      'email': 'maryam.janahi@myhealth.uob',
      'gender': 'F',
      'deptIndex': 2,
      'specialty': 'Endocrinology & Lipid Metabolism',
      'licenseNo': 'MOH-BH-30999',
      'jobTitle': 'Clinical Fellow',
    },
  ];

  // ── Bahraini Patient First & Last Names ────────────────────────────
  static const List<String> maleFirstNames = [
    'Ali', 'Mohammed', 'Hassan', 'Husain', 'Abdullah', 'Ahmed', 'Yousif',
    'Ibrahim', 'Mahmood', 'Salman', 'Hamad', 'Jassim', 'Nasser', 'Sadiq',
    'Mustafa', 'Abdulrahman', 'Ebrahim', 'Omar', 'Rashid', 'Adnan',
  ];

  static const List<String> femaleFirstNames = [
    'Fatima', 'Maryam', 'Zainab', 'Noor', 'Sara', 'Reem', 'Amina',
    'Layla', 'Huda', 'Zahra', 'Khadija', 'Mona', 'Shaikha', 'Eman',
    'Hawra', 'Dana', 'Rania', 'Yasmin', 'Lulwa', 'Batool',
  ];

  static const List<String> familyNames = [
    'Al-Alawi', 'Al-Jowder', 'Al-Arrayed', 'Al-Mahmood', 'Buallay', 'Janahi',
    'Al-Qassab', 'Fakhro', 'Al-Doseri', 'Al-Hasan', 'Al-Ghanim', 'Meftah',
    'Mansoor', 'Al-Shaikh', 'Al-Kooheji', 'Al-Mutawa', 'Al-Binali', 'Al-Khaja',
    'Al-Romaihi', 'Al-Zayani', 'Al-Abbasi', 'Al-Mannai',
  ];

  // ── Chronic Conditions ─────────────────────────────────────────────
  static const List<String> chronicConditions = [
    'Type 2 Diabetes Mellitus',
    'Essential Hypertension',
    'Hyperlipidemia',
    'Bronchial Asthma',
    'Coronary Artery Disease',
    'Chronic Kidney Disease Stage 2',
    'Hypothyroidism',
    'Osteoarthritis',
  ];

  // ── Allergies ──────────────────────────────────────────────────────
  static const List<String> commonAllergies = [
    'Penicillin',
    'Sulfa drugs',
    'NSAIDs (Aspirin/Ibuprofen)',
    'Cephalosporins',
    'Latex',
    'Peanuts',
    'None known',
  ];

  // ── Lab Analytes & Reference Ranges ────────────────────────────────
  static const List<Map<String, dynamic>> labAnalytes = [
    {
      'analyte': 'HbA1c',
      'unit': '%',
      'refLow': 4.0,
      'refHigh': 5.6,
      'normalMean': 5.2,
      'diabeticMean': 7.8,
    },
    {
      'analyte': 'Fasting Blood Glucose',
      'unit': 'mg/dL',
      'refLow': 70.0,
      'refHigh': 99.0,
      'normalMean': 88.0,
      'diabeticMean': 145.0,
    },
    {
      'analyte': 'Total Cholesterol',
      'unit': 'mg/dL',
      'refLow': 125.0,
      'refHigh': 200.0,
      'normalMean': 175.0,
      'hyperlipidMean': 240.0,
    },
    {
      'analyte': 'Serum Creatinine',
      'unit': 'mg/dL',
      'refLow': 0.7,
      'refHigh': 1.3,
      'normalMean': 0.95,
      'abnormalMean': 1.7,
    },
    {
      'analyte': 'Hemoglobin',
      'unit': 'g/dL',
      'refLow': 12.0,
      'refHigh': 16.5,
      'normalMean': 14.2,
      'anemicMean': 10.5,
    },
  ];

  // ── Common Medications ─────────────────────────────────────────────
  static const List<Map<String, String>> medicationsList = [
    {'name': 'Metformin', 'dose': '500mg', 'freq': 'Twice daily with meals'},
    {'name': 'Metformin XR', 'dose': '1000mg', 'freq': 'Once daily evening'},
    {'name': 'Amlodipine', 'dose': '5mg', 'freq': 'Once daily morning'},
    {'name': 'Lisinopril', 'dose': '10mg', 'freq': 'Once daily morning'},
    {'name': 'Atorvastatin', 'dose': '20mg', 'freq': 'Once daily at bedtime'},
    {'name': 'Empagliflozin (Jardiance)', 'dose': '10mg', 'freq': 'Once daily morning'},
    {'name': 'Ventolin Inhaler (Salbutamol)', 'dose': '100mcg', 'freq': '2 puffs as needed'},
    {'name': 'Levothyroxine', 'dose': '50mcg', 'freq': 'Once daily on empty stomach'},
    {'name': 'Panadol (Paracetamol)', 'dose': '500mg', 'freq': 'Every 6 hours as needed'},
  ];
}
