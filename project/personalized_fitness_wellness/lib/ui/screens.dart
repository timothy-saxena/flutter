import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../data/fitness_store.dart';
import 'components.dart';

Widget heading(String eyebrow, String title, String subtitle) => Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Text(
      eyebrow.toUpperCase(),
      style: const TextStyle(
        fontSize: 11,
        letterSpacing: 2,
        fontWeight: FontWeight.w700,
        color: green,
      ),
    ),
    const SizedBox(height: 9),
    Text(
      title,
      style: const TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.w800,
        letterSpacing: -1,
      ),
    ),
    const SizedBox(height: 7),
    Text(subtitle, style: const TextStyle(color: muted, height: 1.5)),
    const SizedBox(height: 23),
  ],
);
void message(BuildContext context, String text) => ScaffoldMessenger.of(context)
    .showSnackBar(
      SnackBar(content: Text(text), behavior: SnackBarBehavior.floating),
    );
void openWorkout(BuildContext context, FitnessStore store, Workout workout) =>
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => WorkoutDetail(store: store, workout: workout),
      ),
    );

class Dashboard extends StatelessWidget {
  const Dashboard({super.key, required this.store, required this.go});
  final FitnessStore store;
  final ValueChanged<int> go;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      heading(
        dateLabel(store.today),
        'A little stronger, ${store.name}.',
        'Small steps today. A healthier routine tomorrow.',
      ),
      Panel(
        color: ink,
        child: LayoutBuilder(
          builder: (context, c) => Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Tag('YOUR DAILY MOMENTUM', dark: true),
                    const SizedBox(height: 18),
                    const Text(
                      'Make time\nfor yourself.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 33,
                        fontWeight: FontWeight.w700,
                        height: 1.12,
                        letterSpacing: -1,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '${store.minutes} of ${store.minuteGoal} active minutes today',
                      style: const TextStyle(color: Color(0xFFD0DFD5)),
                    ),
                    const SizedBox(height: 20),
                    FilledButton.icon(
                      style: FilledButton.styleFrom(
                        backgroundColor: lime,
                        foregroundColor: ink,
                      ),
                      onPressed: () =>
                          openWorkout(context, store, store.recommended),
                      icon: const Icon(Icons.play_arrow_rounded),
                      label: const Text('Your daily workout'),
                    ),
                  ],
                ),
              ),
              if (c.maxWidth > 450)
                Padding(
                  padding: const EdgeInsets.all(22),
                  child: SizedBox(
                    width: 140,
                    height: 140,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox.expand(
                          child: CircularProgressIndicator(
                            value: (store.minutes / store.minuteGoal).clamp(
                              0,
                              1,
                            ),
                            strokeWidth: 12,
                            color: lime,
                            backgroundColor: Colors.white12,
                            strokeCap: StrokeCap.round,
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${(store.minutes / store.minuteGoal * 100).round()}%',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 34,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Text(
                              'daily goal',
                              style: TextStyle(color: Colors.white70),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
      SectionTitle(
        'Today at a glance',
        action: TextButton(
          onPressed: () => Navigator.pushNamed(context, '/log'),
          child: const Text('+ Log activity'),
        ),
      ),
      ResponsiveCards(
        children: [
          MetricCard(
            title: 'Steps',
            value: number(store.steps),
            unit: 'of ${number(store.stepGoal)} steps',
            icon: Icons.directions_walk_rounded,
            progress: store.steps / store.stepGoal,
          ),
          MetricCard(
            title: 'Active time',
            value: '${store.minutes}',
            unit: 'of ${store.minuteGoal} minutes',
            icon: Icons.bolt_rounded,
            progress: store.minutes / store.minuteGoal,
            tint: const Color(0xFFFFEDD6),
          ),
          MetricCard(
            title: 'Hydration',
            value: '${store.water}',
            unit: 'of ${store.waterGoal} glasses',
            icon: Icons.water_drop_outlined,
            progress: store.water / store.waterGoal,
            tint: const Color(0xFFE1EEF7),
          ),
          MetricCard(
            title: 'Sleep',
            value: store.sleep.toStringAsFixed(1),
            unit: 'hours logged today',
            icon: Icons.nights_stay_outlined,
            progress: store.sleep / 8,
            tint: const Color(0xFFEEE6F7),
          ),
        ],
      ),
      SectionTitle(
        'Made for your routine',
        action: TextButton(
          onPressed: () => go(1),
          child: const Text('View plans →'),
        ),
      ),
      WorkoutTile(workout: store.recommended, store: store, recommended: true),
      const SectionTitle('A moment of balance'),
      Panel(
        color: const Color(0xFFEAF0DF),
        child: Row(
          children: [
            const Icon(Icons.water_drop_outlined, color: green, size: 32),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Pause. Sip. Reset.',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  Text(
                    '${store.water} glasses logged today',
                    style: const TextStyle(color: muted),
                  ),
                ],
              ),
            ),
            IconButton.filled(
              tooltip: 'Add one glass of water',
              onPressed: () {
                store.addWater();
                message(context, 'One glass of water added');
              },
              icon: const Icon(Icons.add),
            ),
          ],
        ),
      ),
      const SizedBox(height: 16),
      WellnessTips(),
      if (store.demo)
        const Padding(
          padding: EdgeInsets.only(top: 20),
          child: Text(
            'Sample history is loaded for your demo. Start fresh from Profile.',
            style: TextStyle(fontSize: 12, color: muted),
          ),
        ),
    ],
  );
}

