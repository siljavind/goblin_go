import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:goblin_go/main.dart';

//TODO: Rewrite test with actual content
void main() {
  testWidgets('Navigate by tapping icons', (tester) async {
    // Build the app
    await tester.pumpWidget(const GoblinGoApp());
    await tester.pumpAndSettle();

    // Tap the History icon
    await tester.tap(find.byIcon(Icons.calendar_today));
    await tester.pumpAndSettle();
    expect(find.text('History placeholder'), findsOneWidget);

    // Tap the Home icon
    await tester.tap(find.byIcon(Icons.home));
    await tester.pumpAndSettle();
    expect(find.text('Home placeholder'), findsOneWidget);

    // Tap the Settings icon
    await tester.tap(find.byIcon(Icons.settings));
    await tester.pumpAndSettle();
    expect(find.text('Settings'), findsOneWidget);
  });
}
