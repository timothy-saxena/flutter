import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(home: MyPage()));

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  double size = 50;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Size Animation')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(seconds: 2),
              width: size,
              height: size,
              color: Colors.blue,
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  size = size == 50 ? 200 : 50;
                });
              },
              child: const Text('Animate'),
            ),
          ],
        ),
      ),
    );
  }
}