class WellnessTips extends StatefulWidget {
  const WellnessTips({super.key});
  @override
  State<WellnessTips> createState() => _WellnessTipsState();
}

class _WellnessTipsState extends State<WellnessTips> {
  late Future<List<String>> tips = WellnessRepository().fetchTips();
  @override
  Widget build(BuildContext context) => FutureBuilder<List<String>>(
    future: tips,
    builder: (context, snapshot) {
      if (snapshot.connectionState != ConnectionState.done) {
        return const LinearProgressIndicator();
      }
      if (snapshot.hasError) {
        return TextButton(
          onPressed: () =>
              setState(() => tips = WellnessRepository().fetchTips()),
          child: const Text('Could not load wellness note. Retry'),
        );
      }
      final items = snapshot.data ?? [];
      if (items.isEmpty) return const Text('No wellness notes today.');
      return Panel(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.wb_sunny_outlined, color: green),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'A gentle reminder',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 7),
                  Text(
                    items[DateTime.now().weekday % items.length],
                    style: const TextStyle(color: muted, height: 1.5),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    },
  );
}

class WorkoutTile extends StatelessWidget {
  const WorkoutTile({
    super.key,
    required this.workout,
    required this.store,
    this.recommended = false,
  });
  final Workout workout;
  final FitnessStore store;
  final bool recommended;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: () => openWorkout(context, store, workout),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                width: 54,
                height: 66,
                decoration: BoxDecoration(
                  color: workout.category == 'Mindfulness'
                      ? const Color(0xFFEEE6F7)
                      : workout.category == 'Cardio'
                      ? const Color(0xFFFFEDD6)
                      : const Color(0xFFE8F0DB),
                  borderRadius: BorderRadius.circular(17),
                ),
                child: Icon(
                  workout.category == 'Mindfulness'
                      ? Icons.self_improvement
                      : workout.category == 'Cardio'
                      ? Icons.directions_run
                      : Icons.fitness_center,
                  color: ink,
                  size: 29,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (recommended)
                      const Text(
                        'RECOMMENDED FOR YOU',
                        style: TextStyle(
                          fontSize: 10,
                          letterSpacing: 1,
                          color: green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    const SizedBox(height: 4),
                    Text(
                      workout.title,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 7),
                    Text(
                      '${workout.minutes} min · ${workout.level} · ${workout.category}',
                      style: const TextStyle(color: muted, fontSize: 12),
                    ),
                  ],
                ),
              ),
              Icon(
                store.completed(workout)
                    ? Icons.check_circle
                    : Icons.arrow_forward_rounded,
                color: green,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

class WorkoutsScreen extends StatefulWidget {
  const WorkoutsScreen({super.key, required this.store});
  final FitnessStore store;
  @override
  State<WorkoutsScreen> createState() => _WorkoutsScreenState();
}

class _WorkoutsScreenState extends State<WorkoutsScreen> {
  String filter = 'All';
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      heading(
        'Move with intention',
        'Find your next session.',
        'Simple plans. Clear steps. A pace that works for you.',
      ),
      Panel(
        color: const Color(0xFFE8F0DB),
        child: Row(
          children: [
            const Icon(Icons.auto_awesome_outlined, color: green),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                'Your focus: ${widget.store.focus}\n${widget.store.level} routines selected for you.',
                style: const TextStyle(height: 1.6),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pushNamed(context, '/profile'),
              child: const Text('Edit'),
            ),
          ],
        ),
      ),
      const SectionTitle('Your suggested plan'),
      WorkoutTile(
        workout: widget.store.recommended,
        store: widget.store,
        recommended: true,
      ),
      const SectionTitle('Explore workouts'),
      Wrap(
        spacing: 8,
        children: ['All', 'Strength', 'Cardio', 'Mindfulness']
            .map(
              (s) => ChoiceChip(
                label: Text(s),
                selected: filter == s,
                onSelected: (_) => setState(() => filter = s),
              ),
            )
            .toList(),
      ),
      const SizedBox(height: 18),
      ...workouts
          .where((w) => filter == 'All' || w.category == filter)
          .map((w) => WorkoutTile(workout: w, store: widget.store)),
    ],
  );
}

