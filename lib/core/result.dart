library;

/// Functional Result type for MyHealth AI.
///
/// All repository and service methods return `Result<T, Failure>` instead of
/// throwing exceptions. This makes error states explicit and exhaustively
/// handled at compile time (flutter-dart-code-review §4: sealed types,
/// impossible states unrepresentable).


sealed class Result<T, E> {
  const Result();

  /// Pattern-match on success/failure.
  R when<R>({
    required R Function(T value) success,
    required R Function(E error) failure,
  });

  /// Transform the success value.
  Result<U, E> map<U>(U Function(T value) transform);

  /// Fold into a single value.
  R fold<R>(R Function(T value) onSuccess, R Function(E error) onFailure);

  /// True when holding a success value.
  bool get isSuccess;

  /// True when holding an error.
  bool get isFailure;

  /// Returns the success value if present, or null.
  T? get dataOrNull => isSuccess ? (this as Success<T, E>).value : null;

  /// Returns the success value if present, or throws.
  T get value => (this as Success<T, E>).value;
}

final class Success<T, E> extends Result<T, E> {
  const Success(this.value);

  @override
  final T value;

  @override
  bool get isSuccess => true;

  @override
  bool get isFailure => false;

  @override
  R when<R>({
    required R Function(T value) success,
    required R Function(E error) failure,
  }) =>
      success(value);

  @override
  Result<U, E> map<U>(U Function(T value) transform) =>
      Success<U, E>(transform(value));

  @override
  R fold<R>(R Function(T value) onSuccess, R Function(E error) onFailure) =>
      onSuccess(value);

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Success<T, E> && value == other.value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => 'Success($value)';
}

final class Failure<T, E> extends Result<T, E> {
  const Failure(this.error);

  final E error;

  @override
  bool get isSuccess => false;

  @override
  bool get isFailure => true;

  @override
  R when<R>({
    required R Function(T value) success,
    required R Function(E error) failure,
  }) =>
      failure(error);

  @override
  Result<U, E> map<U>(U Function(T value) transform) => Failure<U, E>(error);

  @override
  R fold<R>(R Function(T value) onSuccess, R Function(E error) onFailure) =>
      onFailure(error);

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Failure<T, E> && error == other.error;

  @override
  int get hashCode => error.hashCode;

  @override
  String toString() => 'Failure($error)';
}
