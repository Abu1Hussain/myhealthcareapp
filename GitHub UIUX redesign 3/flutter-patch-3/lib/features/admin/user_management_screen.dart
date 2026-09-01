library;

import 'dart:ui' show FontFeature;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myhealth_ai/app/theme/app_colors.dart';
import 'package:myhealth_ai/app/theme/app_spacing.dart';
import 'package:myhealth_ai/core/di.dart';
import 'package:myhealth_ai/domain/entities/models.dart';
import 'package:myhealth_ai/features/shared/broadsheet_bits.dart';
import 'package:myhealth_ai/features/shared/clinical_badge.dart';
import 'package:myhealth_ai/features/shared/skeletal_shimmer.dart';
import 'package:myhealth_ai/features/shared/theme_toggle_button.dart';

/// Accounts and access.
///
/// The old screen listed clinicians only, as a stack of bordered cards.
/// This is a table — the right shape for a roster you scan — and it adds
/// the patient lookup the repository already supported but nothing called.
class UserManagementScreen extends ConsumerStatefulWidget {
  const UserManagementScreen({super.key});

  @override
  ConsumerState<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends ConsumerState<UserManagementScreen> {
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openCreateStaff() {
    showDialog<bool>(
      context: context,
      builder: (_) => const _CreateStaffDialog(),
    ).then((created) {
      if (created == true && mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final searching = _query.trim().length >= 2;

    final staffFuture = ref.watch(userRepositoryProvider).getStaffMembers();
    final patientFuture = searching
        ? ref.watch(userRepositoryProvider).searchPatients(query: _query.trim())
        : null;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg, AppSpacing.md, AppSpacing.lg, AppSpacing.xxxl,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Masthead ────────────────────────────────────────────
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Eyebrow('Administration'),
                        const SizedBox(height: 6),
                        Text(
                          'Accounts and access',
                          style: theme.textTheme.displaySmall?.copyWith(
                            fontSize: 30,
                            letterSpacing: -1.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const ThemeToggleButton(),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      onChanged: (v) => setState(() => _query = v),
                      decoration: InputDecoration(
                        hintText: 'Find a patient by name or CPR',
                        prefixIcon: const Icon(Icons.search_rounded, size: 19),
                        suffixIcon: _query.isEmpty
                            ? null
                            : IconButton(
                                icon: const Icon(Icons.close_rounded, size: 18),
                                onPressed: () => setState(() {
                                  _searchController.clear();
                                  _query = '';
                                }),
                              ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  ElevatedButton(
                    onPressed: _openCreateStaff,
                    child: const Text('Add clinician'),
                  ),
                ],
              ),

              // ── Patient results, only while searching ───────────────
              if (patientFuture != null) ...[
                const SizedBox(height: AppSpacing.xl),
                FutureBuilder(
                  future: patientFuture,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const SkeletalShimmer(width: double.infinity, height: 64);
                    }
                    final patients = snapshot.data!.fold((l) => l, (_) => <User>[]);
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SectionHead(
                          title: 'Patients matching "${_query.trim()}"',
                          trailing: Text(
                            '${patients.length}',
                            style: theme.textTheme.labelSmall?.copyWith(
                              fontFeatures: const [FontFeature.tabularFigures()],
                            ),
                          ),
                        ),
                        if (patients.isEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: AppSpacing.md),
                            child: Text(
                              'No patient account matches that.',
                              style: theme.textTheme.bodyMedium,
                            ),
                          )
                        else
                          for (final p in patients)
                            _UserRow(
                              user: p,
                              roleLabel: 'Patient',
                              secondary: p.email,
                              identifier: p.nationalId,
                              onToggle: (active) async {
                                await ref
                                    .read(userRepositoryProvider)
                                    .toggleUserActive(p.id, active);
                                if (mounted) setState(() {});
                              },
                            ),
                      ],
                    );
                  },
                ),
              ],

              // ── Clinician roster ───────────────────────────────────
              const SizedBox(height: AppSpacing.xl),
              FutureBuilder(
                future: staffFuture,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SectionHead(title: 'Clinicians'),
                        const SizedBox(height: AppSpacing.md),
                        for (var i = 0; i < 5; i++)
                          const Padding(
                            padding: EdgeInsets.only(bottom: AppSpacing.sm),
                            child: SkeletalShimmer(width: double.infinity, height: 58),
                          ),
                      ],
                    );
                  }