class WorkoutDetail extends StatefulWidget {
  const WorkoutDetail({super.key, required this.store, required this.workout});
  final FitnessStore store;
  final Workout workout;
  @override
  State<WorkoutDetail> createState() => _WorkoutDetailState();
}

class _WorkoutDetailState extends State<WorkoutDetail> {
  final Set<int> checked = {};
  @override
  Widget build(BuildContext context) {
    final w = widget.workout;
    return Scaffold(
      appBar: AppBar(title: const Text('Your workout')),
      body: ListenableBuilder(
        listenable: widget.store,
        builder: (context, _) => SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 680),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Panel(
                    color: ink,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.fitness_center, color: lime, size: 44),
                        const SizedBox(height: 24),
                        Text(
                          w.title,
                          style: const TextStyle(
                            fontSize: 32,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            Tag('${w.minutes} minutes', dark: true),
                            Tag(w.level, dark: true),
                            Tag(w.category, dark: true),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          w.description,
                          style: const TextStyle(
                            color: Colors.white70,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SectionTitle('Your session, step by step'),
                  const Text(
                    'Check off each exercise when you finish.',
                    style: TextStyle(color: muted),
                  ),
                  const SizedBox(height: 12),
                  ...List.generate(
                    w.exercises.length,
                    (i) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Panel(
                        padding: 5,
                        child: CheckboxListTile(
                          value:
                              checked.contains(i) || widget.store.completed(w),
                          onChanged: widget.store.completed(w)
                              ? null
                              : (v) => setState(() {
                                  if (v == true) {
                                    checked.add(i);
                                  } else {
                                    checked.remove(i);
                                  }
                                }),
                          title: Text(
                            w.exercises[i].$1,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          subtitle: Text(w.exercises[i].$2),
                          controlAffinity: ListTileControlAffinity.leading,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    child: widget.store.completed(w)
                        ? const Panel(
                            key: ValueKey('success'),
                            color: Color(0xFFE8F0DB),
                            child: Row(
                              children: [
                                Icon(Icons.check_circle, color: green),
                                SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    'Session completed! Your progress is updated.',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : SizedBox(
                            width: double.infinity,
                            child: FilledButton.icon(
                              onPressed: checked.length == w.exercises.length
                                  ? () => widget.store.complete(w)
                                  : null,
                              icon: const Icon(Icons.check_rounded),
                              label: Text(
                                'Finish workout (${checked.length}/${w.exercises.length})',
                              ),
                            ),
                          ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Move at a comfortable pace and pause whenever you need to.',
                    style: TextStyle(color: muted, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key, required this.store});
  final FitnessStore store;
  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  DateTime? selected;
  @override
  Widget build(BuildContext context) {
    final store = widget.store, day = selected ?? widget.store.today;
    final entries = store.on(day);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        heading(
          'Every little bit counts',
          'Your activity journal.',
          'Record your movement, water and rest in one place.',
        ),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            FilledButton.icon(
              onPressed: () => Navigator.pushNamed(context, '/log'),
              icon: const Icon(Icons.add),
              label: const Text('Log activity'),
            ),
            OutlinedButton.icon(
              onPressed: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: day,
                  firstDate: store.today.subtract(const Duration(days: 365)),
                  lastDate: store.today,
                );
                if (date != null) setState(() => selected = date);
              },
              icon: const Icon(Icons.calendar_today_outlined, size: 18),
              label: Text(dateLabel(day)),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Panel(
          color: const Color(0xFFE8F0DB),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      number(store.stepsOn(day)),
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text('steps logged', style: TextStyle(color: muted)),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${store.minutesOn(day)} min',
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text('active time', style: TextStyle(color: muted)),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SectionTitle('Activity timeline'),
        if (entries.isEmpty)
          const Panel(
            child: Column(
              children: [
                Icon(Icons.directions_walk, color: green, size: 42),
                SizedBox(height: 14),
                Text(
                  'A fresh page for your routine.',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  'Log an activity to see it here.',
                  style: TextStyle(color: muted),
                ),
              ],
            ),
          ),
        ...entries.map(
          (e) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Panel(
              padding: 16,
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: cream,
                    foregroundColor: green,
                    child: Icon(
                      e.kind == 'Water'
                          ? Icons.water_drop_outlined
                          : e.kind == 'Sleep'
                          ? Icons.bedtime_outlined
                          : e.kind == 'Workout'
                          ? Icons.fitness_center
                          : Icons.directions_walk,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          e.title,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          e.kind == 'Water'
                              ? '${e.water} glasses'
                              : e.kind == 'Sleep'
                              ? '${e.sleep} hours'
                              : '${e.minutes} min${e.steps > 0 ? ' · ${number(e.steps)} steps' : ''}',
                          style: const TextStyle(color: muted),
                        ),
                        Text(
                          '${e.date.hour.toString().padLeft(2, '0')}:${e.date.minute.toString().padLeft(2, '0')} · ${e.kind}',
                          style: const TextStyle(fontSize: 11, color: muted),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    tooltip: 'Delete ${e.title}',
                    icon: const Icon(
                      Icons.delete_outline,
                      size: 20,
                      color: muted,
                    ),
                    onPressed: () async {
                      final remove = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Delete this entry?'),
                          content: Text(e.title),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text('Cancel'),
                            ),
                            FilledButton(
                              onPressed: () => Navigator.pop(context, true),
                              child: const Text('Delete'),
                            ),
                          ],
                        ),
                      );
                      if (remove == true) store.remove(e.id);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key, required this.store});
  final FitnessStore store;
  @override
  Widget build(BuildContext context) {
    final weeklyMinutes = store.week.fold(0, (v, d) => v + store.minutesOn(d));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        heading(
          'Look how far you’ve come',
          'Progress over perfection.',
          'Your last seven days, one small win at a time.',
        ),
        ResponsiveCards(
          children: [
            MetricCard(
              title: 'Active days',
              value: '${store.activeDays}',
              unit: 'of the last 7 days',
              icon: Icons.calendar_month_outlined,
              progress: store.activeDays / 7,
            ),
            MetricCard(
              title: 'Workouts',
              value: '${store.weeklyWorkouts}',
              unit: 'of ${store.workoutGoal} weekly sessions',
              icon: Icons.fitness_center,
              progress: store.weeklyWorkouts / store.workoutGoal,
            ),
            MetricCard(
              title: 'Movement',
              value: '$weeklyMinutes',
              unit: 'minutes in 7 days',
              icon: Icons.bolt,
              progress: weeklyMinutes / (store.minuteGoal * 7),
            ),
            MetricCard(
              title: 'Daily average',
              value: number(
                (store.week.fold(0, (v, d) => v + store.stepsOn(d)) / 7)
                    .round(),
              ),
              unit: 'steps across all 7 days',
              icon: Icons.directions_walk,
              progress:
                  store.week.fold(0, (v, d) => v + store.stepsOn(d)) /
                  (7 * store.stepGoal),
            ),
          ],
        ),
        const SectionTitle('Your movement this week'),
        Panel(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'ACTIVE MINUTES',
                style: TextStyle(
                  fontSize: 11,
                  color: muted,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${dateLabel(store.week.first)} – ${dateLabel(store.today)}',
                style: const TextStyle(color: muted, fontSize: 12),
              ),
              const SizedBox(height: 26),
              WeekChart(store: store),
              const SizedBox(height: 16),
              const Text(
                'Each bar shows the total active minutes you logged that day.',
                style: TextStyle(color: muted, fontSize: 12),
              ),
            ],
          ),
        ),
        const SectionTitle('Small wins worth celebrating'),
        Panel(
          color: const Color(0xFFE8F0DB),
          child: Row(
            children: [
              const Icon(Icons.emoji_events_outlined, size: 42, color: green),
              const SizedBox(width: 18),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      store.activeDays >= 5
                          ? 'Consistency looks good on you.'
                          : 'Your next small win is waiting.',
                      style: const TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'You moved on ${store.activeDays} of the last 7 days and completed ${store.weeklyWorkouts} workouts.',
                      style: const TextStyle(color: muted, height: 1.5),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (store.demo)
          const Padding(
            padding: EdgeInsets.only(top: 16),
            child: Text(
              'Includes sample activity history.',
              style: TextStyle(color: muted, fontSize: 12),
            ),
          ),
      ],
    );
  }
}

class WeekChart extends StatelessWidget {
  const WeekChart({super.key, required this.store});
  final FitnessStore store;
  @override
  Widget build(BuildContext context) {
    final maxValue = math.max(
      60,
      store.week.map(store.minutesOn).fold(0, math.max),
    );
    const days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    return SizedBox(
      height: 200,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: store.week.map((d) {
          final amount = store.minutesOn(d), today = d == store.today;
          return Expanded(
            child: Semantics(
              label: '${dateLabel(d)}: $amount active minutes',
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    '$amount',
                    style: const TextStyle(fontSize: 12, color: muted),
                  ),
                  const SizedBox(height: 9),
                  Flexible(
                    child: TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0, end: amount / maxValue),
                      duration: const Duration(milliseconds: 450),
                      builder: (context, v, _) => Container(
                        height: math.max(4, v * 145),
                        width: 30,
                        decoration: BoxDecoration(
                          color: today ? green : const Color(0xFFD7E6C8),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 13),
                  Text(
                    days[d.weekday - 1],
                    style: TextStyle(
                      fontWeight: today ? FontWeight.bold : FontWeight.normal,
                      color: today ? green : muted,
                    ),
                  ),
                  Text(
                    '${d.day}',
                    style: const TextStyle(fontSize: 10, color: muted),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class GoalsScreen extends StatelessWidget {
  const GoalsScreen({super.key, required this.store});
  final FitnessStore store;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      heading(
        'Give your routine a direction',
        'Your goals. Your pace.',
        'Set targets that fit your day and watch your progress grow.',
      ),
      FilledButton.icon(
        onPressed: () => Navigator.pushNamed(context, '/goals/edit'),
        icon: const Icon(Icons.tune),
        label: const Text('Edit goals'),
      ),
      const SizedBox(height: 24),
      goal(
        'Daily steps',
        Icons.directions_walk,
        store.steps,
        store.stepGoal,
        'steps',
        'Today',
      ),
      goal(
        'Daily movement',
        Icons.bolt,
        store.minutes,
        store.minuteGoal,
        'minutes',
        'Today',
      ),
      goal(
        'Daily hydration',
        Icons.water_drop_outlined,
        store.water,
        store.waterGoal,
        'glasses',
        'Today',
      ),
      goal(
        'Weekly workouts',
        Icons.fitness_center,
        store.weeklyWorkouts,
        store.workoutGoal,
        'sessions',
        'Last 7 days',
      ),
      const SizedBox(height: 12),
      const Panel(
        color: Color(0xFFE8F0DB),
        child: Text(
          'A goal is a direction, not a deadline. Adjust your targets whenever your routine changes.',
          style: TextStyle(color: green, height: 1.6),
        ),
      ),
    ],
  );
  Widget goal(
    String title,
    IconData icon,
    int value,
    int target,
    String unit,
    String period,
  ) => Padding(
    padding: const EdgeInsets.only(bottom: 14),
    child: Panel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: cream,
                foregroundColor: green,
                child: Icon(icon),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      period,
                      style: const TextStyle(color: muted, fontSize: 12),
                    ),
                  ],
                ),
              ),
              Tag(
                value >= target
                    ? 'Achieved'
                    : '${(value / target * 100).round()}%',
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            '${number(value)} / ${number(target)} $unit',
            style: const TextStyle(color: muted),
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: (value / target).clamp(0, 1),
              minHeight: 8,
              color: green,
              backgroundColor: cream,
            ),
          ),
        ],
      ),
    ),
  );
}

class FormPage extends StatelessWidget {
  const FormPage({super.key, required this.title, required this.child});
  final String title;
  final Widget child;
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(title)),
    body: SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 620),
            child: child,
          ),
        ),
      ),
    ),
  );
}

String? positive(
  String? value,
  String label,
  double max, {
  bool zero = false,
  bool decimal = false,
}) {
  final n = double.tryParse(value?.trim() ?? '');
  if (n == null ||
      !n.isFinite ||
      n < (zero ? 0 : 1) ||
      n > max ||
      (!decimal && int.tryParse(value?.trim() ?? '') == null)) {
    return 'Enter ${decimal ? 'a number' : 'a whole number'} from ${zero ? 0 : 1} to ${max.toInt()} for $label';
  }
  return null;
}

Widget field(
  TextEditingController controller,
  String label, {
  String? Function(String?)? validator,
  bool numeric = true,
}) => Padding(
  padding: const EdgeInsets.only(bottom: 18),
  child: TextFormField(
    controller: controller,
    decoration: InputDecoration(labelText: label),
    keyboardType: numeric
        ? const TextInputType.numberWithOptions(decimal: true)
        : TextInputType.text,
    validator: validator,
  ),
);

class ActivityForm extends StatefulWidget {
  const ActivityForm({super.key, required this.store});
  final FitnessStore store;
  @override
  State<ActivityForm> createState() => _ActivityFormState();
}

class _ActivityFormState extends State<ActivityForm> {
  final form = GlobalKey<FormState>();
  final title = TextEditingController(),
      minutes = TextEditingController(),
      steps = TextEditingController(text: '0'),
      amount = TextEditingController();
  String kind = 'Walking';
  DateTime? day;
  @override
  void dispose() {
    title.dispose();
    minutes.dispose();
    steps.dispose();
    amount.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => FormPage(
    title: 'Log activity',
    child: Form(
      key: form,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          heading(
            'Build your daily story',
            'Every activity matters.',
            'Add a completed activity to update your dashboard and goals.',
          ),
          DropdownButtonFormField<String>(
            initialValue: kind,
            decoration: const InputDecoration(labelText: 'Activity type'),
            items: [
              'Walking',
              'Running',
              'Cycling',
              'Workout',
              'Mindfulness',
              'Water',
              'Sleep',
            ].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
            onChanged: (v) => setState(() {
              kind = v!;
              amount.clear();
            }),
          ),
          const SizedBox(height: 18),
          field(
            title,
            'Activity name',
            numeric: false,
            validator: (v) => v == null || v.trim().isEmpty
                ? 'Enter an activity name'
                : v.trim().length > 60
                ? 'Use 60 characters or fewer'
                : null,
          ),
          if (kind != 'Water' && kind != 'Sleep') ...[
            field(
              minutes,
              'Duration (minutes)',
              validator: (v) => positive(v, 'minutes', 1440),
            ),
            field(
              steps,
              'Steps (0 if not applicable)',
              validator: (v) => positive(v, 'steps', 100000, zero: true),
            ),
          ] else
            field(
              amount,
              kind == 'Water' ? 'Number of glasses' : 'Hours slept',
              validator: (v) => positive(
                v,
                kind.toLowerCase(),
                kind == 'Water' ? 50 : 24,
                decimal: kind == 'Sleep',
              ),
            ),
          OutlinedButton.icon(
            onPressed: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: day ?? widget.store.today,
                firstDate: widget.store.today.subtract(
                  const Duration(days: 365),
                ),
                lastDate: widget.store.today,
              );
              if (date != null) setState(() => day = date);
            },
            icon: const Icon(Icons.calendar_today_outlined),
            label: Text(dateLabel(day ?? widget.store.today)),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () {
                if (!form.currentState!.validate()) return;
                final now = widget.store.clock(),
                    selected = day ?? widget.store.today;
                final date = DateTime(
                  selected.year,
                  selected.month,
                  selected.day,
                  now.hour,
                  now.minute,
                );
                widget.store.add(
                  Activity(
                    id: 'manual:${now.microsecondsSinceEpoch}',
                    title: title.text.trim(),
                    kind: kind,
                    date: date,
                    minutes: kind != 'Water' && kind != 'Sleep'
                        ? int.parse(minutes.text.trim())
                        : 0,
                    steps: kind != 'Water' && kind != 'Sleep'
                        ? int.parse(steps.text.trim())
                        : 0,
                    water: kind == 'Water' ? int.parse(amount.text.trim()) : 0,
                    sleep: kind == 'Sleep'
                        ? double.parse(amount.text.trim())
                        : 0,
                  ),
                );
                Navigator.pop(context);
                message(context, 'Activity saved. Your progress is updated.');
              },
              child: const Text('Save activity'),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Entries are recorded manually and saved on this device.',
            style: TextStyle(color: muted, fontSize: 12),
          ),
        ],
      ),
    ),
  );
}

