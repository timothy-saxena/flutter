import 'dart:convert';

import 'package:flutter/foundation.dart';

String dayKey(DateTime date) =>
    '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

class Activity {
  final String id, title, kind;
  final DateTime date;
  final int minutes, steps, water;
  final double sleep;
  const Activity({
    required this.id,
    required this.title,
    required this.kind,
    required this.date,
    this.minutes = 0,
    this.steps = 0,
    this.water = 0,
    this.sleep = 0,
  });
  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'kind': kind,
    'date': date.toIso8601String(),
    'minutes': minutes,
    'steps': steps,
    'water': water,
    'sleep': sleep,
  };
  factory Activity.fromJson(Map<String, dynamic> j) => Activity(
    id: j['id'],
    title: j['title'],
    kind: j['kind'],
    date: DateTime.parse(j['date']),
    minutes: j['minutes'],
    steps: j['steps'],
    water: j['water'],
    sleep: (j['sleep'] as num).toDouble(),
  );
}

class Workout {
  final String id, title, category, level, description;
  final int minutes;
  final List<(String, String)> exercises;
  const Workout(
    this.id,
    this.title,
    this.category,
    this.level,
    this.minutes,
    this.description,
    this.exercises,
  );
}

const workouts = [
  Workout(
    'strength',
    'Full body foundations',
    'Strength',
    'Beginner',
    20,
    'A simple bodyweight session to build a consistent movement habit.',
    [
      ('Warm-up march', '3 minutes'),
      ('Chair squats', '2 × 10 reps'),
      ('Wall push-ups', '2 × 10 reps'),
      ('Standing lunges', '2 × 8 each side'),
      ('Gentle cool-down', '3 minutes'),
    ],
  ),
  Workout(
    'cardio',
    'Everyday energy',
    'Cardio',
    'Beginner',
    25,
    'A comfortable walking session with short brisk intervals.',
    [
      ('Easy walk', '5 minutes'),
      ('Brisk walk', '3 × 4 minutes'),
      ('Easy recovery walk', '3 × 1 minute'),
      ('Cool-down walk', '5 minutes'),
    ],
  ),
  Workout(
    'mindful',
    'Stretch and reset',
    'Mindfulness',
    'Beginner',
    15,
    'Slow movement and relaxed breathing for a quiet break.',
    [
      ('Relaxed breathing', '3 minutes'),
      ('Shoulder circles', '2 minutes'),
      ('Seated side stretch', '3 minutes'),
      ('Gentle standing stretch', '4 minutes'),
      ('Quiet rest', '3 minutes'),
    ],
  ),
  Workout(
    'circuit',
    'Strength circuit',
    'Strength',
    'Intermediate',
    30,
    'A longer bodyweight circuit with rest between rounds.',
    [
      ('Dynamic warm-up', '5 minutes'),
      ('Squats', '3 × 12 reps'),
      ('Incline push-ups', '3 × 10 reps'),
      ('Reverse lunges', '3 × 10 each side'),
      ('Plank', '3 × 25 seconds'),
      ('Cool-down', '5 minutes'),
    ],
  ),
  Workout(
    'interval',
    'Walk and jog intervals',
    'Cardio',
    'Intermediate',
    30,
    'Alternate comfortable jogging and walking at your own pace.',
    [
      ('Warm-up walk', '5 minutes'),
      ('Easy jog', '5 × 2 minutes'),
      ('Recovery walk', '5 × 2 minutes'),
      ('Cool-down walk', '5 minutes'),
    ],
  ),
];

