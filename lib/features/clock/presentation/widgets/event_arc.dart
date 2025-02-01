import 'package:flutter/material.dart';
import 'dart:math' as math;

class EventArc extends StatefulWidget {
  final double radius;
  final double startAngle;
  final double endAngle;
  final Color color;
  final Widget child;
  final VoidCallback? onTap;
  final String tooltip;

  const EventArc({
    super.key,
    required this.radius,
    required this.startAngle,
    required this.endAngle,
    required this.color,
    required this.child,
    required this.tooltip,
    this.onTap,
  });

  @override
  State<EventArc> createState() => _EventArcState();
}

class _EventArcState extends State<EventArc> {
  bool _isHovered = false;
  final GlobalKey _paintKey = GlobalKey();

  bool _isPointInArc(Offset point) {
    final RenderBox? renderBox =
        _paintKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return false;

    final size = renderBox.size;
    final center = Offset(size.width / 2, size.height / 2);
    final dx = point.dx - center.dx;
    final dy = point.dy - center.dy;

    // Calculate the angle of the point relative to center
    var pointAngle = math.atan2(dy, dx);
    // Convert to match the clock's coordinate system (0 at right, clockwise from top)
    pointAngle = (-pointAngle + math.pi / 2) % (2 * math.pi);

    // Calculate the distance from center
    final distance = math.sqrt(dx * dx + dy * dy);

    // Check if point is within the arc's radius bounds (with some padding for easier hovering)
    final isInRadius =
        (distance >= widget.radius - 12) && (distance <= widget.radius + 12);

    // Get the angles in the same coordinate system
    var startAngle = widget.startAngle;
    var endAngle = widget.endAngle;
    var sweep = endAngle - startAngle;
    if (sweep < 0) {
      sweep += 2 * math.pi;
    }
    endAngle = startAngle + sweep;

    // Normalize point angle to be in the same range as the start angle
    if (pointAngle < startAngle) {
      pointAngle += 2 * math.pi;
    } else if (pointAngle > endAngle) {
      pointAngle -= 2 * math.pi;
    }

    print(
        'Hover - Point: ${pointAngle * 180 / math.pi}°, Start: ${startAngle * 180 / math.pi}°, End: ${endAngle * 180 / math.pi}°');
    return isInRadius && pointAngle >= startAngle && pointAngle <= endAngle;
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (event) {
        if (_isPointInArc(event.localPosition)) {
          setState(() => _isHovered = true);
        }
      },
      onHover: (event) {
        final isInArc = _isPointInArc(event.localPosition);
        if (isInArc != _isHovered) {
          setState(() => _isHovered = isInArc);
        }
      },
      onExit: (_) {
        if (_isHovered) {
          setState(() => _isHovered = false);
        }
      },
      child: GestureDetector(
        onTapUp: (details) {
          if (_isPointInArc(details.localPosition)) {
            widget.onTap?.call();
          }
        },
        child: Stack(
          children: [
            SizedBox(
              width: widget.radius * 2,
              height: widget.radius * 2,
              child: CustomPaint(
                key: _paintKey,
                painter: _EventArcPainter(
                  radius: widget.radius,
                  startAngle: widget.startAngle,
                  endAngle: widget.endAngle,
                  color: widget.color,
                  isHovered: _isHovered,
                ),
                child: widget.child,
              ),
            ),
            if (_isHovered)
              Positioned(
                top: widget.radius,
                left: widget.radius,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    widget.tooltip,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _EventArcPainter extends CustomPainter {
  final double radius;
  final double startAngle;
  final double endAngle;
  final Color color;
  final bool isHovered;

  _EventArcPainter({
    required this.radius,
    required this.startAngle,
    required this.endAngle,
    required this.color,
    required this.isHovered,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(isHovered ? 1.0 : 0.7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = isHovered ? 20.0 : 15.0
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);

    // Calculate sweep angle
    var sweep = endAngle - startAngle;
    // Ensure we're drawing in the clockwise direction
    if (sweep < 0) {
      sweep += 2 * math.pi;
    }

    // Draw shadow for hovered state
    if (isHovered) {
      final shadowPaint = Paint()
        ..color = color.withOpacity(0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 25.0
        ..strokeCap = StrokeCap.round
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweep,
        false,
        shadowPaint,
      );
    }

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweep,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _EventArcPainter oldDelegate) {
    return oldDelegate.isHovered != isHovered ||
        oldDelegate.startAngle != startAngle ||
        oldDelegate.endAngle != endAngle ||
        oldDelegate.color != color;
  }
}
