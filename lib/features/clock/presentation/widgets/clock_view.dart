import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../../../core/constants/event_types.dart';
import '../../../shared/domain/models/event.dart';

class ClockView extends StatelessWidget {
  final List<Event> events;
  final Function(Event)? onEventTap;
  final double radius;

  const ClockView({
    super.key,
    required this.events,
    this.onEventTap,
    this.radius = 150,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 20),
          _buildClockFace(context),
          const SizedBox(height: 20),
          _buildLegend(context),
        ],
      ),
    );
  }

  Widget _buildClockFace(BuildContext context) {
    return Center(
      child: SizedBox(
        width: radius * 2,
        height: radius * 2,
        child: Stack(
          children: [
            _buildClockCircle(),
            _buildHourMarkers(),
            ...events.map((event) => _buildEventArc(context, event)),
            _buildClockCenter(),
          ],
        ),
      ),
    );
  }

  Widget _buildClockCircle() {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.grey[300]!,
          width: 2,
        ),
      ),
    );
  }

  Widget _buildHourMarkers() {
    return Stack(
      children: List.generate(24, (index) {
        final angle = (index * 15) * math.pi / 180;
        final isMainHour = index % 6 == 0;
        final markerLength = isMainHour ? 15.0 : 8.0;
        final textRadius = radius - 25;

        return Stack(
          children: [
            Center(
              child: Transform.rotate(
                angle: angle,
                child: Transform.translate(
                  offset: Offset(0, -radius),
                  child: Container(
                    height: markerLength,
                    width: 2,
                    color: isMainHour ? Colors.black87 : Colors.grey[400],
                  ),
                ),
              ),
            ),
            if (isMainHour)
              Center(
                child: Transform.translate(
                  offset: Offset(
                    (textRadius) * math.cos(angle - math.pi / 2),
                    (textRadius) * math.sin(angle - math.pi / 2),
                  ),
                  child: Text(
                    '${(index ~/ 6) * 6}',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
          ],
        );
      }),
    );
  }

  Widget _buildEventArc(BuildContext context, Event event) {
    final startAngle = _timeToAngle(event.date);
    final endAngle = startAngle + (math.pi / 36); // 30-minute duration

    print(
        'Event: ${event.title} at ${event.date.hour}:${event.date.minute} -> angle: ${startAngle * 180 / math.pi}°');

    return Center(
      child: GestureDetector(
        onTap: () => onEventTap?.call(event),
        child: CustomPaint(
          size: Size(radius * 2, radius * 2),
          painter: EventArcPainter(
            radius: radius - 30,
            startAngle: startAngle,
            endAngle: endAngle,
            color: event.color,
          ),
        ),
      ),
    );
  }

  Widget _buildClockCenter() {
    return Center(
      child: Container(
        width: 10,
        height: 10,
        decoration: const BoxDecoration(
          color: Colors.black87,
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  Widget _buildLegend(BuildContext context) {
    final eventsByType = <EventType, List<Event>>{};
    for (final event in events) {
      eventsByType.putIfAbsent(event.type, () => []).add(event);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Today\'s Activities',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          ...eventsByType.entries.map(
            (entry) => _buildLegendItem(context, entry.key, entry.value),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(
    BuildContext context,
    EventType type,
    List<Event> typeEvents,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: type.color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '${type.displayName} (${typeEvents.length})',
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  double _timeToAngle(DateTime time) {
    // Convert time to minutes since midnight (0-1439)
    final minutes = time.hour * 60 + time.minute;
    // Convert to angle where:
    // - 0 minutes (midnight) = -π/2 (top of clock)
    // - 360 minutes (6:00) = 0 (right side of clock)
    // - 720 minutes (12:00) = π/2 (bottom of clock)
    // - 1080 minutes (18:00) = π (left side of clock)
    return (minutes * 2 * math.pi / 1440) - math.pi / 2;
  }
}

class EventArcPainter extends CustomPainter {
  final double radius;
  final double startAngle;
  final double endAngle;
  final Color color;

  EventArcPainter({
    required this.radius,
    required this.startAngle,
    required this.endAngle,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(0.7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20.0
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(
        center: Offset(size.width / 2, size.height / 2),
        radius: radius,
      ),
      startAngle,
      endAngle - startAngle,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(EventArcPainter oldDelegate) {
    return oldDelegate.radius != radius ||
        oldDelegate.startAngle != startAngle ||
        oldDelegate.endAngle != endAngle ||
        oldDelegate.color != color;
  }
}
