import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:new_year_app/data/constants.dart';

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
        title: Text('Snowflakes with Vertices $snowflakeTestCount'),
      ),
      body: SafeArea(
        child: Center(
          child: SizedBox(
            height: 620,
            width: 420,
            child: CustomPaint(
              painter: SnowflakePainter(snowflakes: _snowflakes),
            ),
          ),
        ),
      ),
    );
  }
}

class Snowflake {
  Offset position;
  double speed;
  double radius;
  late final Vertices vertices;

  Snowflake({
    required this.position,
    required this.speed,
    required this.radius,
  }) {
    vertices = _createCircleVertices(position, radius);
  }

  void updatePosition(double maxHeight) {
    position = Offset(position.dx, (position.dy + speed) % maxHeight);
    // Обновляем центральную позицию в вершинах
    vertices = _createCircleVertices(position, radius);
  }

  Vertices _createCircleVertices(Offset center, double radius) {
    const int segments = 12;
    final angleStep = (2 * pi) / segments;
    final positions = <Offset>[center];

    for (int i = 0; i <= segments; i++) {
      final angle = i * angleStep;
      positions.add(
        Offset(
          center.dx + radius * cos(angle),
          center.dy + radius * sin(angle),
        ),
      );
    }

    return Vertices(VertexMode.triangleFan, positions);
  }
}

class SnowflakePainter extends CustomPainter {
  final List<Snowflake> snowflakes;

  SnowflakePainter({required this.snowflakes});

  @override
  void paint(Canvas canvas, Size size) {
    _drawNightSky(canvas, size);
    _drawSnowflakes(canvas);
  }

  void _drawNightSky(Canvas canvas, Size size) {
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = Colors.indigo,
    );
  }

  void _drawSnowflakes(Canvas canvas) {
    final verticesList = <Vertices>[];

    for (var snowflake in snowflakes) {
      verticesList.add(_createCircleVertices(snowflake.position, snowflake.radius));
    }

    final paint = Paint()..color = Colors.white;

    for (var vertices in verticesList) {
      canvas.drawVertices(vertices, BlendMode.srcOver, paint);
    }
  }

  Vertices _createCircleVertices(Offset center, double radius) {
    const int segments = 12; // Количество сегментов круга
    final angleStep = (2 * pi) / segments;
    final positions = <Offset>[center];
    final colors = <Color>[Colors.white.withOpacity(0.9)];

    // Добавляем точки круга
    for (int i = 0; i <= segments; i++) {
      final angle = i * angleStep;
      positions.add(
        Offset(
          center.dx + radius * cos(angle),
          center.dy + radius * sin(angle),
        ),
      );
      colors.add(Colors.white.withOpacity(0.9));
    }

    return Vertices(
      VertexMode.triangleFan,
      positions,
      colors: colors,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
