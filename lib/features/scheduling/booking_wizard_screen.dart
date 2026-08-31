library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myhealth_ai/app/theme/app_colors.dart';
import 'package:myhealth_ai/app/theme/app_spacing.dart';
import 'package:myhealth_ai/app/theme/context_colors.dart';
import 'package:myhealth_ai/core/di.dart';
import 'package:myhealth_ai/core/utils/date_utils.dart';
import 'package:myhealth_ai/domain/entities/models.dart';
import 'package:myhealth_ai/features/auth/auth_controller.dart';
import 'package:myhealth_ai/features/family/family_controller.dart';
import 'package:myhealth_ai/features/scheduling/scheduling_service.dart';
import 'package:myhealth_ai/features/shared/clinical_badge.dart';
import 'package:myhealth_ai/features/shared/double_bezel_card.dart';
import 'package:myhealth_ai/features/shared/skeletal_shimmer.dart';
import 'package:myhealth_ai/services/clinical/appointment_triage_service.dart';

class BookingWizardScreen extends ConsumerStatefulWidget {
  const BookingWizardScreen({super.key});

  @override
  ConsumerState<BookingWizardScreen> createState() => _BookingWizardScreenState();
}

class _BookingWizardScreenState extends ConsumerState<BookingWizardScreen> {
  int _step = 0;

  // Step 1: Department
  String? _selectedDepartment;

  // Step 2: Doctor
  int? _selectedDoctorId;
  String? _selectedDoctorName;

  // Step 3: Slot
  ScoredSlot? _selectedSlot;
  List<ScoredSlot> _availableSlots = [];
  bool _loadingSlots = false;

  // Step 4: Reason
  final _reasonController = TextEditingController(text: 'Routine consultation');
  bool _isBooking = false;

  final List<String> _departments = [
    'Internal Medicine',
    'Cardiology',
    'Endocrinology',
    'Pulmonology',
    'Nephrology',
  ];

  // Simplified doctor roster (matching seeder)
  final Map<String, List<Map<String, dynamic>>> _doctorsByDept = {
    'Internal Medicine': [
      {'id': 100, 'name': 'Dr. Ahmed Al-Khalifa', 'room': 'A-201'},
    ],
    'Cardiology': [
      {'id': 101, 'name': 'Dr. Amal Ghanim', 'room': 'B-105'},
      {'id': 102, 'name': 'Dr. Reem Buallay', 'room': 'B-107'},
    ],
    'Endocrinology': [
      {'id': 103, 'name': 'Dr. Fatima Al-Doseri', 'room': 'C-310'},
    ],
    'Pulmonology': [
      {'id': 104, 'name': 'Dr. Hassan Janahi', 'room': 'D-204'},
    ],
    'Nephrology': [
      {'id': 105, 'name': 'Dr. Mariam Al-Hashimi', 'room': 'E-112'},
    ],
  };

  Future<void> _loadSlots() async {
    final user = ref.read(currentUserProvider);
    if (user == null || _selectedDoctorId == null) return;

    // Book (and score risk) for whoever is currently active — the
    // guardian themselves, or a dependent they're managing.
    final patient = ref.read(managedDependentProvider) ?? user;

    setState(() => _loadingSlots = true);

    final medsResult = await ref.read(vitalsRepositoryProvider)
        .getMedicationsForPatient(patient.id, activeOnly: true);
    final meds = medsResult.fold((l) => l, (_) => <Medication>[]);

    final apptResult = await ref.read(appointmentRepositoryProvider)
        .getAppointmentsForPatient(patient.id);
    final appts = apptResult.fold((l) => l, (_) => <Appointment>[]);
    final lastVisit = appts
        .where((a) => a.status == AppointmentStatus.completed)
        .map((a) => a.slotStart)
        .fold<DateTime?>(null, (prev, d) => prev == null || d.isAfter(prev) ? d : prev);

    final schedulingService = ref.read(schedulingServiceProvider);
    final now = DateTime.now();
    final result = await schedulingService.getScoredSlots(
      patient: patient,
      doctorId: _selectedDoctorId!,
      doctorName: _selectedDoctorName ?? '',
      departmentName: _selectedDepartment ?? '',
      dateFrom: now.add(const Duration(days: 1)),
      dateTo: now.add(const Duration(days: 14)),
      activeMedCount: meds.length,
      lastVisitDate: lastVisit,
    );

    result.fold(
      (slots) => setState(() {
        _availableSlots = slots.take(20).toList(); // Show top 20 scored slots
        _loadingSlots = false;
      }),
      (_) => setState(() => _loadingSlots = false),
    );
  }

