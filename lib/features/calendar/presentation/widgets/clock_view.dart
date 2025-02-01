import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../domain/models/calendar_event.dart';
import 'event_arc.dart';

class ClockView extends StatelessWidget {
  final List<CalendarEvent> events;
  final double radius;
  final Function(CalendarEvent)? onEventAdded;
  final Function(CalendarEvent)? onEventUpdated;
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
            _buildCurrentTimeLine(),
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

  Widget _buildEventArc(BuildContext context, CalendarEvent event) {
    if (event.startTime == null) return const SizedBox.shrink();

    final startAngle = _timeToAngle(event.startTime!);
    final endAngle = event.endTime != null
        ? _timeToAngle(event.endTime!)
        : startAngle + (math.pi / 72); // Default to 15-minute duration

    return GestureDetector(
      onTap: () => _showEventDetails(context, event),
      child: EventArc(
        radius: radius - 20,
        startAngle: startAngle,
        endAngle: endAngle,
        color: event.color.withOpacity(0.7),
        child: Tooltip(
          message: '${event.title} (${event.timeRange})',
          child: const SizedBox.shrink(),
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

  Widget _buildCurrentTimeLine() {
    final now = TimeOfDay.now();
    final angle = _timeToAngle(now);

    return Center(
      child: Transform.rotate(
        angle: angle - (math.pi / 2), // Adjust to start from 12 o'clock
        child: Container(
          width: radius * 2,
          height: 2,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.red.withOpacity(0),
                Colors.red,
                Colors.red,
              ],
              stops: const [0.0, 0.1, 1.0],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLegend(BuildContext context) {
    final eventsByType = <EventType, List<CalendarEvent>>{};
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
      BuildContext context, EventType type, List<CalendarEvent> typeEvents) {
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

  void _showEventDetails(BuildContext context, CalendarEvent event) {
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
      BuildContext context, EventType type, List<CalendarEvent> typeEvents) {
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
    final minutes = time.hour * 60 + time.minute;
    return (minutes * math.pi) / 720; // 720 = 12 * 60 minutes
  }
}
