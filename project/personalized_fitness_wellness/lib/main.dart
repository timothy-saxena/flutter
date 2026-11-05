import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data/fitness_store.dart';
import 'ui/components.dart';
import 'ui/screens.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = SharedPreferencesAsync();
  final store = FitnessStore(
    persist: (raw) => prefs.setString('fitnest_v1', raw),
  );
  try {
    final raw = await prefs.getString('fitnest_v1');
    if (raw == null) {
      store.seed();
    } else {
      store.restore(raw);
    }
  } catch (_) {
    store.demo = false;
    store.storageError = 'Saved data could not be loaded. You can continue with an empty activity log.';
  }
  runApp(FitNestApp(store: store));
}

class FitNestApp extends StatelessWidget {
  const FitNestApp({super.key, required this.store});
  final FitnessStore store;
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'FitNest | Fitness & Wellness',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: cream,
      colorScheme: ColorScheme.fromSeed(
        seedColor: green,
        surface: Colors.white,
      ),
      textTheme: ThemeData.light().textTheme.apply(
        bodyColor: ink,
        displayColor: ink,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: cream,
        foregroundColor: ink,
        elevation: 0,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: cream,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.all(18),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: green,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    ),
    routes: {
      '/': (_) => HomeShell(store: store),
      '/log': (_) => ActivityForm(store: store),
      '/profile': (_) => ProfileScreen(store: store),
      '/goals/edit': (_) => GoalsForm(store: store),
    },
  );
}

class HomeShell extends StatefulWidget {
  const HomeShell({super.key, required this.store});
  final FitnessStore store;
  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> with WidgetsBindingObserver {
  int selected = 0;
  final labels = ['Overview', 'Workouts', 'Activity', 'Progress', 'Goals'];
  final icons = [
    Icons.grid_view_rounded,
    Icons.fitness_center_rounded,
    Icons.favorite_outline_rounded,
    Icons.insights_rounded,
    Icons.flag_outlined,
  ];
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) setState(() {});
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: widget.store,
    builder: (context, _) {
      final store = widget.store;
      final wide = MediaQuery.sizeOf(context).width >= 900;
      final screens = [
        Dashboard(store: store, go: (i) => setState(() => selected = i)),
        WorkoutsScreen(store: store),
        ActivityScreen(store: store),
        ProgressScreen(store: store),
        GoalsScreen(store: store),
      ];
      final body = Column(
        children: [
          if (store.storageError != null)
            MaterialBanner(
              content: Text(store.storageError!),
              actions: [
                TextButton(
                  onPressed: store.changed,
                  child: const Text('Retry'),
                ),
              ],
            ),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 220),
              child: SingleChildScrollView(
                key: ValueKey(selected),
                padding: EdgeInsets.all(wide ? 32 : 20),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1050),
                    child: screens[selected],
                  ),
                ),
              ),
            ),
          ),
        ],
      );
      return Scaffold(
        appBar: AppBar(
          toolbarHeight: 76,
          titleSpacing: 24,
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: green,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.spa_rounded, color: lime, size: 22),
              ),
              const SizedBox(width: 10),
              const Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    'fitnest',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -1,
                    ),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            if (wide)
              const Text(
                'YOUR EVERYDAY WELLNESS COMPANION',
                style: TextStyle(
                  fontSize: 11,
                  letterSpacing: 1.5,
                  color: muted,
                ),
              ),
            const SizedBox(width: 18),
            IconButton(
              tooltip: 'Edit profile',
              onPressed: () => Navigator.pushNamed(context, '/profile'),
              icon: CircleAvatar(
                backgroundColor: const Color(0xFFE5EBD9),
                child: Text(
                  store.name.isEmpty ? 'A' : store.name[0].toUpperCase(),
                  style: const TextStyle(
                    color: ink,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
          ],
        ),
        body: SafeArea(
          child: wide
              ? Row(
                  children: [
                    NavigationRail(
                      backgroundColor: cream,
                      selectedIndex: selected,
                      onDestinationSelected: (i) =>
                          setState(() => selected = i),
                      labelType: NavigationRailLabelType.all,
                      groupAlignment: -.8,
                      destinations: List.generate(
                        5,
                        (i) => NavigationRailDestination(
                          icon: Icon(icons[i]),
                          label: Text(labels[i]),
                        ),
                      ),
                    ),
                    const VerticalDivider(width: 1),
                    Expanded(child: body),
                  ],
                )
              : body,
        ),
        bottomNavigationBar: wide
            ? null
            : NavigationBar(
                selectedIndex: selected,
                onDestinationSelected: (i) => setState(() => selected = i),
                backgroundColor: Colors.white,
                indicatorColor: lime,
                labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
                destinations: List.generate(
                  5,
                  (i) => NavigationDestination(
                    icon: Icon(icons[i]),
                    label: labels[i],
                  ),
                ),
              ),
      );
    },
  );
}