  Future<void> _confirmBooking() async {
    final user = ref.read(currentUserProvider);
    if (user == null || _selectedSlot == null) return;
    final patient = ref.read(managedDependentProvider) ?? user;

    setState(() => _isBooking = true);

    final apptRepo = ref.read(appointmentRepositoryProvider);
    final result = await apptRepo.bookAppointment(
      patientId: patient.id,
      staffId: _selectedSlot!.doctorId,
      departmentId: 1,
      slotStart: _selectedSlot!.slotStart,
      slotEnd: _selectedSlot!.slotEnd,
      visitType: 'Consultation',
      reasonText: _reasonController.text,
      predictedNoShowRisk: _selectedSlot!.prediction.probability,
      riskBand: _selectedSlot!.prediction.riskBand,
    );

    result.fold(
      (appointment) {
        // Generate and insert reminders
        final schedulingService = ref.read(schedulingServiceProvider);
        schedulingService.generateReminders(
          slotStart: _selectedSlot!.slotStart,
          riskBand: _selectedSlot!.prediction.riskBand,
          appointmentId: appointment.id,
          patientId: patient.id,
        );

        Navigator.of(context).pop(true);
      },
      (failure) {
        setState(() => _isBooking = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Booking failed: ${failure.message}')),
        );
      },
    );
  }

  Color _riskColor(RiskBand band) {
    switch (band) {
      case RiskBand.low:
        return AppColors.success;
      case RiskBand.medium:
        return AppColors.warning;
      case RiskBand.high:
        return AppColors.critical;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_stepTitle),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Step Indicator
            Padding(
              padding: const EdgeInsets.all(AppSpacing.pagePadding),
              child: Row(
                children: List.generate(4, (i) {
                  final isActive = i <= _step;
                  return Expanded(
                    child: Container(
                      height: 4,
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      decoration: BoxDecoration(
                        color: isActive ? AppColors.primaryTeal : context.borderColor,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  );
                }),
              ),
            ),

            Expanded(child: _buildStepContent()),

            // Navigation Buttons
            Padding(
              padding: const EdgeInsets.all(AppSpacing.pagePadding),
              child: Row(
                children: [
                  if (_step > 0)
                    TextButton(
                      onPressed: () => setState(() => _step--),
                      child: const Text('Back'),
                    ),
                  const Spacer(),
                  if (_step < 3)
                    ElevatedButton(
                      onPressed: _canAdvance ? () => _advanceStep() : null,
                      child: const Text('Next'),
                    ),
                  if (_step == 3)
                    ElevatedButton.icon(
                      onPressed: _isBooking ? null : _confirmBooking,
                      icon: const Icon(Icons.check_rounded),
                      label: _isBooking
                          ? const SizedBox(
                              height: 18,
                              width: 18,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                            )
                          : const Text('Confirm Booking'),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String get _stepTitle {
    switch (_step) {
      case 0:
        return 'Select Department';
      case 1:
        return 'Select Doctor';
      case 2:
        return 'Select Slot';
      case 3:
        return 'Confirm Booking';
      default:
        return 'Book Appointment';
    }
  }

  bool get _canAdvance {
    switch (_step) {
      case 0:
        return _selectedDepartment != null;
      case 1:
        return _selectedDoctorId != null;
      case 2:
        return _selectedSlot != null;
      default:
        return false;
    }
  }

  void _advanceStep() {
    if (_step == 1 && _selectedDoctorId != null) {
      _loadSlots();
    }
    setState(() => _step++);
  }

  Widget _buildStepContent() {
    switch (_step) {
      case 0:
        return _buildDepartmentStep();
      case 1:
        return _buildDoctorStep();
      case 2:
        return _buildSlotStep();
      case 3:
        return _buildConfirmationStep();
      default:
        return const SizedBox.shrink();
    }
  }

  // Step 1: Department Selection
  Widget _buildDepartmentStep() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pagePadding),
      itemCount: _departments.length,
      itemBuilder: (context, index) {
        final dept = _departments[index];
        final isSelected = _selectedDepartment == dept;
        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.sm),
          child: DoubleBezelCard(
            borderColor: isSelected ? AppColors.primaryTeal : null,
            onTap: () => setState(() => _selectedDepartment = dept),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.primaryTeal.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.local_hospital_rounded, color: AppColors.primaryTeal, size: 22),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(
                    dept,
                    style: TextStyle(
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                ),
                if (isSelected)
                  const Icon(Icons.check_circle_rounded, color: AppColors.primaryTeal),
              ],
            ),
          ),
        );
      },
    );
  }

