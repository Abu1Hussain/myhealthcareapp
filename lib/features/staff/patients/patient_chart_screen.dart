library;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myhealth_ai/app/theme/app_colors.dart';
import 'package:myhealth_ai/app/theme/app_spacing.dart';
import 'package:myhealth_ai/app/theme/context_colors.dart';
import 'package:myhealth_ai/core/di.dart';
import 'package:myhealth_ai/core/utils/date_utils.dart';
import 'package:myhealth_ai/domain/entities/models.dart';
import 'package:myhealth_ai/features/auth/auth_controller.dart';
import 'package:myhealth_ai/features/patient_home/widgets/ai_summary_card.dart';
import 'package:myhealth_ai/features/shared/clinical_badge.dart';
import 'package:myhealth_ai/features/shared/double_bezel_card.dart';
import 'package:myhealth_ai/features/shared/empty_state_widget.dart';
import 'package:myhealth_ai/features/shared/skeletal_shimmer.dart';
import 'package:myhealth_ai/features/staff/records/clinical_note_dialog.dart';
import 'package:myhealth_ai/features/staff/records/prescription_dialog.dart';
import 'package:myhealth_ai/features/vitals/log_vitals_modal.dart';

class PatientChartScreen extends ConsumerStatefulWidget {
  const PatientChartScreen({
    super.key,
    required this.patientId,
  });

  final int patientId;

  @override
  ConsumerState<PatientChartScreen> createState() => _PatientChartScreenState();
}

