import 'package:flutter/material.dart';
import 'dart:math' as math;

class EventArc extends StatelessWidget {
  final double radius;
  final double startAngle;
  final double endAngle;
  final Color color;
  final Widget child;

  const EventArc({
    super.key,
    required this.radius,
    required this.startAngle,
    required this.endAngle,
    required this.color,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _EventArcPainter(
        radius: radius,
        startAngle:
            startAngle - (math.pi / 2), // Adjust to start from 12 o'clock
        endAngle: endAngle - (math.pi / 2),
        color: color,
      ),
      child: child,
    );
  }
}

class _EventArcPainter extends CustomPainter {
  final double radius;
  final double startAngle;
  final double endAngle;
  final Color color;

  _EventArcPainter({
    required this.radius,
    required this.startAngle,
    required this.endAngle,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 15.0
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      endAngle - startAngle,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
