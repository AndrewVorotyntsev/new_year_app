/// Отрисовка треугольников с помощью Painter'а

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:new_year_app/data/constants.dart';
import 'package:new_year_app/info_overlay.dart';

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
      home: const HomeScreen(),
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

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 16),
    )..addListener(() {
        _updateSnowflakes();
      });

    _generateSnowflakes();

    _controller.repeat(); // Запускаем анимацию
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _generateSnowflakes() {
    for (int i = 0; i < snowflakeTestCount; i++) {
      _snowflakes.add(
        Snowflake(
          position: Offset(
            _random.nextDouble() * widget.constraints.maxWidth,
            _random.nextDouble() * widget.constraints.maxHeight,
          ),
          speed: _random.nextDouble() * 2 + 1, // Скорость падения
          size: _random.nextDouble() * 3 + 2, // Размер треугольника
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
        title: Text('Example'),
      ),
      body: InfoOverlay(
        info: 'Painter Triangles $snowflakeTestCount',
        child: SafeArea(
          child: Align(
            alignment: Alignment.topCenter,
            child: LayoutBuilder(builder: (context, constraints) {
              return CustomPaint(
                painter: TrianglePainter(snowflakes: _snowflakes),
                child: SizedBox(
                  height: 620,
                  width: 420,
                  child: ColoredBox(
                    color: Colors.blue.withOpacity(0.1),
                    child: RepaintBoundary(
                      child: CustomPaint(
                        painter: TrianglePainter(snowflakes: _snowflakes),
                        willChange: true,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class Snowflake {
  Offset position;
  double speed;
  double size;

  Snowflake({
    required this.position,
    required this.speed,
    required this.size,
  });
}

class TrianglePainter extends CustomPainter {
  final List<Snowflake> snowflakes;

  TrianglePainter({required this.snowflakes});

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;

  @override
  void paint(Canvas canvas, Size size) {
    _drawNightSky(canvas);
    _drawSnowflakes(canvas);
  }

  void _drawSnowflakes(Canvas canvas) {
    final painter = Paint()..color = Colors.white;

    for (var snowflake in snowflakes) {
      _drawSnowflakeTriangle(canvas, snowflake.position, snowflake.size, painter);
    }
  }

  // Отрисовка треугольника
  void _drawSnowflakeTriangle(Canvas canvas, Offset center, double size, Paint painter) {
    final path = Path();

    // Треугольник: вершины по углам
    path.moveTo(center.dx, center.dy - size / 2); // верхняя вершина
    path.lineTo(center.dx - size / 2, center.dy + size / 2); // нижний левый угол
    path.lineTo(center.dx + size / 2, center.dy + size / 2); // нижний правый угол
    path.close();

    canvas.drawPath(path, painter);
  }

  void _drawNightSky(Canvas canvas) {
    canvas.drawPaint(Paint()..color = Colors.indigo);
  }
}
