library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myhealth_ai/app/theme/app_colors.dart';
import 'package:myhealth_ai/app/theme/app_spacing.dart';
import 'package:myhealth_ai/core/di.dart';
import 'package:myhealth_ai/domain/entities/models.dart';
import 'package:myhealth_ai/features/auth/auth_controller.dart';

/// Modal dialog for clinical staff to document an encounter note and record lab values.
class ClinicalNoteDialog extends ConsumerStatefulWidget {
  const ClinicalNoteDialog({
    super.key,
    required this.patientId,
    required this.patientName,
  });

  final int patientId;
  final String patientName;

  @override
  ConsumerState<ClinicalNoteDialog> createState() => _ClinicalNoteDialogState();
}

class _ClinicalNoteDialogState extends ConsumerState<ClinicalNoteDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  RecordType _recordType = RecordType.consultationNote;
  bool _isSaving = false;

  // Optional Lab Values
  final List<Map<String, dynamic>> _labs = [];
  final _analyteController = TextEditingController();
  final _valController = TextEditingController();
  final _unitController = TextEditingController(text: 'mg/dL');

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    _analyteController.dispose();
    _valController.dispose();
    _unitController.dispose();
    super.dispose();
  }

  void _addLabValue() {
    final analyte = _analyteController.text.trim();
    final val = double.tryParse(_valController.text.trim());
    final unit = _unitController.text.trim();

    if (analyte.isNotEmpty && val != null) {
      setState(() {
        _labs.add({
          'analyte': analyte,
          'value': val,
          'unit': unit,
        });
        _analyteController.clear();
        _valController.clear();
      });
    }
  }

  Future<void> _saveNote() async {
    if (!_formKey.currentState!.validate()) return;
    final staff = ref.read(currentUserProvider);
    if (staff == null) return;

    setState(() => _isSaving = true);

    final labEntities = _labs.map((l) {
      return LabValue(
        id: 0,
        recordId: 0,
        analyte: l['analyte'] as String,
        value: l['value'] as double,
        unit: l['unit'] as String,
        refLow: 0,
        refHigh: 100,
        abnormalFlag: false,
      );
    }).toList();

    final result = await ref.read(recordRepositoryProvider).addClinicalNote(
          patientId: widget.patientId,
          authorStaffId: staff.id,
          recordType: _recordType,
          title: _titleController.text.trim(),
          body: _bodyController.text.trim(),
          occurredAt: DateTime.now(),
          sourceFacility: 'Salmaniya Medical Complex',
          labValues: labEntities,
        );

    // Scan for potential abnormal lab triggers
    if (labEntities.isNotEmpty) {
      await ref.read(riskDetectionServiceProvider).scanLabValues(
            patientId: widget.patientId,
            labs: labEntities,
            primaryStaffId: staff.id,
          );
    }

    result.fold(
      (record) {
        Navigator.of(context).pop(true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Clinical note saved successfully.')),
        );
      },
      (failure) {
        setState(() => _isSaving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving note: ${failure.message}')),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.lg)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600, maxHeight: 750),
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
                      const Icon(Icons.note_add_rounded, color: AppColors.primaryTeal),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Add Clinical Note • ${widget.patientName}',
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

                  // Note Type Selector
                  DropdownButtonFormField<RecordType>(
                    initialValue: _recordType,
                    decoration: const InputDecoration(labelText: 'Encounter Type'),
                    items: const [
                      DropdownMenuItem(
                        value: RecordType.consultationNote,
                        child: Text('Consultation Encounter Note'),
                      ),
                      DropdownMenuItem(
                        value: RecordType.labReport,
                        child: Text('Laboratory Diagnostic Report'),
                      ),
                      DropdownMenuItem(
                        value: RecordType.dischargeSummary,
                        child: Text('Discharge Summary'),
                      ),
                      DropdownMenuItem(
                        value: RecordType.imagingReport,
                        child: Text('Imaging / Radiology Report'),
                      ),
                    ],
                    onChanged: (val) {
                      if (val != null) setState(() => _recordType = val);
                    },
                  ),
                  const SizedBox(height: AppSpacing.md),

                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: 'Encounter Title / Chief Complaint',
                      hintText: 'e.g. Type 2 Diabetes Routine Review',
                    ),
                    validator: (v) => (v == null || v.trim().isEmpty) ? 'Please enter a title' : null,
                  ),
                  const SizedBox(height: AppSpacing.md),

                  TextFormField(
                    controller: _bodyController,
                    decoration: const InputDecoration(
                      labelText: 'Clinical Notes / SOAP Documentation',
                      hintText: 'Subjective: Patient reports...\nObjective: Vitals stable...\nAssessment: Controlled T2D...\nPlan: Continue current regimen...',
                    ),
                    maxLines: 6,
                    validator: (v) => (v == null || v.trim().isEmpty) ? 'Please enter clinical notes' : null,
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // Optional Lab Values Section
                  Text(
                    'Attach Diagnostic Lab Values (Optional)',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: AppSpacing.sm),

                  Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: TextFormField(
                          controller: _analyteController,
                          decoration: const InputDecoration(labelText: 'Analyte', hintText: 'HbA1c, Glucose, etc.'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        flex: 2,
                        child: TextFormField(
                          controller: _valController,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          decoration: const InputDecoration(labelText: 'Value', hintText: '7.2'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        flex: 2,
                        child: TextFormField(
                          controller: _unitController,
                          decoration: const InputDecoration(labelText: 'Unit', hintText: '% or mg/dL'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton.filledTonal(
                        onPressed: _addLabValue,
                        icon: const Icon(Icons.add_rounded),
                        tooltip: 'Add Lab Value',
                      ),
                    ],
                  ),

                  if (_labs.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.sm),
                    Wrap(
                      spacing: 8,
                      children: _labs.map((lab) {
                        return Chip(
                          label: Text('${lab['analyte']}: ${lab['value']} ${lab['unit']}'),
                          onDeleted: () => setState(() => _labs.remove(lab)),
                        );
                      }).toList(),
                    ),
                  ],

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
                        onPressed: _isSaving ? null : _saveNote,
                        icon: const Icon(Icons.check_rounded),
                        label: _isSaving
                            ? const SizedBox(
                                height: 16,
                                width: 16,
                                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                              )
                            : const Text('Save Note'),
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
