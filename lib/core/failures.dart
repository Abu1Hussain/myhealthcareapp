library;

/// Standardized failure hierarchy for MyHealth AI.
///
/// Every failure carries a user-friendly [message] and an optional
/// [stackTrace] for debugging. Raw exceptions are mapped to these types
/// at repository boundaries — the UI never sees raw exception strings
/// (flutter-dart-code-review §12: graceful degradation).


sealed class AppFailure {
  const AppFailure({required this.message, this.stackTrace});

  /// User-friendly error description.
  final String message;

  /// Optional debug stack trace — never shown to users.
  final StackTrace? stackTrace;

  @override
  String toString() => '$runtimeType: $message';
}

// ── Database ──────────────────────────────────────────────────────────

final class DatabaseFailure extends AppFailure {
  const DatabaseFailure({required super.message, super.stackTrace});
}

// ── Authentication ────────────────────────────────────────────────────

final class AuthFailure extends AppFailure {
  const AuthFailure({required super.message, super.stackTrace});
}

final class InvalidCredentialsFailure extends AuthFailure {
  const InvalidCredentialsFailure()
      : super(message: 'Invalid email or password.');
}

final class UserNotFoundFailure extends AuthFailure {
  const UserNotFoundFailure()
      : super(message: 'No account found with this email.');
}

final class AccountDeactivatedFailure extends AuthFailure {
  const AccountDeactivatedFailure()
      : super(message: 'This account has been deactivated.');
}

// ── AI Service ────────────────────────────────────────────────────────

final class AiServiceFailure extends AppFailure {
  const AiServiceFailure({required super.message, super.stackTrace});
}

final class AiTimeoutFailure extends AiServiceFailure {
  const AiTimeoutFailure()
      : super(message: 'AI service timed out. Using cached results.');
}

final class AiParsingFailure extends AiServiceFailure {
  const AiParsingFailure()
      : super(message: 'AI returned an unexpected format. Falling back to mock.');
}

// ── Validation ────────────────────────────────────────────────────────

final class ValidationFailure extends AppFailure {
  const ValidationFailure({required super.message, super.stackTrace});
}

// ── Not Found ─────────────────────────────────────────────────────────

final class NotFoundFailure extends AppFailure {
  const NotFoundFailure({required super.message, super.stackTrace});
}

// ── File / PDF Extraction ─────────────────────────────────────────────

final class FileExtractionFailure extends AppFailure {
  const FileExtractionFailure({required super.message, super.stackTrace});
}

// ── Network ───────────────────────────────────────────────────────────

final class NetworkFailure extends AppFailure {
  const NetworkFailure({
    super.message = 'Network unavailable. Working offline.',
    super.stackTrace,
  });
}

// ── General / Unknown ──────────────────────────────────────────────────

final class GeneralFailure extends AppFailure {
  const GeneralFailure({required super.message, super.stackTrace});
}
