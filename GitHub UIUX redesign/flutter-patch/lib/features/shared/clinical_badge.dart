library;

import 'package:flutter/material.dart';
import 'package:myhealth_ai/app/theme/app_colors.dart';
import 'package:myhealth_ai/app/theme/app_spacing.dart';
import 'package:myhealth_ai/domain/entities/models.dart';

/// Semantic badge tone.
///
/// Under Broadsheet only two tones carry a colour: [primary] and [ai] take
/// the cyan ramp, [critical] takes magenta. [success], [warning] and [info]
/// resolve to the neutral ramp — a completed appointment does not need to
/// compete with an alarm. The enum keeps all six members so existing call
/// sites compile unchanged.
enum ClinicalTone { success, warning, critical, info, primary, ai }

/// Status label for risk bands, appointment states and clinical categories.
///
/// A squared 2px tag, not a pill: the system's radius scale tops out at 4px.
/// Tint and text are taken as a 100/800 pair from one ramp, which clears
/// WCAG AA for 11px text in both themes without per-hue tuning.
class ClinicalBadge extends StatelessWidget {
  const ClinicalBadge({
    super.key,
    required this.label,
    this.backgroundColor,
    this.textColor,
    this.tone,
    this.icon,
    this.pulsing = false,
  });

  /// No-show risk. One tonal wedge — heavier means likelier to be missed.
  factory ClinicalBadge.riskBand(RiskBand band) {
    switch (band) {
      case RiskBand.low:
        return const ClinicalBadge(label: 'Low risk', tone: ClinicalTone.success);
      case RiskBand.medium:
        return const ClinicalBadge(label: 'Medium risk', tone: ClinicalTone.warning);
      case RiskBand.high:
        return const ClinicalBadge(label: 'High risk', tone: ClinicalTone.info);
    }
  }

  factory ClinicalBadge.appointmentStatus(AppointmentStatus status) {
    switch (status) {
      case AppointmentStatus.booked:
        return const ClinicalBadge(label: 'Booked');
      case AppointmentStatus.confirmed:
        return const ClinicalBadge(label: 'Confirmed');
      case AppointmentStatus.checkedIn:
        return const ClinicalBadge(label: 'Checked in', tone: ClinicalTone.primary);
      case AppointmentStatus.completed:
        return const ClinicalBadge(label: 'Completed');
      case AppointmentStatus.cancelled:
        return const ClinicalBadge(label: 'Cancelled');
      case AppointmentStatus.noShow:
        return const ClinicalBadge(label: 'No-show', tone: ClinicalTone.critical);
    }
  }

  factory ClinicalBadge.recordType(RecordType type) {
    switch (type) {
      case RecordType.visitNote:
      case RecordType.consultationNote:
        return const ClinicalBadge(label: 'Consultation');
      case RecordType.labResult:
      case RecordType.labReport:
        return const ClinicalBadge(label: 'Lab report');
      case RecordType.imaging:
      case RecordType.imagingReport:
        return const ClinicalBadge(label: 'Imaging');
      case RecordType.prescription:
        return const ClinicalBadge(label: 'Prescription');
      case RecordType.vaccination:
        return const ClinicalBadge(label: 'Vaccine');
      case RecordType.dischargeSummary:
        return const ClinicalBadge(label: 'Discharge');
      case RecordType.referral:
        return const ClinicalBadge(label: 'Referral');
    }
  }

  factory ClinicalBadge.taskStatus(TaskStatus status) {
    switch (status) {
      case TaskStatus.pending:
        return const ClinicalBadge(label: 'Pending', tone: ClinicalTone.primary);
      case TaskStatus.inProgress:
        return const ClinicalBadge(label: 'In progress', tone: ClinicalTone.primary);
      case TaskStatus.completed:
        return const ClinicalBadge(label: 'Completed');
      case TaskStatus.dismissed:
        return const ClinicalBadge(label: 'Dismissed');
    }
  }

  final String label;
  final Color? backgroundColor;
  final Color? textColor;
  final ClinicalTone? tone;
  final IconData? icon;
  final bool pulsing;

  static Color _toneText(ClinicalTone tone, bool isDark) {
    switch (tone) {
      case ClinicalTone.critical:
        return isDark ? AppColors.accent2300 : AppColors.accent2800;
      case ClinicalTone.primary:
      case ClinicalTone.ai:
        return isDark ? AppColors.accent300 : AppColors.accent800;
      case ClinicalTone.success:
      case ClinicalTone.warning:
      case ClinicalTone.info:
        return isDark ? AppColors.neutral300 : AppColors.neutral800;
    }
  }

  static Color _toneFill(ClinicalTone tone, bool isDark) {
    switch (tone) {
      case ClinicalTone.critical:
        return isDark ? AppColors.accent2900 : AppColors.accent2100;
      case ClinicalTone.primary:
      case ClinicalTone.ai:
        return isDark ? AppColors.accent900 : AppColors.accent100;
      case ClinicalTone.success:
      case ClinicalTone.warning:
      case ClinicalTone.info:
        return isDark ? AppColors.neutral900 : AppColors.neutral100;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final resolvedText = textColor ??
        (tone != null
            ? _toneText(tone!, isDark)
            : (isDark ? AppColors.neutral300 : AppColors.neutral800));
    final resolvedFill = backgroundColor ??
        (tone != null
            ? _toneFill(tone!, isDark)
            : (isDark ? AppColors.neutral900 : AppColors.neutral100));

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 3),
      decoration: BoxDecoration(
        color: resolvedFill,
        borderRadius: BorderRadius.circular(AppRadius.sm + 0.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (pulsing) ...[
            _PulsingDot(color: resolvedText),
            const SizedBox(width: 6),
          ] else if (icon != null) ...[
            Icon(icon, size: 12, color: resolvedText),
            const SizedBox(width: 5),
          ],
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: resolvedText,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.2,
                  height: 1.3,
                ),
          ),
        ],
      ),
    );
  }
}

/// The app's only perpetual animation. Reserved for a genuine critical flag.
class _PulsingDot extends StatefulWidget {
  const _PulsingDot({required this.color});
  final Color color;

  @override
  State<_PulsingDot> createState() => _PulsingDotState();
}

class _PulsingDotState extends State<_PulsingDot> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1900),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final curve = CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut);
    return FadeTransition(
      opacity: Tween<double>(begin: 0.35, end: 1.0).animate(curve),
      child: ScaleTransition(
        scale: Tween<double>(begin: 0.82, end: 1.0).animate(curve),
        child: Container(
          width: 7,
          height: 7,
          decoration: BoxDecoration(color: widget.color, shape: BoxShape.circle),
        ),
      ),
    );
  }
}
