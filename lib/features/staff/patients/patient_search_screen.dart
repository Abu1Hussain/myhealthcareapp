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
import 'package:myhealth_ai/features/shared/empty_state_widget.dart';
import 'package:myhealth_ai/features/shared/skeletal_shimmer.dart';
import 'package:myhealth_ai/features/staff/patients/patient_chart_screen.dart';

class PatientSearchScreen extends ConsumerStatefulWidget {
  const PatientSearchScreen({super.key});

  @override
  ConsumerState<PatientSearchScreen> createState() => _PatientSearchScreenState();
}

class _PatientSearchScreenState extends ConsumerState<PatientSearchScreen> {
  final _searchController = TextEditingController();
  String _selectedFilter = 'All';

  final List<String> _filters = [
    'All',
    'Type 2 Diabetes',
    'Hypertension',
    'Asthma',
    'Dyslipidemia',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final query = _searchController.text.trim();
    final searchFuture = ref.watch(userRepositoryProvider).searchPatients(query: query);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Patient Directory'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search Input & Condition Filter Chips
            Padding(
              padding: const EdgeInsets.all(AppSpacing.pagePadding),
              child: Column(
                children: [
                  TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search by name, CPR, or email...',
                      prefixIcon: const Icon(Icons.search_rounded),
                      suffixIcon: query.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear_rounded),
                              onPressed: () => setState(() => _searchController.clear()),
                            )
                          : null,
                    ),
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: _filters.map((filter) {
                        final isSelected = _selectedFilter == filter;
                        return Padding(
                          padding: const EdgeInsets.only(right: 6.0),
                          child: FilterChip(
                            label: Text(filter, style: const TextStyle(fontSize: 12)),
                            selected: isSelected,
                            onSelected: (_) => setState(() => _selectedFilter = filter),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: FutureBuilder(
                future: searchFuture,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pagePadding),
                      itemCount: 6,
                      itemBuilder: (_, __) => const Padding(
                        padding: EdgeInsets.only(bottom: AppSpacing.sm),
                        child: SkeletalShimmer(width: double.infinity, height: 75),
                      ),
                    );
                  }

                  var patients = snapshot.data!.fold((l) => l, (_) => <User>[]);

                  // Apply condition filter
                  if (_selectedFilter != 'All') {
                    patients = patients.where((p) {
                      final conditions = p.patientProfile?.chronicConditions ?? [];
                      return conditions.any((c) => c.toLowerCase().contains(_selectedFilter.toLowerCase()));
                    }).toList();
                  }

                  if (patients.isEmpty) {
                    return const EmptyStateWidget(
                      icon: Icons.person_search_rounded,
                      title: 'No Patients Found',
                      description: 'Try adjusting your search keywords or condition filter.',
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pagePadding),
                    itemCount: patients.length,
                    itemBuilder: (context, index) {
                      final patient = patients[index];
                      final conditions = patient.patientProfile?.chronicConditions ?? [];

                      return Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                        child: DoubleBezelCard(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => PatientChartScreen(patientId: patient.id),
                              ),
                            );
                          },
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: AppColors.primaryTeal.withValues(alpha: 0.15),
                                child: Text(
                                  patient.fullName.isNotEmpty ? patient.fullName[0] : 'P',
                                  style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryTeal),
                                ),
                              ),
                              const SizedBox(width: AppSpacing.md),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      patient.fullName,
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                    ),
                                    Text(
                                      '${patient.age} yrs • ${patient.gender == "M" ? "Male" : "Female"} • CPR: ${patient.nationalId}',
                                      style: TextStyle(color: context.textSecondary, fontSize: 12),
                                    ),
                                    if (conditions.isNotEmpty) ...[
                                      const SizedBox(height: 4),
                                      Wrap(
                                        spacing: 4,
                                        children: conditions.take(2).map((c) {
                                          return ClinicalBadge(
                                            label: c,
                                            backgroundColor: AppColors.primaryTeal.withValues(alpha: 0.1),
                                            textColor: AppColors.primaryTeal,
                                          );
                                        }).toList(),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                              Icon(Icons.chevron_right_rounded, color: context.textTertiary),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