class GoalsForm extends StatefulWidget {
  const GoalsForm({super.key, required this.store});
  final FitnessStore store;
  @override
  State<GoalsForm> createState() => _GoalsFormState();
}

class _GoalsFormState extends State<GoalsForm> {
  final form = GlobalKey<FormState>();
  late final controllers = [
    widget.store.stepGoal,
    widget.store.minuteGoal,
    widget.store.waterGoal,
    widget.store.workoutGoal,
  ].map((v) => TextEditingController(text: '$v')).toList();
  @override
  void dispose() {
    for (final c in controllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => FormPage(
    title: 'Edit goals',
    child: Form(
      key: form,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          heading(
            'Make it personal',
            'Choose your targets.',
            'These are your own targets. Update them as your routine changes.',
          ),
          ...List.generate(
            4,
            (i) => field(
              controllers[i],
              [
                'Daily steps',
                'Daily active minutes',
                'Daily glasses of water',
                'Workouts in 7 days',
              ][i],
              validator: (v) =>
                  positive(v, 'your target', [100000.0, 1440.0, 50.0, 28.0][i]),
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () {
                if (!form.currentState!.validate()) return;
                final values = controllers
                    .map((c) => int.parse(c.text.trim()))
                    .toList();
                widget.store.stepGoal = values[0];
                widget.store.minuteGoal = values[1];
                widget.store.waterGoal = values[2];
                widget.store.workoutGoal = values[3];
                widget.store.changed();
                Navigator.pop(context);
                message(context, 'Your goals have been updated');
              },
              child: const Text('Save goals'),
            ),
          ),
        ],
      ),
    ),
  );
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, required this.store});
  final FitnessStore store;
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final form = GlobalKey<FormState>();
  late final name = TextEditingController(text: widget.store.name);
  late String focus = widget.store.focus, level = widget.store.level;
  @override
  void dispose() {
    name.dispose();
    super.dispose();
  }

  Future<void> reset(bool demo) async {
    final approved = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          demo ? 'Restore demo history?' : 'Start with a fresh journal?',
        ),
        content: const Text(
          'This replaces all activity entries on this device. Your profile and goals will stay the same.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Continue'),
          ),
        ],
      ),
    );
    if (approved == true) {
      if (demo) {
        widget.store.seed();
      } else {
        widget.store.clear();
      }
      if (mounted) {
        message(
          context,
          demo
              ? 'Sample history restored'
              : 'Your activity journal is now empty',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) => FormPage(
    title: 'Your profile',
    child: Form(
      key: form,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          heading(
            'Wellness starts with you',
            'Make FitNest your own.',
            'Your focus and experience shape your recommended session.',
          ),
          field(
            name,
            'Your name',
            numeric: false,
            validator: (v) => v == null || v.trim().isEmpty
                ? 'Enter your name'
                : v.trim().length > 30
                ? 'Use 30 characters or fewer'
                : null,
          ),
          DropdownButtonFormField<String>(
            initialValue: focus,
            decoration: const InputDecoration(labelText: 'My focus'),
            items: [
              'Stay active',
              'Build strength',
              'Feel balanced',
            ].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
            onChanged: (v) => setState(() => focus = v!),
          ),
          const SizedBox(height: 18),
          DropdownButtonFormField<String>(
            initialValue: level,
            decoration: const InputDecoration(labelText: 'Experience level'),
            items: [
              'Beginner',
              'Intermediate',
            ].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
            onChanged: (v) => setState(() => level = v!),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () {
                if (!form.currentState!.validate()) return;
                widget.store.name = name.text.trim();
                widget.store.focus = focus;
                widget.store.level = level;
                widget.store.changed();
                Navigator.pop(context);
                message(context, 'Profile saved. Your plan is personalized.');
              },
              child: const Text('Save profile'),
            ),
          ),
          const SectionTitle('Your local data'),
          const Text(
            'FitNest is a UI lab project. Activity entries stay on this device. No account, wearable connection or live health data is required.',
            style: TextStyle(color: muted, height: 1.6),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              OutlinedButton(
                onPressed: () => reset(false),
                child: const Text('Start fresh'),
              ),
              TextButton(
                onPressed: () => reset(true),
                child: const Text('Restore demo history'),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
