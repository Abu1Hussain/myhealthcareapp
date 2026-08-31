library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myhealth_ai/domain/entities/models.dart';

/// The dependent a guardian is currently managing, or `null` when the
/// guardian is viewing their own record.
///
/// Every patient-scoped screen resolves the id it operates on via
/// [effectivePatientId] instead of reading `currentUser.id` directly, so
/// a guardian's actions — booking, logging vitals, reading the timeline,
/// editing settings — apply to whichever record is currently active:
/// their own, or a linked dependent's.
final managedDependentProvider = StateProvider<User?>((ref) => null);

int effectivePatientId(WidgetRef ref, User currentUser) {
  return ref.watch(managedDependentProvider)?.id ?? currentUser.id;
}

/// True when the guardian is currently acting on a dependent's record
/// rather than their own.
bool isManagingDependent(WidgetRef ref) => ref.watch(managedDependentProvider) != null;