class FitnessStore extends ChangeNotifier {
  FitnessStore({this.persist, DateTime Function()? clock})
    : clock = clock ?? DateTime.now;
  final Future<void> Function(String)? persist;
  final DateTime Function() clock;
  String name = 'Alex', focus = 'Stay active', level = 'Beginner';
  int stepGoal = 8000, minuteGoal = 45, waterGoal = 8, workoutGoal = 4;
  bool demo = true;
  String? storageError;
  List<Activity> entries = [];
  Future<void> _pending = Future.value();
  Future<void> get saved => _pending;
  DateTime get today => DateUtilsLocal.date(clock());
  List<Activity> on(DateTime day) =>
      entries.where((e) => dayKey(e.date) == dayKey(day)).toList()
        ..sort((a, b) => b.date.compareTo(a.date));
  int stepsOn(DateTime day) => on(day).fold(0, (v, e) => v + e.steps);
  int minutesOn(DateTime day) => on(day).fold(0, (v, e) => v + e.minutes);
  int get steps => stepsOn(today);
  int get minutes => minutesOn(today);
  int get water => on(today).fold(0, (v, e) => v + e.water);
  double get sleep => on(today).fold(0.0, (v, e) => v + e.sleep);
  List<DateTime> get week =>
      List.generate(7, (i) => today.subtract(Duration(days: 6 - i)));
  int get weeklyWorkouts => entries
      .where(
        (e) =>
            e.kind == 'Workout' &&
            !e.date.isBefore(today.subtract(const Duration(days: 6))) &&
            e.date.isBefore(today.add(const Duration(days: 1))),
      )
      .length;
  int get activeDays => week.where((d) => minutesOn(d) > 0).length;
  Workout get recommended => workouts.firstWhere(
    (w) =>
        w.category ==
            (focus == 'Build strength'
                ? 'Strength'
                : focus == 'Feel balanced'
                ? 'Mindfulness'
                : 'Cardio') &&
        (w.level == level || w.category == 'Mindfulness'),
  );
  bool completed(Workout w) =>
      on(today).any((e) => e.id.startsWith('${dayKey(today)}:${w.id}'));
  void restore(String raw) {
    final j = jsonDecode(raw) as Map<String, dynamic>;
    name = j['name'];
    focus = j['focus'];
    level = j['level'];
    stepGoal = j['stepGoal'];
    minuteGoal = j['minuteGoal'];
    waterGoal = j['waterGoal'];
    workoutGoal = j['workoutGoal'];
    demo = j['demo'];
    entries = (j['entries'] as List)
        .map((e) => Activity.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  String encode() => jsonEncode({
    'name': name,
    'focus': focus,
    'level': level,
    'stepGoal': stepGoal,
    'minuteGoal': minuteGoal,
    'waterGoal': waterGoal,
    'workoutGoal': workoutGoal,
    'demo': demo,
    'entries': entries.map((e) => e.toJson()).toList(),
  });
  void changed() {
    final snapshot = encode();
    _pending = _pending.then((_) async {
      try {
        await persist?.call(snapshot);
        storageError = null;
      } catch (_) {
        storageError =
            'Changes could not be saved. Keep the app open and retry.';
      }
      notifyListeners();
    });
    notifyListeners();
  }

  void add(Activity entry) {
    entries.add(entry);
    changed();
  }

  void remove(String id) {
    entries.removeWhere((e) => e.id == id);
    changed();
  }

  void complete(Workout workout) {
    if (completed(workout)) return;
    add(
      Activity(
        id: '${dayKey(today)}:${workout.id}',
        title: workout.title,
        kind: 'Workout',
        date: clock(),
        minutes: workout.minutes,
      ),
    );
  }

  void addWater() => add(
    Activity(
      id: 'water:${clock().microsecondsSinceEpoch}',
      title: 'Glass of water',
      kind: 'Water',
      date: clock(),
      water: 1,
    ),
  );
  void seed() {
    entries.clear();
    demo = true;
    for (var i = 6; i >= 0; i--) {
      final date = today
          .subtract(Duration(days: i))
          .add(const Duration(hours: 8));
      entries.add(
        Activity(
          id: 'sample-walk-$i',
          title: i == 0 ? 'Morning walk' : 'Daily walk',
          kind: 'Walking',
          date: date,
          minutes: [25, 20, 35, 15, 30, 25, 20][i],
          steps: [5240, 7400, 8100, 4200, 6800, 5600, 7600][i],
        ),
      );
      if ([1, 3, 5].contains(i)) {
        entries.add(
          Activity(
            id: 'sample-workout-$i',
            title: 'Full body foundations',
            kind: 'Workout',
            date: date.add(const Duration(hours: 9)),
            minutes: 20,
          ),
        );
      }
    }
    entries.add(
      Activity(
        id: 'sample-water',
        title: 'Water so far',
        kind: 'Water',
        date: today.add(const Duration(hours: 9)),
        water: 4,
      ),
    );
    entries.add(
      Activity(
        id: 'sample-sleep',
        title: 'Last night’s sleep',
        kind: 'Sleep',
        date: today.add(const Duration(hours: 7)),
        sleep: 7.5,
      ),
    );
    changed();
  }

  void clear() {
    entries.clear();
    demo = false;
    changed();
  }
}

class DateUtilsLocal {
  static DateTime date(DateTime d) => DateTime(d.year, d.month, d.day);
}

class WellnessRepository {
  Future<List<String>> fetchTips() async {
    await Future<void>.delayed(const Duration(milliseconds: 450));
    return [
      'Make room for a short movement break between study sessions.',
      'Keep a water bottle nearby as a reminder to log your drinks.',
      'Choose a repeatable bedtime routine and record how rested you feel.',
    ];
  }
}
