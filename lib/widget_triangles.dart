/// Отрисовка треугольников с помощью виджетов

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
    for (int i = 0; i < snowflakeTestCount; i++) {
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
      snowflake.position = Offset(
        snowflake.position.dx,
        (snowflake.position.dy + snowflake.speed) % 620, // Перемещение вниз
      );
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Example'),
      ),
      body: InfoOverlay(
        info: 'Widget Triangles $snowflakeTestCount',
        child: SafeArea(
          child: Center(
            child: SizedBox(
              height: 620,
              width: 420,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Container(color: Colors.indigo), // Фон ночного неба
                  ),
                  ..._buildSnowflakes(), // Снежинки
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildSnowflakes() {
    return _snowflakes.map((snowflake) {
      return Positioned(
        left: snowflake.position.dx,
        top: snowflake.position.dy,
        child: SnowflakeWidget(size: snowflake.radius),
      );
    }).toList();
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

class SnowflakeWidget extends StatelessWidget {
  final double size;

  const SnowflakeWidget({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size * 2,
      height: size * 2,
      child: ClipPath(
        clipper: TriangleClipper(),
        child: Container(
          color: Colors.white, // Цвет треугольника
        ),
      ),
    );
  }
}

class TriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    // Треугольник: вершины по углам
    path.moveTo(size.width / 2, 0); // верхняя вершина
    path.lineTo(0, size.height); // нижний левый угол
    path.lineTo(size.width, size.height); // нижний правый угол
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
