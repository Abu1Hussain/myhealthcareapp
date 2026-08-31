import 'package:flutter_test/flutter_test.dart';
import 'package:myhealth_ai/core/failures.dart';
import 'package:myhealth_ai/core/result.dart';
import 'package:myhealth_ai/core/utils/date_utils.dart';

void main() {
  group('Result<T, E> Functional Tests', () {
    test('Success should hold value and trigger when.success', () {
      const result = Success<int, AppFailure>(42);
      expect(result.isSuccess, isTrue);
      expect(result.isFailure, isFalse);
      expect(result.value, equals(42));

      final value = result.when(
        success: (v) => v * 2,
        failure: (e) => 0,
      );
      expect(value, equals(84));
    });

    test('Failure should hold error and trigger when.failure', () {
      const result = Failure<int, AppFailure>(
        DatabaseFailure(message: 'Record not found'),
      );
      expect(result.isSuccess, isFalse);
      expect(result.isFailure, isTrue);
      expect(result.error.message, equals('Record not found'));

      final value = result.when(
        success: (v) => 'Success',
        failure: (e) => e.message,
      );
      expect(value, equals('Record not found'));
    });
  });

  group('Clinical Date Utils Tests', () {
    test('formatClinicalDate should format correctly', () {
      final date = DateTime(2026, 8, 30);
      expect(formatClinicalDate(date), equals('30 Aug 2026'));
    });

    test('formatTime24h should format correctly with leading zeros', () {
      final date = DateTime(2026, 8, 30, 9, 5);
      expect(formatTime24h(date), equals('09:05'));
    });
  });
}
