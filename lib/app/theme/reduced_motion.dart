library;

import 'package:flutter/widgets.dart';

/// Checks if the operating system or user has requested reduced motion.
///
/// When true, animations should drop positional movement (`Transform.translate`,
/// large scale bounces) and either complete immediately or retain only gentle
/// opacity fades to ensure spatial comfort for users with vestibular needs.
bool shouldReduceMotion(BuildContext context) {
  return MediaQuery.maybeOf(context)?.disableAnimations ?? false;
}
