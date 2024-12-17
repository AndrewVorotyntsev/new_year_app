import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('New Year'),
      ),
      body: SafeArea(
        child: Center(
          child: LayoutBuilder(builder: (context, constraints) {
            print(constraints);
            return SizedBox(
              height: 620,
              width: 420,
              child: RepaintBoundary(
                child: CustomPaint(
                  painter: MyPainter(),
                  willChange: true,
                  child: Container(),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

class MyPainter extends CustomPainter {
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;

  @override
  void paint(Canvas canvas, Size size) {
    _drawNightSky(canvas);
    _drawSnowLand(canvas, size);
    _drawTrunk(canvas, size);
    _drawTopBranch(canvas, size);
    _drawMiddleBranch(canvas, size);
    _drawBottomBranch(canvas, size);
    _drawDecorBalls(canvas);

    _drawGiftBox(canvas, center: Offset(100, size.height - 100), color: Colors.red, boxSize: Size(50, 50));
    _drawGiftBox(canvas, center: Offset(300, size.height - 100), color: Colors.orange, boxSize: Size(100, 80));
    _drawGiftBox(canvas, center: Offset(300, size.height - 100), color: Colors.orange, boxSize: Size(100, 80));
    _drawGiftBox(canvas, center: Offset(180, size.height - 100), color: Colors.lightGreen, boxSize: Size(70, 70));

  }

  void _drawDecorBalls(Canvas canvas) {
    _drawDecorBall(canvas, location: Offset(200, 200), color: Colors.red);
    _drawDecorBall(canvas, location: Offset(170, 250), color: Colors.pinkAccent, radius: 10);
    _drawDecorBall(canvas, location: Offset(235, 255), color: Colors.greenAccent);
    _drawDecorBall(canvas, location: Offset(240, 170), color: Colors.orange, radius: 15);
    _drawDecorBall(canvas, location: Offset(240, 170), color: Colors.orange);
    _drawDecorBall(canvas, location: Offset(170, 300), color: Colors.blue);
    _drawDecorBall(canvas, location: Offset(230, 310), color: Colors.purple, radius: 10);
    _drawDecorBall(canvas, location: Offset(150, 370), color: Colors.grey.shade200, radius: 25);
    _drawDecorBall(canvas, location: Offset(208, 370), color: Colors.yellow.shade200);
    _drawDecorBall(canvas, location: Offset(275, 385), color: Colors.lime, radius: 18);
    _drawDecorBall(canvas, location: Offset(187, 135), color: Colors.amber, radius: 14);
  }

  void _drawNightSky(Canvas canvas) {
    canvas.drawPaint(Paint()..color = Colors.indigo);
  }

  void _drawSnowLand(Canvas canvas, Size size) {
    final painter = Paint()
      ..color = Colors.blue.shade100
      ..strokeWidth = 300;

    final dy = 600.0; //size.height - painter.strokeWidth / 2;

    final startPoint = Offset(0, dy);
    final endPoint = Offset(size.width, dy);

    canvas.drawLine(startPoint, endPoint, painter);
  }

  void _drawTrunk(Canvas canvas, Size size) {
    final painter = Paint()
      ..color = const Color(0xffE8763C)
      ..strokeWidth = 70;

    final dx = size.width / 2;

    final startPoint = Offset(dx, 200);
    final endPoint = Offset(dx, size.height - 100);

    canvas.drawLine(startPoint, endPoint, painter);
  }

  void _drawTopBranch(Canvas canvas, Size size) {
    final painter = Paint()..color = Colors.green;

    final topPoint = Offset(size.width / 2, 50);
    final leftPoint = Offset(size.width / 2 - 80, 200);
    final rightPoint = Offset(size.width / 2 + 80, 200);

    final path = Path()
      ..moveTo(topPoint.dx, topPoint.dy)
      ..lineTo(leftPoint.dx, leftPoint.dy)
      ..lineTo(rightPoint.dx, rightPoint.dy)
      ..close();

    canvas.drawPath(path, painter);
  }

  void _drawMiddleBranch(Canvas canvas, Size size) {
    final painter = Paint()..color = Colors.green;

    final topPoint = Offset(size.width / 2, 90);
    final leftPoint = Offset(size.width / 2 - 100, 310);
    final rightPoint = Offset(size.width / 2 + 100, 310);

    final path = Path()
      ..moveTo(topPoint.dx, topPoint.dy)
      ..lineTo(leftPoint.dx, leftPoint.dy)
      ..lineTo(rightPoint.dx, rightPoint.dy)
      ..close();

    canvas.drawPath(path, painter);
  }

  void _drawBottomBranch(Canvas canvas, Size size) {
    final painter = Paint()..color = Colors.green;

    final topPoint = Offset(size.width / 2, 200);
    final leftPoint = Offset(size.width / 2 - 120, 420);
    final rightPoint = Offset(size.width / 2 + 120, 420);

    final path = Path()
      ..moveTo(topPoint.dx, topPoint.dy)
      ..lineTo(leftPoint.dx, leftPoint.dy)
      ..lineTo(rightPoint.dx, rightPoint.dy)
      ..close();

    canvas.drawPath(path, painter);
  }

  void _drawDecorBall(
    Canvas canvas, {
    required Offset location,
    required Color color,
    double radius = 20,
  }) {
    final painter = Paint()..color = color;

    canvas.drawCircle(
      location,
      radius,
      painter,
    );
  }

  void _drawGiftBox(
    Canvas canvas, {
    required Offset center,
    required Color color,
    required Size boxSize,
  }) {
    final painter = Paint()..color = color;

    final rect = Rect.fromCenter(center: center, width: boxSize.width, height: boxSize.height);

    canvas.drawRect(rect, painter);
  }

}
