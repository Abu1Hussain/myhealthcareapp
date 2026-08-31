library;

import 'package:flutter/material.dart';
import 'package:myhealth_ai/app/theme/app_spacing.dart';
import 'package:myhealth_ai/app/theme/context_colors.dart';
import 'package:myhealth_ai/services/clinical/appointment_triage_service.dart';

/// Compact green/orange/red key explaining the appointment urgency
/// stripe, shown once above a list of appointment cards.
class UrgencyLegend extends StatelessWidget {
  const UrgencyLegend({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.lg,
      runSpacing: 4,
      children: AppointmentUrgency.values.map((u) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(color: u.accentColor, shape: BoxShape.circle),
            ),
            const SizedBox(width: 6),
            Text(
              u.label,
              style: TextStyle(fontSize: 11.5, color: context.textSecondary, fontWeight: FontWeight.w500),
            ),
          ],
        );
      }).toList(),
    );
  }
}
