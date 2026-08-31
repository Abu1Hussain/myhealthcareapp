library;

import 'package:flutter/material.dart';
import 'package:myhealth_ai/app/theme/app_colors.dart';
import 'package:myhealth_ai/app/theme/app_spacing.dart';
import 'package:myhealth_ai/domain/entities/models.dart';

/// Pill status badge for risk bands, appointment states, and clinical categories.
class ClinicalBadge extends StatelessWidget {
  const ClinicalBadge({
    super.key,
    required this.label,
    required this.backgroundColor,
    required this.textColor,
    this.icon,
    this.pulsing = false,
  });

  factory ClinicalBadge.riskBand(RiskBand band) {
    switch (band) {
      case RiskBand.low:
        return const ClinicalBadge(
          label: 'Low Risk',
          backgroundColor: Color(0x2010B981),
          textColor: AppColors.riskLow,
          icon: Icons.shield_outlined,
        );
      case RiskBand.medium:
        return const ClinicalBadge(
          label: 'Medium Risk',
          backgroundColor: Color(0x20F59E0B),
          textColor: AppColors.riskMedium,
          icon: Icons.warning_amber_rounded,
        );
      case RiskBand.high:
        return const ClinicalBadge(
          label: 'High Risk',
          backgroundColor: Color(0x20EF4444),
          textColor: AppColors.riskHigh,
          icon: Icons.error_outline_rounded,
          pulsing: true,
        );
    }
  }

  factory ClinicalBadge.appointmentStatus(AppointmentStatus status) {
    switch (status) {
      case AppointmentStatus.booked:
        return const ClinicalBadge(
          label: 'Booked',
          backgroundColor: Color(0x203B82F6),
          textColor: AppColors.info,
        );
      case AppointmentStatus.confirmed:
        return const ClinicalBadge(
          label: 'Confirmed',
          backgroundColor: Color(0x2010B981),
          textColor: AppColors.success,
        );
      case AppointmentStatus.checkedIn:
        return const ClinicalBadge(
          label: 'Checked In',
          backgroundColor: Color(0x200D9488),
          textColor: AppColors.primaryTeal,
          icon: Icons.check_circle_outline_rounded,
        );
      case AppointmentStatus.completed:
        return const ClinicalBadge(
          label: 'Completed',
          backgroundColor: Color(0x2071717A),
          textColor: AppColors.textSecondaryLight,
        );
      case AppointmentStatus.cancelled:
        return const ClinicalBadge(
          label: 'Cancelled',
          backgroundColor: Color(0x20EF4444),
          textColor: AppColors.critical,
        );
      case AppointmentStatus.noShow:
        return const ClinicalBadge(
          label: 'No-Show',
          backgroundColor: Color(0x25EF4444),
          textColor: AppColors.critical,
          icon: Icons.person_off_outlined,
          pulsing: true,
        );
    }
  }

  factory ClinicalBadge.recordType(RecordType type) {
    switch (type) {
      case RecordType.visitNote:
      case RecordType.consultationNote:
        return const ClinicalBadge(
          label: 'Consultation',
          backgroundColor: Color(0x200D9488),
          textColor: AppColors.primaryTeal,
          icon: Icons.description_outlined,
        );
      case RecordType.labResult:
      case RecordType.labReport:
        return const ClinicalBadge(
          label: 'Lab Report',
          backgroundColor: Color(0x203B82F6),
          textColor: AppColors.info,
          icon: Icons.science_outlined,
        );
      case RecordType.imaging:
      case RecordType.imagingReport:
        return const ClinicalBadge(
          label: 'Imaging',
          backgroundColor: Color(0x208B5CF6),
          textColor: AppColors.aiAccent,
          icon: Icons.image_outlined,
        );
      case RecordType.prescription:
        return const ClinicalBadge(
          label: 'Prescription',
          backgroundColor: Color(0x2010B981),
          textColor: AppColors.success,
          icon: Icons.medication_outlined,
        );
      case RecordType.vaccination:
        return const ClinicalBadge(
          label: 'Vaccine',
          backgroundColor: Color(0x20F59E0B),
          textColor: AppColors.warning,
          icon: Icons.vaccines_outlined,
        );
      case RecordType.dischargeSummary:
        return const ClinicalBadge(
          label: 'Discharge',
          backgroundColor: Color(0x2071717A),
          textColor: AppColors.textSecondaryLight,
        );
      case RecordType.referral:
        return const ClinicalBadge(
          label: 'Referral',
          backgroundColor: Color(0x200D9488),
          textColor: AppColors.primaryTeal,
        );
    }
  }

  factory ClinicalBadge.taskStatus(TaskStatus status) {
    switch (status) {
      case TaskStatus.pending:
        return const ClinicalBadge(
          label: 'Pending',
          backgroundColor: Color(0x20F59E0B),
          textColor: AppColors.warning,
        );
      case TaskStatus.inProgress:
        return const ClinicalBadge(
          label: 'In Progress',
          backgroundColor: Color(0x203B82F6),
          textColor: AppColors.info,
        );
      case TaskStatus.completed:
        return const ClinicalBadge(
          label: 'Completed',
          backgroundColor: Color(0x2010B981),
          textColor: AppColors.success,
        );
      case TaskStatus.dismissed:
        return const ClinicalBadge(
          label: 'Dismissed',
          backgroundColor: Color(0x2071717A),
          textColor: AppColors.textSecondaryLight,
        );
    }
  }

  final String label;
  final Color backgroundColor;
  final Color textColor;
  final IconData? icon;
  final bool pulsing;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm + 4,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (pulsing) ...[
            _PulsingDot(color: textColor),
            const SizedBox(width: 5),
          ] else if (icon != null) ...[
            Icon(icon, size: 12, color: textColor),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              color: textColor,
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}

class _PulsingDot extends StatefulWidget {
  const _PulsingDot({required this.color});
  final Color color;

  @override
  State<_PulsingDot> createState() => _PulsingDotState();
}

class _PulsingDotState extends State<_PulsingDot> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1200),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: Tween<double>(begin: 0.35, end: 1.0).animate(
        CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
      ),
      child: Container(
        width: 6.5,
        height: 6.5,
        decoration: BoxDecoration(
          color: widget.color,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
