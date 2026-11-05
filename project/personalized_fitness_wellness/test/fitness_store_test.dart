import 'package:flutter_test/flutter_test.dart';
import 'package:fitnest/data/fitness_store.dart';

void main() {
  test('entries and goals survive serialization and reload', () async {
    String? saved;
    final store = FitnessStore(
      persist: (raw) async => saved = raw,
      clock: () => DateTime(2026, 11, 5, 10),
    );
    store.seed();
    store.stepGoal = 9000;
    store.addWater();
    await store.saved;
    final restored = FitnessStore(clock: store.clock)..restore(saved!);
    expect(restored.steps, 5240);
    expect(restored.water, 5);
    expect(restored.stepGoal, 9000);
    expect(restored.entries.length, store.entries.length);
  });
  test(
    'daily totals roll over and last seven days exclude older entries',
    () async {
      var now = DateTime(2026, 11, 5, 10);
      final store = FitnessStore(clock: () => now)..seed();
      await store.saved;
      expect(store.activeDays, 7);
      now = DateTime(2026, 11, 6, 10);
      expect(store.steps, 0);
      expect(store.water, 0);
      expect(store.activeDays, 6);
      now = DateTime(2026, 11, 13);
      expect(store.weeklyWorkouts, 0);
    },
  );
  test('delete and clear recalculate all totals', () async {
    final store = FitnessStore(clock: () => DateTime(2026, 11, 5, 10))..seed();
    store.remove('sample-walk-0');
    expect(store.steps, 0);
    expect(store.minutes, 0);
    store.clear();
    expect(store.entries, isEmpty);
    expect(store.weeklyWorkouts, 0);
    expect(store.demo, isFalse);
    await store.saved;
  });
  test('write failures are visible and retry recovers', () async {
    var fail = true;
    final store = FitnessStore(
      persist: (_) async {
        if (fail) throw Exception('disk full');
      },
    );
    store.changed();
    await store.saved;
    expect(store.storageError, isNotNull);
    fail = false;
    store.changed();
    await store.saved;
    expect(store.storageError, isNull);
  });
}
