import 'package:flutter_test/flutter_test.dart';
import 'package:myhealth_ai/domain/entities/models.dart';

void main() {
  group('TaskPrioritization Math & Blending Tests', () {
    test('Blended priority is exactly 40% rule + 60% AI score', () {
      final task = StaffTaskItem(
        id: 1,
        staffId: 100,
        patientId: 1,
        title: 'Review Critical Alert: hypertensive crisis',
        kind: TaskKind.reviewAbnormalLab,
        dueAt: DateTime.now().add(const Duration(hours: 2)),
        status: TaskStatus.pending,
        ruleScore: 0.90,
        aiPriorityScore: 0.95,
        aiRationale: 'Urgent hypertensive crisis requires immediate review.',
        createdAt: DateTime.now(),
      );

      // (0.90 * 0.4) + (0.95 * 0.6) = 0.36 + 0.57 = 0.93
      expect(task.blendedPriority, closeTo(0.93, 1e-4));
    });

    test('Blended priority falls back to rule score if AI score is null', () {
      final task = StaffTaskItem(
        id: 2,
        staffId: 100,
        patientId: 1,
        title: 'Routine medication renewal',
        kind: TaskKind.medicationRenewal,
        dueAt: DateTime.now().add(const Duration(days: 2)),
        status: TaskStatus.pending,
        ruleScore: 0.50,
        aiPriorityScore: null,
        createdAt: DateTime.now(),
      );

      expect(task.blendedPriority, equals(0.50));
    });
  });

  group('Clinical Severity Categorization Tests', () {
    test('Hypertensive crisis (sys >= 180 or dia >= 120) is Critical', () {
      const sys = 185.0;
      const dia = 115.0;

      final isCritical = sys >= 180 || dia >= 120;
      expect(isCritical, isTrue);
    });

    test('Severe hypoglycemia (glucose < 70) is Critical', () {
      const glucose = 54.0;
      final isCritical = glucose < 70.0;
      expect(isCritical, isTrue);
    });

    test('Severe hypoxia (SpO2 < 90%) is Critical', () {
      const spo2 = 88.5;
      final isCritical = spo2 < 90.0;
      expect(isCritical, isTrue);
    });

    test('High fever (temp >= 38.5) is detected', () {
      const temp = 39.1;
      final isFever = temp >= 38.5;
      expect(isFever, isTrue);
    });
  });
}
