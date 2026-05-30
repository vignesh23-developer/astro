import 'dart:math';
import 'package:flutter/material.dart';

class CentralPlayPainter extends CustomPainter {
  final double animationValue;

  CentralPlayPainter({required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = 50.0;

    // Draw soft glowing circle behind play button
    final glowPaint = Paint()
      ..color = Colors.blueAccent.withOpacity(0.2 + 0.3 * sin(animationValue * pi))
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius + 20, glowPaint);

    // Draw main circle
    final circlePaint = Paint()
      ..color = Colors.blueAccent.withOpacity(0.6)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius, circlePaint);

    // Draw play icon
    final playPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final iconSize = radius * 0.8;
    final path = Path();
    path.moveTo(center.dx - iconSize / 3, center.dy - iconSize / 2);
    path.lineTo(center.dx - iconSize / 3, center.dy + iconSize / 2);
    path.lineTo(center.dx + iconSize / 2, center.dy);
    path.close();
    canvas.drawPath(path, playPaint);

    // Optional: tiny floating dots for subtle background effect
    final random = _SeededRandom(42);
    final dotPaint = Paint()..color = Colors.white.withOpacity(0.2);
    for (int i = 0; i < 60; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final r = 1 + random.nextDouble() * 2;
      canvas.drawCircle(Offset(x, y), r, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CentralPlayPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}

// Seeded random for consistent dot positions
class _SeededRandom {
  int _seed;
  _SeededRandom(this._seed);

  double nextDouble() {
    _seed = (_seed * 9301 + 49297) % 233280;
    return _seed / 233280.0;
  }
}