class _PatientChartScreenState extends ConsumerState<PatientChartScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userFuture = ref.watch(userRepositoryProvider).getUserById(widget.patientId);

    return FutureBuilder(
      future: userFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final patient = snapshot.data!.fold((u) => u, (_) => null);
        if (patient == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Patient Not Found')),
            body: const Center(child: Text('Patient record does not exist.')),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(patient.fullName),
            bottom: TabBar(
              controller: _tabController,
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              tabs: const [
                Tab(icon: Icon(Icons.info_outline_rounded), text: 'Overview'),
                Tab(icon: Icon(Icons.auto_awesome_rounded), text: 'AI Summary'),
                Tab(icon: Icon(Icons.timeline_rounded), text: 'Timeline'),
                Tab(icon: Icon(Icons.show_chart_rounded), text: 'Vitals & Labs'),
                Tab(icon: Icon(Icons.medication_rounded), text: 'Medications'),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.note_add_rounded),
                tooltip: 'Add Encounter Note',
                onPressed: () => _openNoteDialog(patient),
              ),
              IconButton(
                icon: const Icon(Icons.medication_liquid_rounded),
                tooltip: 'Prescribe Medication',
                onPressed: () => _openPrescriptionDialog(patient),
              ),
              IconButton(
                icon: const Icon(Icons.add_chart_rounded),
                tooltip: 'Log Vitals',
                onPressed: () => _openVitalsModal(patient),
              ),
            ],
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              _buildOverviewTab(patient),
              _buildAiSummaryTab(patient),
              _buildTimelineTab(patient),
              _buildVitalsTab(patient),
              _buildMedicationsTab(patient),
            ],
          ),
        );
      },
    );
  }

  void _openNoteDialog(User patient) {
    showDialog(
      context: context,
      builder: (_) => ClinicalNoteDialog(
        patientId: patient.id,
        patientName: patient.fullName,
      ),
    ).then((val) {
      if (val == true) setState(() {});
    });
  }

  void _openPrescriptionDialog(User patient) {
    showDialog(
      context: context,
      builder: (_) => PrescriptionDialog(
        patientId: patient.id,
        patientName: patient.fullName,
      ),
    ).then((val) {
      if (val == true) setState(() {});
    });
  }

  void _openVitalsModal(User patient) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => LogVitalsModal(patientId: patient.id),
    ).then((_) => setState(() {}));
  }

  // 1. Overview Tab
  Widget _buildOverviewTab(User patient) {
    final riskFlagsFuture = ref.watch(riskRepositoryProvider).getActiveRiskFlags(patientId: patient.id);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.pagePadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Demographics Card
          DoubleBezelCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 26,
                      backgroundColor: AppColors.primaryTeal.withValues(alpha: 0.15),
                      child: Text(
                        patient.fullName.isNotEmpty ? patient.fullName[0] : 'P',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: AppColors.primaryTeal),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(patient.fullName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                          Text(
                            '${patient.age} yrs • ${patient.gender == 'M' ? 'Male' : 'Female'} • CPR: ${patient.nationalId}',
                            style: TextStyle(color: context.textSecondary, fontSize: 13),
                          ),
                          Text(
                            'Contact: ${patient.phone} • Blood: ${patient.patientProfile?.bloodType ?? "N/A"}',
                            style: TextStyle(color: context.textSecondary, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Divider(height: 24),
                _InfoRow(label: 'Allergies', value: patient.patientProfile?.allergies.join(', ') ?? 'No known allergies'),
                _InfoRow(label: 'Chronic Conditions', value: patient.patientProfile?.chronicConditions.join(', ') ?? 'None documented'),
                _InfoRow(label: 'Emergency Contact', value: patient.patientProfile?.emergencyContact ?? 'None documented'),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // Active Risk Flags Section
          Text(
            'Active Clinical Risk Flags',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: AppSpacing.sm),

          FutureBuilder(
            future: riskFlagsFuture,
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const SkeletalShimmer(width: double.infinity, height: 80);
              final flags = snapshot.data!.fold((l) => l, (_) => <RiskFlagItem>[]);

              if (flags.isEmpty) {
                return DoubleBezelCard(
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle_outline_rounded, color: AppColors.success),
                      const SizedBox(width: 12),
                      Text('No active clinical risk flags detected.', style: TextStyle(color: context.textSecondary)),
                    ],
                  ),
                );
              }

              return Column(
                children: flags.map((flag) {
                  final isCritical = flag.severity == RiskSeverity.critical;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: DoubleBezelCard(
                      borderColor: isCritical ? AppColors.critical : AppColors.warning,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            isCritical ? Icons.emergency_rounded : Icons.warning_amber_rounded,
                            color: isCritical ? AppColors.critical : AppColors.warning,
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      flag.kind.replaceAll('_', ' ').toUpperCase(),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                        color: isCritical ? AppColors.critical : AppColors.warning,
                                      ),
                                    ),
                                    const Spacer(),
                                    ClinicalBadge(
                                      label: flag.severity.name.toUpperCase(),
                                      backgroundColor: (isCritical ? AppColors.critical : AppColors.warning).withValues(alpha: 0.15),
                                      textColor: isCritical ? AppColors.critical : AppColors.warning,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(flag.rationale, style: const TextStyle(fontSize: 12)),
                                const SizedBox(height: 6),
                                Text(
                                  'Detected: ${formatClinicalDate(flag.detectedAt)} (${flag.source.name})',
                                  style: TextStyle(fontSize: 10, color: context.textSecondary),
                                ),
                              ],
                            ),
                          ),
                          if (flag.acknowledgedAt == null) ...[
                            const SizedBox(width: 8),
                            TextButton(
                              onPressed: () async {
                                final staff = ref.read(currentUserProvider);
                                if (staff != null) {
                                  await ref.read(riskRepositoryProvider).acknowledgeRiskFlag(flag.id, staff.id);
                                  setState(() {});
                                }
                              },
                              child: const Text('Ack', style: TextStyle(fontSize: 12)),
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  // 2. AI Summary Tab
  Widget _buildAiSummaryTab(User patient) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.pagePadding),
      child: Column(
        children: [
          AiSummaryCard(patientId: patient.id),
        ],
      ),
    );
  }

  // 3. Timeline Tab
  Widget _buildTimelineTab(User patient) {
    final recordsFuture = ref.watch(recordRepositoryProvider).getTimelineForPatient(patient.id);

    return FutureBuilder(
      future: recordsFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final records = snapshot.data!.fold((l) => l, (_) => <MedicalRecord>[]);

        if (records.isEmpty) {
          return EmptyStateWidget(
            icon: Icons.description_outlined,
            title: 'No Clinical Records',
            description: 'No consultation notes or diagnostic reports recorded yet.',
            actionLabel: 'Add Note',
            onAction: () => _openNoteDialog(patient),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(AppSpacing.pagePadding),
          itemCount: records.length,
          itemBuilder: (context, index) {
            final rec = records[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: DoubleBezelCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        ClinicalBadge.recordType(rec.recordType),
                        const Spacer(),
                        Text(formatClinicalDate(rec.occurredAt), style: TextStyle(fontSize: 12, color: context.textSecondary)),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(rec.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    const SizedBox(height: 4),
                    Text(rec.body, style: const TextStyle(fontSize: 13)),
                    if (rec.labValues.isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.sm),
                      Wrap(
                        spacing: 6,
                        children: rec.labValues.map((l) {
                          return Chip(
                            label: Text('${l.analyte}: ${l.value} ${l.unit}', style: const TextStyle(fontSize: 11)),
                          );
                        }).toList(),
                      ),
                    ],
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // 4. Vitals & Labs Tab
  Widget _buildVitalsTab(User patient) {
    final vitalsFuture = ref.watch(vitalsRepositoryProvider).getVitalsHistory(patient.id, limit: 15);

    return FutureBuilder(
      future: vitalsFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
        final vitals = snapshot.data!.fold((l) => l, (_) => <VitalsRecord>[]);

        if (vitals.isEmpty) {
          return EmptyStateWidget(
            icon: Icons.favorite_outline_rounded,
            title: 'No Vitals Recorded',
            description: 'Log patient blood pressure, glucose, and heart rate.',
            actionLabel: 'Log Vitals',
            onAction: () => _openVitalsModal(patient),
          );
        }

        // Prepare points for Blood Pressure chart
        final bpSpotsSys = <FlSpot>[];
        final bpSpotsDia = <FlSpot>[];
        for (int i = 0; i < vitals.length; i++) {
          final v = vitals[vitals.length - 1 - i]; // chronological
          if (v.systolic != null) bpSpotsSys.add(FlSpot(i.toDouble(), v.systolic!));
          if (v.diastolic != null) bpSpotsDia.add(FlSpot(i.toDouble(), v.diastolic!));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.pagePadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (bpSpotsSys.length >= 2) ...[
                Text(
                  'Blood Pressure Trajectory (mmHg)',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: AppSpacing.sm),
                DoubleBezelCard(
                  child: SizedBox(
                    height: 180,
                    child: LineChart(
                      LineChartData(
                        gridData: const FlGridData(show: true, drawVerticalLine: false),
                        titlesData: const FlTitlesData(
                          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        ),
                        borderData: FlBorderData(show: false),
                        lineBarsData: [
                          LineChartBarData(
                            spots: bpSpotsSys,
                            isCurved: true,
                            color: AppColors.critical,
                            barWidth: 3,
                            dotData: const FlDotData(show: true),
                          ),
                          LineChartBarData(
                            spots: bpSpotsDia,
                            isCurved: true,
                            color: AppColors.primaryTeal,
                            barWidth: 2,
                            dotData: const FlDotData(show: true),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
              ],

              Text(
                'Recent Logged Readings',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: AppSpacing.sm),
              ...vitals.map((v) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: DoubleBezelCard(
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(formatClinicalDate(v.recordedAt), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                                Text(
                                  'BP: ${v.systolic?.round() ?? "-"}/${v.diastolic?.round() ?? "-"} mmHg • HR: ${v.heartRate?.round() ?? "-"} bpm • Glucose: ${v.glucose?.round() ?? "-"} mg/dL',
                                  style: TextStyle(color: context.textSecondary, fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                          if (v.spo2 != null)
                            ClinicalBadge(
                              label: 'SpO2 ${v.spo2!.toStringAsFixed(0)}%',
                              backgroundColor: AppColors.info.withValues(alpha: 0.15),
                              textColor: AppColors.info,
                            ),
                        ],
                      ),
                    ),
                  )),
            ],
          ),
        );
      },
    );
  }

  // 5. Medications Tab
  Widget _buildMedicationsTab(User patient) {
    final medsFuture = ref.watch(vitalsRepositoryProvider).getMedicationsForPatient(patient.id);

    return FutureBuilder(
      future: medsFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
        final meds = snapshot.data!.fold((l) => l, (_) => <Medication>[]);

        if (meds.isEmpty) {
          return EmptyStateWidget(
            icon: Icons.medication_rounded,
            title: 'No Medications',
            description: 'No active prescriptions on file.',
            actionLabel: 'Prescribe Medication',
            onAction: () => _openPrescriptionDialog(patient),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(AppSpacing.pagePadding),
          itemCount: meds.length,
          itemBuilder: (context, index) {
            final med = meds[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: DoubleBezelCard(
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.primaryTeal.withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.medication_rounded, color: AppColors.primaryTeal, size: 20),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(med.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                          Text('${med.dose} • ${med.frequency}', style: TextStyle(color: context.textSecondary, fontSize: 12)),
                          Text(
                            'Started: ${formatClinicalDate(med.startDate)}${med.endDate != null ? " • Until: ${formatClinicalDate(med.endDate!)}" : ""}',
                            style: TextStyle(color: context.textSecondary, fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                    ClinicalBadge(
                      label: med.isActive ? 'Active' : 'Completed',
                      backgroundColor: med.isActive ? AppColors.success.withValues(alpha: 0.15) : null,
                      textColor: med.isActive ? AppColors.success : null,
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(label, style: TextStyle(color: context.textSecondary, fontSize: 13)),
          ),
          Expanded(
            child: Text(value, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
          ),
        ],
      ),
    );
  }
}
