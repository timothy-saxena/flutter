import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Custom Widget')),
        body: const Column(
          children: [ProfileCard('Rahul'), ProfileCard('Krishna')],
        ),
      ),
    ),
  );
}

class ProfileCard extends StatelessWidget {
  final String name;
  const ProfileCard(this.name, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(leading: const Icon(Icons.person), title: Text(name)),
    );
  }
}
