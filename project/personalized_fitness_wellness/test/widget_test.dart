import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fitnest/main.dart';
import 'package:fitnest/data/fitness_store.dart';
import 'package:fitnest/ui/screens.dart';

void main() {
  FitnessStore fresh() =>
      FitnessStore(clock: () => DateTime(2026, 11, 5, 10))..seed();
  Future<void> launch(
    WidgetTester tester,
    FitnessStore store, {
    Size size = const Size(390, 844),
  }) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(FitNestApp(store: store));
    await tester.pumpAndSettle();
  }

  for (final width in [320.0, 390.0, 1200.0]) {
    testWidgets('all tabs render without overflow at $width pixels', (
      tester,
    ) async {
      await launch(tester, fresh(), size: Size(width, 900));
      for (final tab in [
        'Workouts',
        'Activity',
        'Progress',
        'Goals',
        'Overview',
      ]) {
        await tester.tap(find.text(tab).last);
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      }
    });
  }
  testWidgets(
    'activity form rejects blank and decimal integer fields then saves',
    (tester) async {
      final store = fresh();
      await launch(tester, store);
      await tester.tap(find.text('Activity').last);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Log activity'));
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('Save activity'));
      await tester.tap(find.text('Save activity'));
      await tester.pumpAndSettle();
      expect(find.text('Enter an activity name'), findsOneWidget);
      expect(store.minutes, 25);
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Activity name'),
        'Evening walk',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Duration (minutes)'),
        '1.0',
      );
      await tester.ensureVisible(find.text('Save activity'));
      await tester.tap(find.text('Save activity'));
      await tester.pumpAndSettle();
      expect(find.textContaining('whole number'), findsWidgets);
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Duration (minutes)'),
        '30',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Steps (0 if not applicable)'),
        '2500',
      );
      await tester.ensureVisible(find.text('Save activity'));
      await tester.tap(find.text('Save activity'));
      await tester.pumpAndSettle();
      expect(store.minutes, 55);
      expect(store.steps, 7740);
      expect(find.text('Evening walk'), findsOneWidget);
    },
  );
  testWidgets('complete checklist adds one workout and shows confirmation', (
    tester,
  ) async {
    final store = fresh();
    await tester.pumpWidget(
      MaterialApp(
        home: WorkoutDetail(store: store, workout: workouts.first),
      ),
    );
    await tester.pumpAndSettle();
    for (var i = 0; i < workouts.first.exercises.length; i++) {
      final checkbox = find.byType(CheckboxListTile).at(i);
      await tester.ensureVisible(checkbox);
      await tester.tap(checkbox);
      await tester.pumpAndSettle();
    }
    final finish = find.text('Finish workout (5/5)');
    await tester.ensureVisible(finish);
    await tester.tap(finish);
    await tester.pumpAndSettle();
    expect(
      find.text('Session completed! Your progress is updated.'),
      findsOneWidget,
    );
    expect(store.weeklyWorkouts, 4);
    store.complete(workouts.first);
    expect(store.weeklyWorkouts, 4);
  });
  testWidgets('goals validate zero and update displayed target', (
    tester,
  ) async {
    final store = fresh();
    await launch(tester, store);
    await tester.tap(find.text('Goals').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Edit goals'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Daily steps'),
      '0',
    );
    await tester.tap(find.text('Save goals'));
    await tester.pumpAndSettle();
    expect(find.textContaining('whole number'), findsOneWidget);
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Daily steps'),
      '6000',
    );
    await tester.tap(find.text('Save goals'));
    await tester.pumpAndSettle();
    expect(store.stepGoal, 6000);
    expect(find.text('5,240 / 6,000 steps'), findsOneWidget);
  });
  testWidgets('profile changes the recommended workout', (tester) async {
    final store = fresh();
    await launch(tester, store);
    await tester.tap(find.byTooltip('Edit profile'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Your name'),
      'Sagar',
    );
    await tester.tap(find.text('Stay active'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Build strength').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Save profile'));
    await tester.pumpAndSettle();
    expect(store.name, 'Sagar');
    expect(store.recommended.id, 'strength');
  });
}
