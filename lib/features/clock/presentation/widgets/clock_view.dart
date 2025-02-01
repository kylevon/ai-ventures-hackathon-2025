import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../../shared/domain/models/event.dart';
import 'event_arc.dart';

class ClockView extends StatelessWidget {
  final List<Event> events;
  final double radius;
  final Function(Event)? onEventAdded;
  final Function(Event)? onEventUpdated;
  final Function(String)? onEventDeleted;

  const ClockView({
    super.key,
    required this.events,
    this.radius = 150,
    this.onEventAdded,
    this.onEventUpdated,
    this.onEventDeleted,
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
    if (event.startTime == null) return const SizedBox.shrink();

    final startAngle = _timeToAngle(event.startTime!);
    final endAngle = event.endTime != null
        ? _timeToAngle(event.endTime!)
        : startAngle + (math.pi / 72); // Default to 15-minute duration

    return Center(
      child: EventArc(
        radius: radius - 20,
        startAngle: startAngle,
        endAngle: endAngle,
        color: event.color,
        tooltip: '${event.title} (${event.timeRange})',
        onTap: () => _showEventDetails(context, event),
        child: const SizedBox.shrink(),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Today\'s Activities',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () => _showAddEventDialog(context),
                tooltip: 'Add new event',
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...eventsByType.entries.map(
              (entry) => _buildLegendItem(context, entry.key, entry.value)),
        ],
      ),
    );
  }

  Widget _buildLegendItem(
      BuildContext context, EventType type, List<Event> typeEvents) {
    return InkWell(
      onTap: () => _showTypeEvents(context, type, typeEvents),
      child: Padding(
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
      ),
    );
  }

  void _showEventDetails(BuildContext context, Event event) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(event.title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (event.description != null) Text(event.description!),
            const SizedBox(height: 8),
            Text('Time: ${event.timeRange}'),
            Text('Type: ${event.type.displayName}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              onEventDeleted?.call(event.id);
            },
            child: const Text('Delete'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showTypeEvents(
      BuildContext context, EventType type, List<Event> typeEvents) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(type.displayName),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: typeEvents.length,
            itemBuilder: (context, index) {
              final event = typeEvents[index];
              return ListTile(
                title: Text(event.title),
                subtitle: Text(event.timeRange),
                leading: Icon(
                  Icons.circle,
                  color: type.color,
                  size: 12,
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  _showEventDetails(context, event);
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showAddEventDialog(BuildContext context) {
    // TODO: Implement add event dialog
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Add event functionality coming soon')),
    );
  }

  double _timeToAngle(TimeOfDay time) {
    // Convert time to minutes since midnight (0-1439)
    final minutes = time.hour * 60 + time.minute;
    // Convert to angle where:
    // - 0 minutes (midnight) = -π/2 (top of clock)
    // - 360 minutes (6:00) = 0 (right side of clock)
    // - 720 minutes (12:00) = π/2 (bottom of clock)
    // - 1080 minutes (18:00) = π (left side of clock)
    final angle = (minutes * 2 * math.pi / 1440) - math.pi / 2;
    print(
        'Time ${time.hour}:${time.minute.toString().padLeft(2, '0')} -> angle: ${angle * 180 / math.pi}°');
    return angle;
  }
}
