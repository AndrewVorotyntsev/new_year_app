import 'dart:math';
import 'dart:ui';

import 'dart:ui' as ui;

import 'package:flutter/material.dart';

int _snowflakeCount = 100;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth != 0) {
          return MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(
              useMaterial3: true,
            ),
            home: const HomeScreen(),
          );
        }
        return Container();
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return ScenePage(constraints: constraints);
      },
    );
  }
}

class ScenePage extends StatefulWidget {
  final BoxConstraints constraints;
  const ScenePage({super.key, required this.constraints});

  @override
  State<ScenePage> createState() => _ScenePageState();
}

class _ScenePageState extends State<ScenePage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<Snowflake> _snowflakes = [];

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
            _random.nextDouble() * widget.constraints.maxWidth,
            _random.nextDouble() * widget.constraints.maxHeight,
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
          (snowflake.position.dy + snowflake.speed) % widget.constraints.maxHeight, // Перемещение вниз
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
        child: Align(
          alignment: Alignment.topCenter,
          child: LayoutBuilder(builder: (context, constraints) {
            return CustomPaint(
              painter: NewYearTreePainter(snowflakes: _snowflakes),
              child: SizedBox(
                height: 620,
                width: 420,
                child: ColoredBox(
                  color: Colors.red.withOpacity(0.1),
                  child: RepaintBoundary(
                    child: CustomPaint(
                      painter: NewYearTreePainter(snowflakes: _snowflakes),
                      willChange: true,
                    ),
                  ),
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

class NewYearTreePainter extends CustomPainter {
  final List<Snowflake> snowflakes;

  NewYearTreePainter({required this.snowflakes});

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;

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

    canvas.save();
    canvas.saveLayer(null, Paint());
    _drawSnowflakes(canvas);
    canvas.restore();
  }

  void _drawSnowflakes(Canvas canvas) {
    final painter = Paint()..color = Colors.white;

    for (var snowflake in snowflakes) {
      canvas.drawCircle(snowflake.position, snowflake.radius, painter);
    }
  }

  void _drawNightSky(Canvas canvas) {
    canvas.drawPaint(Paint()..color = Colors.indigo);
  }

  void _drawSnowLand(Canvas canvas, Size size) {
    final painter = Paint()
      ..color = Colors.blue.shade100
      ..strokeWidth = 300;

    const dy = 600.0;

    const startPoint = Offset(0, dy);
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
    final topPoint = Offset(size.width / 2, 90);
    final leftPoint = Offset(size.width / 2 - 100, 310);
    final rightPoint = Offset(size.width / 2 + 100, 310);

    final path = Path()
      ..moveTo(topPoint.dx, topPoint.dy)
      ..lineTo(leftPoint.dx, leftPoint.dy)
      ..lineTo(rightPoint.dx, rightPoint.dy)
      ..close();

    final shader = LinearGradient(
      colors: [
        Colors.green,
        Colors.green,
        Colors.green,
        Colors.green,
        Colors.yellow,
        Colors.green,
        Colors.yellow,
        Colors.green,
        Colors.yellow,
        Colors.green,
      ],
      stops: [
        0.0, // Зеленый
        0.08, // Желтый (тонкая линия)
        0.18, // Зеленый
        0.26, // Желтый (тонкая линия)
        0.38, // Зеленый
        0.46, // Желтый (тонкая линия)
        0.58, // Зеленый
        0.66, // Желтый (тонкая линия)
        0.78, // Зеленый
        0.86, // Желтый (тонкая линия)
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ).createShader(Rect.fromPoints(topPoint, rightPoint));

    final painter = Paint()..shader = shader;

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

    final rect = Rect.fromCenter(
      center: center,
      width: boxSize.width,
      height: boxSize.height,
    );

    canvas.drawRect(rect, painter);
  }
}
