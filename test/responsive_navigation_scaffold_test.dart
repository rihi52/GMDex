import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gmdex/components/navigation_sidebar.dart';
import 'package:gmdex/components/responsive_layout.dart';

void main() {
  testWidgets('mobile platforms stay narrow at any width', (tester) async {
    expect(
      ResponsiveLayout.isWide(
        1400,
        breakpoint: ResponsiveBreakpoints.navigation,
      ),
      isFalse,
    );
    expect(
      ResponsiveLayout.isNarrow(
        1400,
        breakpoint: ResponsiveBreakpoints.navigation,
      ),
      isTrue,
    );
  }, variant: TargetPlatformVariant.mobile());
  testWidgets('desktop layouts follow the available width', (tester) async {
    expect(
      ResponsiveLayout.isWide(
        600,
        breakpoint: ResponsiveBreakpoints.navigation,
      ),
      isFalse,
    );
    expect(
      ResponsiveLayout.isWide(
        1400,
        breakpoint: ResponsiveBreakpoints.navigation,
      ),
      isTrue,
    );
  }, variant: TargetPlatformVariant.desktop());

  testWidgets('safe area is used for narrow content only', (tester) async {
    tester.view.physicalSize = const Size(600, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    const bodyKey = Key('responsive-body');
    await tester.pumpWidget(
      MaterialApp(
        home: ResponsiveNavigationScaffold(
          title: 'Players',
          items: const [],
          body: const Text('Content', key: bodyKey),
        ),
      ),
    );

    final narrowSafeArea = find.ancestor(
      of: find.byKey(bodyKey),
      matching: find.byType(SafeArea),
    );
    expect(narrowSafeArea, findsOneWidget);
    expect(tester.widget<SafeArea>(narrowSafeArea).bottom, isTrue);

    tester.view.physicalSize = const Size(800, 800);
    await tester.pumpWidget(
      MaterialApp(
        home: ResponsiveNavigationScaffold(
          title: 'Players',
          items: const [],
          body: const Text('Content', key: bodyKey),
        ),
      ),
    );

    expect(
      find.ancestor(of: find.byKey(bodyKey), matching: find.byType(SafeArea)),
      findsNothing,
    );
  }, variant: TargetPlatformVariant.desktop());

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
  }, variant: TargetPlatformVariant.desktop());

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
  }, variant: TargetPlatformVariant.desktop());
}
