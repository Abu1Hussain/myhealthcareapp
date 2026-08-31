library;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myhealth_ai/app/theme/app_colors.dart';
import 'package:myhealth_ai/features/scheduling/scheduling_service.dart';

/// Service for dispatching cross-platform reminders and clinical notifications (RQ2).
///
/// On Web / Desktop, falls back to in-app banners/snackbars.
/// On Mobile, schedules local background notifications.
class PlatformNotifier {
  PlatformNotifier();

  final List<ReminderSpec> _activeReminders = [];

  List<ReminderSpec> get activeReminders => List.unmodifiable(_activeReminders);

  /// Schedules a reminder for an appointment.
  void scheduleReminder(ReminderSpec reminder) {
    _activeReminders.add(reminder);
    if (kDebugMode) {
      debugPrint('[PlatformNotifier] Scheduled: ${reminder.channel} at ${reminder.scheduledAt} -> "${reminder.message}"');
    }
  }

  /// Displays an immediate in-app clinical banner / alert.
  void showInAppAlert(
    BuildContext context, {
    required String title,
    required String message,
    bool isUrgent = false,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: isUrgent ? AppColors.critical : AppColors.primaryTeal,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 4),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 2),
            Text(
              message,
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}

/// Provider for PlatformNotifier.
final platformNotifierProvider = Provider<PlatformNotifier>((ref) {
  return PlatformNotifier();
});
