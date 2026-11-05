// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:gmdex/pages/home_page.dart';

void main() {
  testWidgets('home screen shows the main navigation actions', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: MyHomePage()));

    expect(find.text('Encounters'), findsOneWidget);
    expect(find.text('Players'), findsOneWidget);
    expect(find.text('Bestiary'), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);
  });
}
