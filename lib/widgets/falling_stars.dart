import 'dart:math';
import 'package:flutter/material.dart';

class FallingStars extends StatefulWidget {
  const FallingStars({super.key});

  @override
  State<FallingStars> createState() => _FallingStarsState();
}

class _FallingStarsState extends State<FallingStars>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<_Star> stars = [];
  final Random random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();

    // Create stars
    for (int i = 0; i < 20; i++) {
      stars.add(
        _Star(
          x: random.nextDouble(),
          delay: random.nextDouble(),
          size: 15 + random.nextDouble() * 15,
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: _StarsPainter(stars, _controller.value),
          size: Size.infinite,
        );
      },
    );
  }
}

class _Star {
  final double x;
  final double delay;
  final double size;

  _Star({required this.x, required this.delay, required this.size});
}

class _StarsPainter extends CustomPainter {
  final List<_Star> stars;
  final double progress;

  _StarsPainter(this.stars, this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.amber.shade200;

    for (final star in stars) {
      // Use modulo to create continuous falling effect
      double adjustedProgress = (progress + star.delay) % 1.0;
      final x = star.x * size.width;
      final y = adjustedProgress * size.height;
      canvas.drawCircle(Offset(x, y), star.size / 2, paint);
    }
  }

  @override
  bool shouldRepaint(_StarsPainter oldDelegate) => true;
}

