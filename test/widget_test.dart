import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:civic_response_tracker/main.dart';

void main() {
  testWidgets('App loads smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const CivicResponseTrackerApp());

    // Verify that our title is present
    expect(find.text('Local Issues'), findsOneWidget);
  });
}
