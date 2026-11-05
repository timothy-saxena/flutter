import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(home: MyPage()));

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  double value = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Fade and Slide')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedOpacity(
              opacity: value,
              duration: const Duration(seconds: 2),
              child: Container(width: 100, height: 100, color: Colors.blue),
            ),
            AnimatedSlide(
              offset: Offset(value, 0),
              duration: const Duration(seconds: 2),
              child: Container(width: 100, height: 100, color: Colors.red),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  value = value == 0 ? 1 : 0;
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
