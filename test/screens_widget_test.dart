import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myhealth_ai/domain/entities/models.dart';
import 'package:myhealth_ai/features/shared/clinical_badge.dart';
import 'package:myhealth_ai/features/shared/double_bezel_card.dart';
import 'package:myhealth_ai/features/shared/empty_state_widget.dart';
import 'package:myhealth_ai/features/shared/safety_banner.dart';

void main() {
  group('Design System Widget Tests', () {
    testWidgets('DoubleBezelCard renders child with inner and outer structure', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: DoubleBezelCard(
              child: Text('Card Content Test'),
            ),
          ),
        ),
      );

      expect(find.text('Card Content Test'), findsOneWidget);
      expect(find.byType(DoubleBezelCard), findsOneWidget);
    });

    testWidgets('ClinicalBadge correctly renders label text', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                ClinicalBadge.riskBand(RiskBand.high),
                ClinicalBadge.appointmentStatus(AppointmentStatus.booked),
                ClinicalBadge.recordType(RecordType.consultationNote),
              ],
            ),
          ),
        ),
      );

      expect(find.text('High Risk'), findsOneWidget);
      expect(find.text('Booked'), findsOneWidget);
      expect(find.text('Consultation'), findsOneWidget);
    });

    testWidgets('SafetyBanner renders mandatory clinical AI disclaimer', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SafetyBanner(),
          ),
        ),
      );

      expect(find.textContaining('AI-generated — informational only'), findsOneWidget);
      expect(find.byIcon(Icons.auto_awesome_rounded), findsOneWidget);
    });

    testWidgets('EmptyStateWidget renders title, description and triggers action', (tester) async {
      bool actionTriggered = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EmptyStateWidget(
              icon: Icons.inbox_rounded,
              title: 'No Items Found',
              description: 'Please add a new item.',
              actionLabel: 'Add Item',
              onAction: () {
                actionTriggered = true;
              },
            ),
          ),
        ),
      );

      expect(find.text('No Items Found'), findsOneWidget);
      expect(find.text('Please add a new item.'), findsOneWidget);
      expect(find.text('Add Item'), findsOneWidget);

      await tester.tap(find.text('Add Item'));
      expect(actionTriggered, isTrue);
    });
  });
}