  // Step 2: Doctor Selection
  Widget _buildDoctorStep() {
    final doctors = _doctorsByDept[_selectedDepartment] ?? [];
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pagePadding),
      itemCount: doctors.length,
      itemBuilder: (context, index) {
        final doc = doctors[index];
        final isSelected = _selectedDoctorId == doc['id'];
        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.sm),
          child: DoubleBezelCard(
            borderColor: isSelected ? AppColors.primaryTeal : null,
            onTap: () => setState(() {
              _selectedDoctorId = doc['id'] as int;
              _selectedDoctorName = doc['name'] as String;
            }),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppColors.primaryTeal.withValues(alpha: 0.15),
                  child: Text(
                    (doc['name'] as String).split(' ').last[0],
                    style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryTeal),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        doc['name'] as String,
                        style: TextStyle(
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        'Room ${doc['room']} • $_selectedDepartment',
                        style: TextStyle(color: context.textSecondary, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                if (isSelected)
                  const Icon(Icons.check_circle_rounded, color: AppColors.primaryTeal),
              ],
            ),
          ),
        );
      },
    );
  }

  // Step 3: AI-Scored Slot Selection
  Widget _buildSlotStep() {
    if (_loadingSlots) {
      return ListView.builder(
        padding: const EdgeInsets.all(AppSpacing.pagePadding),
        itemCount: 5,
        itemBuilder: (_, __) => const Padding(
          padding: EdgeInsets.only(bottom: AppSpacing.md),
          child: SkeletalShimmer(width: double.infinity, height: 80),
        ),
      );
    }

    if (_availableSlots.isEmpty) {
      return const Center(child: Text('No available slots in the next 14 days.'));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pagePadding),
          child: Row(
            children: const [
              Icon(Icons.auto_awesome_rounded, size: 16, color: AppColors.aiAccent),
              SizedBox(width: 6),
              Text(
                'AI-Recommended Slots (sorted by lowest no-show risk)',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.aiAccent),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pagePadding),
            itemCount: _availableSlots.length,
            itemBuilder: (context, index) {
              final slot = _availableSlots[index];
              final isSelected = _selectedSlot == slot;
              final riskColor = _riskColor(slot.prediction.riskBand);

              return Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: DoubleBezelCard(
                  borderColor: isSelected ? AppColors.primaryTeal : null,
                  onTap: () => setState(() => _selectedSlot = slot),
                  child: Row(
                    children: [
                      Container(
                        width: 6,
                        height: 48,
                        decoration: BoxDecoration(
                          color: riskColor,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${formatClinicalDate(slot.slotStart)} at ${formatTime24h(slot.slotStart)}',
                              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                            ),
                            Text(
                              '${slot.doctorName} • ${slot.departmentName}',
                              style: TextStyle(color: context.textSecondary, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      ClinicalBadge(
                        label: slot.prediction.riskLabel,
                        backgroundColor: riskColor.withValues(alpha: 0.15),
                        textColor: riskColor,
                      ),
                      if (index < 3) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: context.aiSurface,
                            borderRadius: BorderRadius.circular(AppRadius.xs),
                          ),
                          child: const Text(
                            '★ Top',
                            style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: AppColors.aiAccent),
                          ),
                        ),
                      ],
                      if (isSelected) ...[
                        const SizedBox(width: 6),
                        const Icon(Icons.check_circle_rounded, color: AppColors.primaryTeal, size: 20),
                      ],
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // Step 4: Confirmation Summary
  Widget _buildConfirmationStep() {
    if (_selectedSlot == null) return const SizedBox.shrink();
    final slot = _selectedSlot!;
    final riskColor = _riskColor(slot.prediction.riskBand);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pagePadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DoubleBezelCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Appointment Summary',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: AppSpacing.md),
                _SummaryRow(label: 'Department', value: slot.departmentName),
                _SummaryRow(label: 'Doctor', value: slot.doctorName),
                _SummaryRow(label: 'Date', value: formatClinicalDate(slot.slotStart)),
                _SummaryRow(label: 'Time', value: '${formatTime24h(slot.slotStart)} – ${formatTime24h(slot.slotEnd)}'),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('AI No-Show Risk', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                    ClinicalBadge(
                      label: '${slot.prediction.riskLabel} (${slot.prediction.percentageLabel})',
                      backgroundColor: riskColor.withValues(alpha: 0.15),
                      textColor: riskColor,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  _reminderDescription(slot.prediction.riskBand),
                  style: TextStyle(color: context.textSecondary, fontSize: 12),
                ),
                if (slot.prediction.topRiskFactors.isNotEmpty || slot.prediction.topProtectiveFactors.isNotEmpty) ...[
                  const Divider(height: 20),
                  const Text(
                    'AI Risk Explainability',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: AppColors.aiAccent),
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: [
                      ...slot.prediction.topProtectiveFactors.map((f) => Chip(
                            avatar: const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 14),
                            label: Text('${f.key} (protective)', style: const TextStyle(fontSize: 10, color: AppColors.success)),
                            backgroundColor: AppColors.success.withValues(alpha: 0.1),
                            padding: EdgeInsets.zero,
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          )),
                      ...slot.prediction.topRiskFactors.map((f) => Chip(
                            avatar: const Icon(Icons.warning_amber_rounded, color: AppColors.warning, size: 14),
                            label: Text('${f.key} (+risk)', style: const TextStyle(fontSize: 10, color: AppColors.warning)),
                            backgroundColor: AppColors.warning.withValues(alpha: 0.1),
                            padding: EdgeInsets.zero,
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          )),
                    ],
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          TextFormField(
            controller: _reasonController,
            decoration: const InputDecoration(labelText: 'Reason for Visit'),
            maxLines: 2,
          ),
          const SizedBox(height: AppSpacing.sm),
          AnimatedBuilder(
            animation: _reasonController,
            builder: (context, _) {
              final urgency = AppointmentTriageService.classify(_reasonController.text);
              return Row(
                children: [
                  ClinicalBadge(
                    label: '${urgency.label} priority',
                    tone: urgency.tone,
                    icon: urgency.icon,
                    pulsing: urgency == AppointmentUrgency.urgent,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      urgency.description,
                      style: TextStyle(color: context.textSecondary, fontSize: 11.5),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  String _reminderDescription(RiskBand band) {
    switch (band) {
      case RiskBand.low:
        return '📱 1 reminder will be sent (24h before appointment).';
      case RiskBand.medium:
        return '📱 2 reminders will be sent (48h and 24h before appointment).';
      case RiskBand.high:
        return '📱 3 reminders will be sent (7 days, 48h, and morning of appointment with phone confirmation).';
    }
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: context.textSecondary, fontSize: 13)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
        ],
      ),
    );
  }
}
