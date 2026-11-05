import 'package:flutter/material.dart';

const ink = Color(0xFF173D35);
const green = Color(0xFF27785D);
const cream = Color(0xFFF5F6F0);
const muted = Color(0xFF6B7971);
const lime = Color(0xFFDDF3A6);

class Panel extends StatelessWidget {
  const Panel({
    super.key,
    required this.child,
    this.color = Colors.white,
    this.padding = 22,
  });
  final Widget child;
  final Color color;
  final double padding;
  @override
  Widget build(BuildContext context) => Material(
    color: color,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(24),
      side: BorderSide(color: ink.withValues(alpha: .06)),
    ),
    child: SizedBox(
      width: double.infinity,
      child: Padding(padding: EdgeInsets.all(padding), child: child),
    ),
  );
}

class SectionTitle extends StatelessWidget {
  const SectionTitle(this.title, {super.key, this.action});
  final String title;
  final Widget? action;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 26, bottom: 14),
    child: Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.w700,
              letterSpacing: -.5,
            ),
          ),
        ),
        ?action,
      ],
    ),
  );
}

class Tag extends StatelessWidget {
  const Tag(this.text, {super.key, this.dark = false});
  final String text;
  final bool dark;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
    decoration: BoxDecoration(
      color: dark ? Colors.white.withValues(alpha: .12) : cream,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Text(
      text,
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: dark ? Colors.white : green,
      ),
    ),
  );
}

class MetricCard extends StatelessWidget {
  const MetricCard({
    super.key,
    required this.title,
    required this.value,
    required this.unit,
    required this.icon,
    required this.progress,
    this.tint = const Color(0xFFE8F0DB),
  });
  final String title, value, unit;
  final IconData icon;
  final double progress;
  final Color tint;
  @override
  Widget build(BuildContext context) => Panel(
    padding: 18,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircleAvatar(
              backgroundColor: tint,
              foregroundColor: ink,
              radius: 19,
              child: Icon(icon, size: 20),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(color: muted, fontSize: 13),
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        Text(
          value,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            letterSpacing: -1,
          ),
        ),
        Text(unit, style: const TextStyle(fontSize: 12, color: muted)),
        const SizedBox(height: 16),
        ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: LinearProgressIndicator(
            value: progress.clamp(0, 1),
            minHeight: 5,
            backgroundColor: cream,
            color: green,
          ),
        ),
      ],
    ),
  );
}

class ResponsiveCards extends StatelessWidget {
  const ResponsiveCards({super.key, required this.children});
  final List<Widget> children;
  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, box) {
      final cols = box.maxWidth >= 750 ? 4 : 2;
      final width = (box.maxWidth - 12 * (cols - 1)) / cols;
      return Wrap(
        spacing: 12,
        runSpacing: 12,
        children: children
            .map((c) => SizedBox(width: width, child: c))
            .toList(),
      );
    },
  );
}

String number(int n) => n.toString().replaceAllMapped(
  RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
  (m) => '${m[1]},',
);
String dateLabel(DateTime date) {
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  return '${date.day} ${months[date.month - 1]} ${date.year}';
}
