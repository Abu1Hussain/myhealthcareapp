library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myhealth_ai/app/theme/app_colors.dart';
import 'package:myhealth_ai/app/theme/app_spacing.dart';
import 'package:myhealth_ai/features/shared/double_bezel_card.dart';
import 'package:myhealth_ai/features/vitals/vitals_controller.dart';

class LogVitalsModal extends ConsumerStatefulWidget {
  const LogVitalsModal({super.key, required this.patientId});

  final int patientId;

  @override
  ConsumerState<LogVitalsModal> createState() => _LogVitalsModalState();
}

class _LogVitalsModalState extends ConsumerState<LogVitalsModal> {
  final _formKey = GlobalKey<FormState>();
  final _sysController = TextEditingController(text: '120');
  final _diaController = TextEditingController(text: '80');
  final _hrController = TextEditingController(text: '72');
  final _glucoseController = TextEditingController(text: '95');
  final _weightController = TextEditingController(text: '70');

  bool _isSaving = false;

  @override
  void dispose() {
    _sysController.dispose();
    _diaController.dispose();
    _hrController.dispose();
    _glucoseController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    final success = await ref.read(vitalsControllerProvider.notifier).logVitals(
          systolic: double.tryParse(_sysController.text),
          diastolic: double.tryParse(_diaController.text),
          heartRate: double.tryParse(_hrController.text),
          glucose: double.tryParse(_glucoseController.text),
          weightKg: double.tryParse(_weightController.text),
        );

    if (success && mounted) {
      Navigator.of(context).pop();
    } else {
      setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: AppSpacing.pagePadding,
        right: AppSpacing.pagePadding,
        top: AppSpacing.pagePadding,
      ),
      child: DoubleBezelCard(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    const Icon(Icons.favorite_rounded, color: AppColors.critical),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      'Log Vitals Observation',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close_rounded),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),

                // BP Systolic / Diastolic
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _sysController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(labelText: 'Systolic BP (mmHg)'),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: TextFormField(
                        controller: _diaController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(labelText: 'Diastolic BP (mmHg)'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),

                // Heart Rate & Fasting Glucose
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _hrController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(labelText: 'Heart Rate (bpm)'),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: TextFormField(
                        controller: _glucoseController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(labelText: 'Fasting Glucose (mg/dL)'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),

                TextFormField(
                  controller: _weightController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Weight (kg)'),
                ),
                const SizedBox(height: AppSpacing.xl),

                ElevatedButton.icon(
                  onPressed: _isSaving ? null : _submit,
                  icon: const Icon(Icons.save_rounded),
                  label: _isSaving
                      ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : const Text('Save Vitals Entry'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
