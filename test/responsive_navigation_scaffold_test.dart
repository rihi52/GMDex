import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gmdex/components/navigation_sidebar.dart';

void main() {
  testWidgets('narrow app bar shows and invokes the add action', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(600, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    var addPressed = false;
    await tester.pumpWidget(
      MaterialApp(
        home: ResponsiveNavigationScaffold(
          title: 'Players',
          items: const [],
          body: const SizedBox.shrink(),
          addTooltip: 'Create player',
          onAddPressed: () => addPressed = true,
        ),
      ),
    );

    final addButton = find.byTooltip('Create player');
    expect(addButton, findsOneWidget);
    await tester.tap(addButton);
    expect(addPressed, isTrue);
  });

  testWidgets('wide layout does not show the add action', (tester) async {
    tester.view.physicalSize = const Size(800, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        home: ResponsiveNavigationScaffold(
          title: 'Players',
          items: const [],
          body: const SizedBox.shrink(),
          addTooltip: 'Create player',
          onAddPressed: () {},
        ),
      ),
    );

    expect(find.byTooltip('Create player'), findsNothing);
  });

  testWidgets('settings is last in the narrow navigation drawer', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(600, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    var settingsReturned = false;
    await tester.pumpWidget(
      MaterialApp(
        home: ResponsiveNavigationScaffold(
          title: 'Players',
          items: const [NavigationSidebarItem(title: 'Browse')],
          body: const SizedBox.shrink(),
          onSettingsReturned: () async {
            settingsReturned = true;
          },
        ),
        routes: {
          '/settings': (context) =>
              const Scaffold(body: Text('Settings destination')),
        },
      ),
    );

    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pumpAndSettle();
    expect(find.text('Settings'), findsOneWidget);
    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();
    expect(find.text('Settings destination'), findsOneWidget);
    expect(settingsReturned, isFalse);
    Navigator.of(tester.element(find.text('Settings destination'))).pop();
    await tester.pumpAndSettle();
    expect(settingsReturned, isTrue);
  });

  testWidgets('settings is last in the wide navigation sidebar', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(800, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        home: ResponsiveNavigationScaffold(
          title: 'Players',
          items: const [NavigationSidebarItem(title: 'Browse')],
          body: const SizedBox.shrink(),
        ),
        routes: {
          '/settings': (context) =>
              const Scaffold(body: Text('Settings destination')),
        },
      ),
    );

    expect(find.text('Settings'), findsOneWidget);
    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();
    expect(find.text('Settings destination'), findsOneWidget);
  });
}
