library;

import 'package:flutter/material.dart';
import 'package:myhealth_ai/app/theme/app_colors.dart';
import 'package:myhealth_ai/app/theme/app_spacing.dart';
import 'package:myhealth_ai/domain/entities/models.dart';

/// Semantic badge tone. Resolved to a concrete text color at build time
/// against [Theme.brightness] — small (11px) badge text needs a real WCAG
/// AA ratio (>=4.5:1) against the tint it actually renders on, and that
/// ratio requires a *different* shade in light vs. dark mode (darken for
/// light tints, lighten for dark tints — a single fixed color can't hit
/// AA in both). See AppColors' "Badge text-on-tint" section for the
/// verified pairs.
enum ClinicalTone { success, warning, critical, info, primary, ai }

/// Pill status badge for risk bands, appointment states, and clinical categories.
///
/// [backgroundColor]/[textColor] are optional — when omitted the badge
/// resolves a neutral, theme-adaptive gray at build time instead of a
/// hardcoded light-mode color, so "neutral" badges (Completed, Dismissed,
/// Discharge…) still read correctly in dark mode. Prefer [tone] over a
/// hardcoded [textColor] for semantic (success/warning/critical/…) badges
/// so the text stays AA-compliant in both themes.
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

  factory ClinicalBadge.riskBand(RiskBand band) {
    switch (band) {
      case RiskBand.low:
        return const ClinicalBadge(
          label: 'Low Risk',
          backgroundColor: Color(0x2010B981),
          tone: ClinicalTone.success,
          icon: Icons.shield_outlined,
        );
      case RiskBand.medium:
        return const ClinicalBadge(
          label: 'Medium Risk',
          backgroundColor: Color(0x20F59E0B),
          tone: ClinicalTone.warning,
          icon: Icons.warning_amber_rounded,
        );
      case RiskBand.high:
        return const ClinicalBadge(
          label: 'High Risk',
          backgroundColor: Color(0x20EF4444),
          tone: ClinicalTone.critical,
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
          tone: ClinicalTone.info,
        );
      case AppointmentStatus.confirmed:
        return const ClinicalBadge(
          label: 'Confirmed',
          backgroundColor: Color(0x2010B981),
          tone: ClinicalTone.success,
        );
      case AppointmentStatus.checkedIn:
        return const ClinicalBadge(
          label: 'Checked In',
          backgroundColor: Color(0x200D9488),
          tone: ClinicalTone.primary,
          icon: Icons.check_circle_outline_rounded,
        );
      case AppointmentStatus.completed:
        return const ClinicalBadge(label: 'Completed');
      case AppointmentStatus.cancelled:
        return const ClinicalBadge(
          label: 'Cancelled',
          backgroundColor: Color(0x20EF4444),
          tone: ClinicalTone.critical,
        );
      case AppointmentStatus.noShow:
        return const ClinicalBadge(
          label: 'No-Show',
          backgroundColor: Color(0x25EF4444),
          tone: ClinicalTone.critical,
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
          tone: ClinicalTone.primary,
          icon: Icons.description_outlined,
        );
      case RecordType.labResult:
      case RecordType.labReport:
        return const ClinicalBadge(
          label: 'Lab Report',
          backgroundColor: Color(0x203B82F6),
          tone: ClinicalTone.info,
          icon: Icons.science_outlined,
        );
      case RecordType.imaging:
      case RecordType.imagingReport:
        return const ClinicalBadge(
          label: 'Imaging',
          backgroundColor: Color(0x208B5CF6),
          tone: ClinicalTone.ai,
          icon: Icons.image_outlined,
        );
      case RecordType.prescription:
        return const ClinicalBadge(
          label: 'Prescription',
          backgroundColor: Color(0x2010B981),
          tone: ClinicalTone.success,
          icon: Icons.medication_outlined,
        );
      case RecordType.vaccination:
        return const ClinicalBadge(
          label: 'Vaccine',
          backgroundColor: Color(0x20F59E0B),
          tone: ClinicalTone.warning,
          icon: Icons.vaccines_outlined,
        );
      case RecordType.dischargeSummary:
        return const ClinicalBadge(label: 'Discharge');
      case RecordType.referral:
        return const ClinicalBadge(
          label: 'Referral',
          backgroundColor: Color(0x200D9488),
          tone: ClinicalTone.primary,
        );
    }
  }

  factory ClinicalBadge.taskStatus(TaskStatus status) {
    switch (status) {
      case TaskStatus.pending:
        return const ClinicalBadge(
          label: 'Pending',
          backgroundColor: Color(0x20F59E0B),
          tone: ClinicalTone.warning,
        );
      case TaskStatus.inProgress:
        return const ClinicalBadge(
          label: 'In Progress',
          backgroundColor: Color(0x203B82F6),
          tone: ClinicalTone.info,
        );
      case TaskStatus.completed:
        return const ClinicalBadge(
          label: 'Completed',
          backgroundColor: Color(0x2010B981),
          tone: ClinicalTone.success,
        );
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

  static Color _toneTextColor(ClinicalTone tone, bool isDark) {
    switch (tone) {
      case ClinicalTone.success:
        return isDark ? AppColors.successTextDark : AppColors.successTextLight;
      case ClinicalTone.warning:
        return isDark ? AppColors.warningTextDark : AppColors.warningTextLight;
      case ClinicalTone.critical:
        return isDark ? AppColors.criticalTextDark : AppColors.criticalTextLight;
      case ClinicalTone.info:
        return isDark ? AppColors.infoTextDark : AppColors.infoTextLight;
      case ClinicalTone.primary:
        return isDark ? AppColors.primaryTextDark : AppColors.primaryTextLight;
      case ClinicalTone.ai:
        return isDark ? AppColors.aiTextDark : AppColors.aiTextLight;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final resolvedText = textColor ??
        (tone != null ? _toneTextColor(tone!, isDark) : Theme.of(context).colorScheme.onSurfaceVariant);
    final resolvedBackground =
        backgroundColor ?? Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.12);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm + 4,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: resolvedBackground,
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (pulsing) ...[
            _PulsingDot(color: resolvedText),
            const SizedBox(width: 5),
          ] else if (icon != null) ...[
            Icon(icon, size: 12, color: resolvedText),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              color: resolvedText,
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
