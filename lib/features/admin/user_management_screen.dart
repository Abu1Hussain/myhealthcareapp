library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myhealth_ai/app/theme/app_colors.dart';
import 'package:myhealth_ai/app/theme/app_spacing.dart';
import 'package:myhealth_ai/app/theme/context_colors.dart';
import 'package:myhealth_ai/core/di.dart';
import 'package:myhealth_ai/domain/entities/models.dart';
import 'package:myhealth_ai/features/shared/clinical_badge.dart';
import 'package:myhealth_ai/features/shared/double_bezel_card.dart';
import 'package:myhealth_ai/features/shared/skeletal_shimmer.dart';
import 'package:myhealth_ai/features/shared/theme_toggle_button.dart';

class UserManagementScreen extends ConsumerStatefulWidget {
  const UserManagementScreen({super.key});

  @override
  ConsumerState<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends ConsumerState<UserManagementScreen> {
  void _openCreateStaffModal() {
    showDialog(
      context: context,
      builder: (_) => const _CreateStaffDialog(),
    ).then((val) {
      if (val == true) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final staffFuture = ref.watch(userRepositoryProvider).getStaffMembers();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Staff & User Management'),
        actions: [
          const ThemeToggleButton(),
          IconButton(
            icon: const Icon(Icons.person_add_rounded),
            tooltip: 'Add Staff Member',
            onPressed: _openCreateStaffModal,
          ),
        ],
      ),
      body: SafeArea(
        child: FutureBuilder(
          future: staffFuture,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return ListView.builder(
                padding: const EdgeInsets.all(AppSpacing.pagePadding),
                itemCount: 5,
                itemBuilder: (_, __) => const Padding(
                  padding: EdgeInsets.only(bottom: AppSpacing.sm),
                  child: SkeletalShimmer(width: double.infinity, height: 75),
                ),
              );
            }

            final staffList = snapshot.data!.fold((l) => l, (_) => <User>[]);

            return ListView.builder(
              padding: const EdgeInsets.all(AppSpacing.pagePadding),
              itemCount: staffList.length,
              itemBuilder: (context, index) {
                final user = staffList[index];
                final profile = user.staffProfile;

                return Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: DoubleBezelCard(
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: AppColors.primaryTeal.withValues(alpha: 0.15),
                          child: Text(
                            user.fullName.isNotEmpty ? user.fullName[0] : 'S',
                            style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryTeal),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(user.fullName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                              Text(
                                '${profile?.jobTitle ?? "Clinician"} • ${profile?.specialty ?? "General"}',
                                style: TextStyle(color: context.textSecondary, fontSize: 12),
                              ),
                              Text(
                                'Email: ${user.email} • License: ${profile?.licenseNo ?? "N/A"}',
                                style: TextStyle(color: context.textSecondary, fontSize: 11),
                              ),
                            ],
                          ),
                        ),
                        Switch(
                          value: user.isActive,
                          onChanged: (active) async {
                            await ref.read(userRepositoryProvider).toggleUserActive(user.id, active);
                            setState(() {});
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _CreateStaffDialog extends ConsumerStatefulWidget {
  const _CreateStaffDialog();

  @override
  ConsumerState<_CreateStaffDialog> createState() => _CreateStaffDialogState();
}

class _CreateStaffDialogState extends ConsumerState<_CreateStaffDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController(text: '+973 39000000');
  final _cprController = TextEditingController();
  final _jobTitleController = TextEditingController(text: 'Consultant Physician');
  final _specialtyController = TextEditingController(text: 'Internal Medicine');
  final _licenseController = TextEditingController();
  int _departmentId = 1;
  bool _isSaving = false;

  @override
  Widget build(BuildContext context) {
    final deptsFuture = ref.watch(userRepositoryProvider).getDepartments();

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
                      const Icon(Icons.person_add_rounded, color: AppColors.primaryTeal),
                      const SizedBox(width: 8),
                      const Text('Create Staff Account', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      const Spacer(),
                      IconButton(icon: const Icon(Icons.close_rounded), onPressed: () => Navigator.pop(context)),
                    ],
                  ),
                  const Divider(height: 20),
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'Full Name', hintText: 'Dr. Sarah Al-Mahmood'),
                    validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(labelText: 'Email Address', hintText: 'sarah.mahmood@health.gov.bh'),
                    validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _cprController,
                          decoration: const InputDecoration(labelText: 'National ID / CPR', hintText: '880123456'),
                          validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: TextFormField(
                          controller: _licenseController,
                          decoration: const InputDecoration(labelText: 'License No', hintText: 'NHRA-DOC-5542'),
                          validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  FutureBuilder(
                    future: deptsFuture,
                    builder: (context, snapshot) {
                      final depts = snapshot.data?.fold((l) => l, (_) => <Department>[]) ?? [];
                      return DropdownButtonFormField<int>(
                        value: _departmentId,
                        decoration: const InputDecoration(labelText: 'Assigned Department'),
                        items: depts.map((d) => DropdownMenuItem(value: d.id, child: Text(d.name))).toList(),
                        onChanged: (val) {
                          if (val != null) setState(() => _departmentId = val);
                        },
                      );
                    },
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                      const SizedBox(width: AppSpacing.md),
                      ElevatedButton(
                        onPressed: _isSaving
                            ? null
                            : () async {
                                if (!_formKey.currentState!.validate()) return;
                                setState(() => _isSaving = true);

                                final res = await ref.read(userRepositoryProvider).createStaff(
                                      fullName: _nameController.text.trim(),
                                      email: _emailController.text.trim(),
                                      password: 'Password@123',
                                      phone: _phoneController.text.trim(),
                                      dob: DateTime(1985, 5, 15),
                                      gender: 'F',
                                      nationalId: _cprController.text.trim(),
                                      departmentId: _departmentId,
                                      specialty: _specialtyController.text.trim(),
                                      licenseNo: _licenseController.text.trim(),
                                      jobTitle: _jobTitleController.text.trim(),
                                    );

                                res.fold(
                                  (_) => Navigator.pop(context, true),
                                  (f) {
                                    setState(() => _isSaving = false);
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${f.message}')));
                                  },
                                );
                              },
                        child: const Text('Create Staff'),
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
