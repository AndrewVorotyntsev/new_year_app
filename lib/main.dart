import 'dart:math';
import 'dart:ui';

import 'dart:ui' as ui;

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<Snowflake> _snowflakes = [];
  final int _snowflakeCount = 100;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();

    // Создаем анимационный контроллер
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 16),
    )..addListener(() {
      _updateSnowflakes();
    });

    // Генерируем снежинки
    _generateSnowflakes();

    _controller.repeat(); // Запускаем анимацию
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _generateSnowflakes() {
    for (int i = 0; i < _snowflakeCount; i++) {
      _snowflakes.add(
        Snowflake(
          position: Offset(
            _random.nextDouble() * 420, // Ширина холста
            _random.nextDouble() * 620, // Высота холста
          ),
          speed: _random.nextDouble() * 2 + 1, // Скорость падения
          radius: _random.nextDouble() * 3 + 2, // Размер снежинки
        ),
      );
    }
  }

  void _updateSnowflakes() {
    for (var snowflake in _snowflakes) {
      setState(() {
        snowflake.position = Offset(
          snowflake.position.dx,
          (snowflake.position.dy + snowflake.speed) % 620, // Перемещение вниз
        );
      });
    }
  }

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
            return SizedBox(
              height: 620,
              width: 420,
              child: RepaintBoundary(
                child: CustomPaint(
                  painter: MyPainter(snowflakes: _snowflakes),
                  willChange: true,
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

class Snowflake {
  Offset position;
  double speed;
  double radius;

  Snowflake({
    required this.position,
    required this.speed,
    required this.radius,
  });
}

class MyPainter extends CustomPainter {
  final List<Snowflake> snowflakes;

  MyPainter({required this.snowflakes});

  @override
  void paint(Canvas canvas, Size size) {
    _drawNightSky(canvas);
    _drawSnowLand(canvas, size);
    _drawTrunk(canvas, size);
    _drawBottomBranch(canvas, size);
    _drawMiddleBranch(canvas, size);
    _drawTopBranch(canvas, size);
    _drawDecorBalls(canvas);

    _drawGiftBox(canvas, center: Offset(100, size.height - 100), color: Colors.red, boxSize: Size(50, 50));
    _drawGiftBox(canvas, center: Offset(300, size.height - 100), color: Colors.orange, boxSize: Size(100, 80));
    _drawGiftBox(canvas, center: Offset(300, size.height - 100), color: Colors.orange, boxSize: Size(100, 80));
    _drawGiftBox(canvas, center: Offset(180, size.height - 100), color: Colors.lightGreen, boxSize: Size(70, 70));

    _drawSnowflakes(canvas);
  }

  void _drawSnowflakes(Canvas canvas) {
    final painter = Paint()..color = Colors.white;

    for (var snowflake in snowflakes) {
      canvas.drawCircle(snowflake.position, snowflake.radius, painter);
    }
  }

  // Остальные методы рисования без изменений
  void _drawNightSky(Canvas canvas) {
    canvas.drawPaint(Paint()..color = Colors.indigo);
  }

  void _drawSnowLand(Canvas canvas, Size size) {
    final painter = Paint()
      ..color = Colors.blue.shade100
      ..strokeWidth = 300;

    final dy = 600.0;

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
    final topPoint = Offset(size.width / 2, 50);
    final leftPoint = Offset(size.width / 2 - 80, 200);
    final rightPoint = Offset(size.width / 2 + 80, 200);

    final painter = Paint()
      ..shader = ui.Gradient.radial(
        topPoint,
        100,
        [Colors.white, Colors.green],
      );

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
    final topPoint = Offset(size.width / 2, 200);
    final leftPoint = Offset(size.width / 2 - 120, 420);
    final rightPoint = Offset(size.width / 2 + 120, 420);

    final painter = Paint()
      ..shader = ui.Gradient.linear(
        Offset(size.width / 2, 320),
        Offset(size.width / 2, 420),
        [
          Colors.green,
          Colors.white,
        ],
      );

    final path = Path()
      ..moveTo(topPoint.dx, topPoint.dy)
      ..lineTo(leftPoint.dx, leftPoint.dy)
      ..lineTo(rightPoint.dx, rightPoint.dy)
      ..close();

    canvas.drawPath(path, painter);
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

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
