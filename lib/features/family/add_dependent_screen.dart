library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myhealth_ai/app/theme/app_colors.dart';
import 'package:myhealth_ai/app/theme/app_spacing.dart';
import 'package:myhealth_ai/core/di.dart';
import 'package:myhealth_ai/features/auth/auth_controller.dart';
import 'package:myhealth_ai/features/family/family_link_store.dart';
import 'package:myhealth_ai/features/shared/double_bezel_card.dart';
import 'package:myhealth_ai/services/auth/password_hasher.dart';

/// Lets a guardian add a family member (most commonly a child) as a full
/// patient record they manage. The dependent gets a real
/// `Users`/`PatientProfiles` row — so every existing patient screen
/// (timeline, vitals, booking…) works for them unmodified — but a
/// system-generated login they never see or use; only the guardian
/// account, once linked via [FamilyLinkStore], can act on it.
class AddDependentScreen extends ConsumerStatefulWidget {
  const AddDependentScreen({super.key});

  @override
  ConsumerState<AddDependentScreen> createState() => _AddDependentScreenState();
}

class _AddDependentScreenState extends ConsumerState<AddDependentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _cprController = TextEditingController();
  final _phoneController = TextEditingController();
  final _allergiesController = TextEditingController();
  final _conditionsController = TextEditingController();
  final _emergencyContactController = TextEditingController();

  FamilyRelationship _relationship = FamilyRelationship.child;
  String _gender = 'M';
  String _bloodType = 'O+';
  DateTime _dob = DateTime(DateTime.now().year - 8, 1, 1);
  bool _isSaving = false;
  String? _error;

  @override
  void dispose() {
    _nameController.dispose();
    _cprController.dispose();
    _phoneController.dispose();
    _allergiesController.dispose();
    _conditionsController.dispose();
    _emergencyContactController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final guardian = ref.read(currentUserProvider);
    if (guardian == null) return;

    setState(() {
      _isSaving = true;
      _error = null;
    });

    final placeholderEmail =
        'dependent.${DateTime.now().millisecondsSinceEpoch}.${_cprController.text.trim()}@myhealth.local';
    final systemPassword = PasswordHasher.generateSalt(24);

    final result = await ref.read(authRepositoryProvider).registerPatient(
          fullName: _nameController.text.trim(),
          email: placeholderEmail,
          password: systemPassword,
          phone: _phoneController.text.trim().isEmpty ? guardian.phone : _phoneController.text.trim(),
          dob: _dob,
          gender: _gender,
          nationalId: _cprController.text.trim(),
          bloodType: _bloodType,
          allergies: _allergiesController.text.trim().isEmpty
              ? []
              : _allergiesController.text.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList(),
          chronicConditions: _conditionsController.text.trim().isEmpty
              ? []
              : _conditionsController.text.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList(),
          emergencyContact:
              _emergencyContactController.text.trim().isEmpty ? guardian.fullName : _emergencyContactController.text.trim(),
        );

    await result.fold(
      (dependent) async {
        await FamilyLinkStore.addLink(
          guardianUserId: guardian.id,
          dependentUserId: dependent.id,
          relationship: _relationship,
        );
        if (mounted) Navigator.of(context).pop(true);
      },
      (failure) async {
        setState(() {
          _isSaving = false;
          _error = failure.message;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Family Member')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.pagePadding),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 540),
              child: DoubleBezelCard(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'You will manage this person\'s full health record — appointments, vitals, medications, and settings — until they create their own account.',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  if (_error != null) ...[
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color: AppColors.critical.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(AppRadius.md),
                        border: Border.all(color: AppColors.critical.withValues(alpha: 0.3)),
                      ),
                      child: Text(_error!, style: const TextStyle(color: AppColors.critical, fontSize: 13)),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                  ],

                  DropdownButtonFormField<FamilyRelationship>(
                    value: _relationship,
                    decoration: const InputDecoration(labelText: 'Relationship'),
                    items: FamilyRelationship.values
                        .map((r) => DropdownMenuItem(value: r, child: Text(r.label)))
                        .toList(),
                    onChanged: (v) => setState(() => _relationship = v ?? _relationship),
                  ),
                  const SizedBox(height: AppSpacing.md),

                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Full Name',
                      prefixIcon: Icon(Icons.person_outline_rounded, size: 20),
                    ),
                    validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: AppSpacing.md),

                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _cprController,
                          decoration: const InputDecoration(
                            labelText: 'CPR / National ID',
                            prefixIcon: Icon(Icons.badge_outlined, size: 20),
                          ),
                          validator: (v) => v == null || v.trim().length < 8 ? 'Valid CPR required' : null,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: _gender,
                          decoration: const InputDecoration(labelText: 'Gender'),
                          items: const [
                            DropdownMenuItem(value: 'M', child: Text('Male')),
                            DropdownMenuItem(value: 'F', child: Text('Female')),
                          ],
                          onChanged: (v) => setState(() => _gender = v ?? _gender),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),

                  InkWell(
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: _dob,
                        firstDate: DateTime(1920),
                        lastDate: DateTime.now(),
                      );
                      if (picked != null) setState(() => _dob = picked);
                    },
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'Date of Birth',
                        prefixIcon: Icon(Icons.cake_outlined, size: 20),
                      ),
                      child: Text('${_dob.day}/${_dob.month}/${_dob.year}'),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),

                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: _bloodType,
                          decoration: const InputDecoration(labelText: 'Blood Type'),
                          items: ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-']
                              .map((b) => DropdownMenuItem(value: b, child: Text(b)))
                              .toList(),
                          onChanged: (v) => setState(() => _bloodType = v ?? _bloodType),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: TextFormField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          decoration: const InputDecoration(labelText: 'Phone (optional)'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),

                  TextFormField(
                    controller: _conditionsController,
                    decoration: const InputDecoration(
                      labelText: 'Chronic Conditions (comma separated)',
                      prefixIcon: Icon(Icons.healing_outlined, size: 20),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  TextFormField(
                    controller: _allergiesController,
                    decoration: const InputDecoration(
                      labelText: 'Allergies (comma separated)',
                      prefixIcon: Icon(Icons.warning_amber_rounded, size: 20),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  TextFormField(
                    controller: _emergencyContactController,
                    decoration: const InputDecoration(
                      labelText: 'Emergency Contact (optional — defaults to you)',
                      prefixIcon: Icon(Icons.emergency_outlined, size: 20),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),

                  ElevatedButton(
                    onPressed: _isSaving ? null : _submit,
                    child: _isSaving
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          )
                        : const Text('Add Family Member'),
                  ),
                ],
              ),
            ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
