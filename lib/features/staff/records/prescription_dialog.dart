library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myhealth_ai/app/theme/app_colors.dart';
import 'package:myhealth_ai/app/theme/app_spacing.dart';
import 'package:myhealth_ai/core/di.dart';
import 'package:myhealth_ai/features/auth/auth_controller.dart';

/// Modal dialog for prescribing new medications to a patient.
class PrescriptionDialog extends ConsumerStatefulWidget {
  const PrescriptionDialog({
    super.key,
    required this.patientId,
    required this.patientName,
  });

  final int patientId;
  final String patientName;

  @override
  ConsumerState<PrescriptionDialog> createState() => _PrescriptionDialogState();
}

class _PrescriptionDialogState extends ConsumerState<PrescriptionDialog> {
  final _formKey = GlobalKey<FormState>();
  final _medNameController = TextEditingController();
  final _doseController = TextEditingController();
  final _freqController = TextEditingController(text: 'Once daily');
  final _durationDaysController = TextEditingController(text: '30');
  bool _isSaving = false;

  final List<String> _commonMeds = [
    'Metformin 500mg',
    'Metformin 1000mg',
    'Lisinopril 10mg',
    'Amlodipine 5mg',
    'Atorvastatin 20mg',
    'Salbutamol Inhaler 100mcg',
    'Omeprazole 20mg',
    'Paracetamol 500mg',
    'Empagliflozin 10mg',
  ];

  final List<String> _frequencies = [
    'Once daily',
    'Twice daily (morning & night)',
    'Three times daily (with meals)',
    'Four times daily',
    'As needed for pain/symptoms',
    'At bedtime',
  ];

  @override
  void dispose() {
    _medNameController.dispose();
    _doseController.dispose();
    _freqController.dispose();
    _durationDaysController.dispose();
    super.dispose();
  }

  Future<void> _prescribe() async {
    if (!_formKey.currentState!.validate()) return;
    final staff = ref.read(currentUserProvider);
    if (staff == null) return;

    setState(() => _isSaving = true);

    final durationDays = int.tryParse(_durationDaysController.text.trim()) ?? 30;
    final startDate = DateTime.now();
    final endDate = startDate.add(Duration(days: durationDays));

    final result = await ref.read(vitalsRepositoryProvider).prescribeMedication(
          patientId: widget.patientId,
          prescriberId: staff.id,
          name: _medNameController.text.trim(),
          dose: _doseController.text.trim().isNotEmpty ? _doseController.text.trim() : 'Standard',
          frequency: _freqController.text.trim(),
          startDate: startDate,
          endDate: endDate,
        );

    result.fold(
      (medication) {
        Navigator.of(context).pop(true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Prescribed ${_medNameController.text} successfully.')),
        );
      },
      (failure) {
        setState(() => _isSaving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to prescribe: ${failure.message}')),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.lg)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 550),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.pagePadding),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.medication_rounded, color: AppColors.primaryTeal),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Prescribe Medication • ${widget.patientName}',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close_rounded),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const Divider(height: 24),

                  // Quick medication chips
                  Text(
                    'Common Formularies',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600, color: AppColors.textSecondaryLight),
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: _commonMeds.take(5).map((med) {
                      return ActionChip(
                        label: Text(med, style: const TextStyle(fontSize: 11)),
                        onPressed: () {
                          final parts = med.split(' ');
                          setState(() {
                            _medNameController.text = parts.first;
                            if (parts.length > 1) _doseController.text = parts.sublist(1).join(' ');
                          });
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: AppSpacing.md),

                  TextFormField(
                    controller: _medNameController,
                    decoration: const InputDecoration(
                      labelText: 'Medication Name',
                      hintText: 'e.g. Metformin, Lisinopril',
                    ),
                    validator: (v) => (v == null || v.trim().isEmpty) ? 'Please enter medication name' : null,
                  ),
                  const SizedBox(height: AppSpacing.md),

                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _doseController,
                          decoration: const InputDecoration(
                            labelText: 'Dose / Strength',
                            hintText: 'e.g. 500mg, 10mg',
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: TextFormField(
                          controller: _durationDaysController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Duration (Days)',
                            hintText: '30',
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),

                  DropdownButtonFormField<String>(
                    initialValue: _freqController.text,
                    decoration: const InputDecoration(labelText: 'Frequency / Instructions'),
                    items: _frequencies.map((f) => DropdownMenuItem(value: f, child: Text(f))).toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _freqController.text = val);
                    },
                  ),
                  const SizedBox(height: AppSpacing.xl),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      ElevatedButton.icon(
                        onPressed: _isSaving ? null : _prescribe,
                        icon: const Icon(Icons.check_rounded),
                        label: _isSaving
                            ? const SizedBox(
                                height: 16,
                                width: 16,
                                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                              )
                            : const Text('Prescribe'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