                  final staff = snapshot.data!.fold((l) => l, (_) => <User>[]);
                  final active = staff.where((s) => s.isActive).length;
                  final departments = staff
                      .map((s) => s.staffProfile?.departmentName)
                      .whereType<String>()
                      .toSet();

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SectionHead(
                        title: 'Clinicians',
                        trailing: Text(
                          '$active of ${staff.length} active'
                          '${departments.isEmpty ? '' : ' · ${departments.length} departments'}',
                          style: theme.textTheme.labelSmall?.copyWith(
                            fontFeatures: const [FontFeature.tabularFigures()],
                          ),
                        ),
                      ),
                      for (final user in staff)
                        _UserRow(
                          user: user,
                          roleLabel: user.staffProfile?.jobTitle ?? 'Clinician',
                          secondary: user.staffProfile?.specialty ?? user.email,
                          identifier: user.staffProfile?.licenseNo ?? user.nationalId,
                          department: user.staffProfile?.departmentName,
                          onToggle: (isActive) async {
                            await ref
                                .read(userRepositoryProvider)
                                .toggleUserActive(user.id, isActive);
                            if (mounted) setState(() {});
                          },
                        ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _UserRow extends StatelessWidget {
  const _UserRow({
    required this.user,
    required this.roleLabel,
    required this.secondary,
    required this.identifier,
    required this.onToggle,
    this.department,
  });

  final User user;
  final String roleLabel;
  final String secondary;
  final String identifier;
  final String? department;
  final ValueChanged<bool> onToggle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            user.fullName,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        if (!user.isActive) ...[
                          const SizedBox(width: AppSpacing.sm),
                          const ClinicalBadge(label: 'Suspended'),
                        ],
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(secondary, style: theme.textTheme.bodySmall),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  department ?? roleLabel,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  identifier,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
              ),
              Switch(
                value: user.isActive,
                onChanged: onToggle,
                activeThumbColor: theme.brightness == Brightness.dark
                    ? AppColors.accent400
                    : AppColors.cyanInk,
              ),
            ],
          ),
        ),
        const RowRule(),
      ],
    );
  }
}

/// Create a clinician account. Same fields and same `createStaff` call as
/// before; the dialog is set as a form on the surface tint, and the licence
/// hint uses the MOH-BH format the seed data actually issues.
class _CreateStaffDialog extends ConsumerStatefulWidget {
  const _CreateStaffDialog();

  @override
  ConsumerState<_CreateStaffDialog> createState() => _CreateStaffDialogState();
}

class _CreateStaffDialogState extends ConsumerState<_CreateStaffDialog> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController(text: '+973 3900 0000');
  final _cpr = TextEditingController();
  final _jobTitle = TextEditingController(text: 'Consultant Physician');
  final _specialty = TextEditingController(text: 'Internal Medicine');
  final _license = TextEditingController();
  int? _departmentId;
  bool _saving = false;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _phone.dispose();
    _cpr.dispose();
    _jobTitle.dispose();
    _specialty.dispose();
    _license.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_departmentId == null) return;

    setState(() => _saving = true);

    final result = await ref.read(userRepositoryProvider).createStaff(
          fullName: _name.text.trim(),
          email: _email.text.trim(),
          password: 'Password@123',
          phone: _phone.text.trim(),
          dob: DateTime(1985, 5, 15),
          gender: 'F',
          nationalId: _cpr.text.trim(),
          departmentId: _departmentId!,
          specialty: _specialty.text.trim(),
          licenseNo: _license.text.trim(),
          jobTitle: _jobTitle.text.trim(),
        );

    if (!mounted) return;

    result.fold(
      (_) => Navigator.pop(context, true),
      (failure) {
        setState(() => _saving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not create the account: ${failure.message}')),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 540),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'New clinician account',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontSize: 22,
                            letterSpacing: -0.4,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close_rounded, size: 20),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  Text(
                    'The account is created with a temporary password the '
                    'clinician must change at first sign-in.',
                    style: theme.textTheme.bodySmall,
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  _Label('Full name'),
                  TextFormField(
                    controller: _name,
                    decoration: const InputDecoration(hintText: 'Dr. Maryam Janahi'),
                    validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
                  ),
                  const SizedBox(height: AppSpacing.md),

                  _Label('Email address'),
                  TextFormField(
                    controller: _email,
                    decoration: const InputDecoration(
                      hintText: 'maryam.janahi@myhealth.uob',
                    ),
                    validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
                  ),
                  const SizedBox(height: AppSpacing.md),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _Label('CPR'),
                            TextFormField(
                              controller: _cpr,
                              decoration: const InputDecoration(hintText: '880123456'),
                              validator: (v) =>
                                  (v == null || v.isEmpty) ? 'Required' : null,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _Label('Licence number'),
                            TextFormField(
                              controller: _license,
                              decoration:
                                  const InputDecoration(hintText: 'MOH-BH-30999'),
                              validator: (v) =>
                                  (v == null || v.isEmpty) ? 'Required' : null,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),

                  _Label('Job title'),
                  TextFormField(controller: _jobTitle),
                  const SizedBox(height: AppSpacing.md),

                  _Label('Specialty'),
                  TextFormField(controller: _specialty),
                  const SizedBox(height: AppSpacing.md),

                  _Label('Department'),
                  FutureBuilder(
                    future: ref.read(userRepositoryProvider).getDepartments(),
                    builder: (context, snapshot) {
                      final depts =
                          snapshot.data?.fold((l) => l, (_) => <Department>[]) ??
                              <Department>[];
                      if (depts.isNotEmpty && _departmentId == null) {
                        _departmentId = depts.first.id;
                      }
                      return DropdownButtonFormField<int>(
                        initialValue: _departmentId,
                        items: depts
                            .map((d) => DropdownMenuItem(
                                  value: d.id,
                                  child: Text(d.name),
                                ))
                            .toList(),
                        onChanged: (v) => setState(() => _departmentId = v),
                        validator: (v) => v == null ? 'Pick a department' : null,
                      );
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
                      const SizedBox(width: AppSpacing.sm),
                      ElevatedButton(
                        onPressed: _saving ? null : _save,
                        child: Text(_saving ? 'Creating…' : 'Create account'),
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

class _Label extends StatelessWidget {
  const _Label(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Text(text, style: Theme.of(context).textTheme.labelMedium),
    );
  }
}
