import 'package:flutter/material.dart';
import '../../domain/models/calendar_event.dart';
import 'event_type_utils.dart';

class EventCard extends StatelessWidget {
  final CalendarEvent event;
  final void Function(CalendarEvent)? onTap;

  const EventCard({
    super.key,
    required this.event,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: _buildCardContent(),
    );
  }

  Widget _buildCardContent() {
    return InkWell(
      onTap: () => onTap?.call(event),
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            _buildColorBar(),
            const SizedBox(width: 16),
            Expanded(child: _buildEventDetails()),
            if (event.isRecurring) _buildRecurringIcon(),
          ],
        ),
      ),
    );
  }

  Widget _buildColorBar() {
    return Container(
      width: 4,
      height: 48,
      decoration: BoxDecoration(
        color: event.color,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildEventDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildEventHeader(),
        if (event.description != null) _buildDescription(),
        const SizedBox(height: 8),
        _buildEventFooter(),
      ],
    );
  }

  Widget _buildEventHeader() {
    return Row(
      children: [
        Icon(
          EventTypeUtils.getEventTypeIcon(event.type),
          size: 16,
          color: event.color,
        ),
        const SizedBox(width: 8),
        Text(
          event.title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Widget _buildDescription() {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Text(
        event.description!,
        style: TextStyle(
          color: Colors.grey[600],
          fontSize: 14,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildEventFooter() {
    return Row(
      children: [
        _buildTimeInfo(),
        if (event.location != null) ...[
          const SizedBox(width: 16),
          _buildLocationInfo(),
        ],
      ],
    );
  }

  Widget _buildTimeInfo() {
    return Row(
      children: [
        Icon(Icons.access_time, size: 14, color: Colors.grey[600]),
        const SizedBox(width: 4),
        Text(
          event.timeRange,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildLocationInfo() {
    return Expanded(
      child: Row(
        children: [
          Icon(Icons.location_on, size: 14, color: Colors.grey[600]),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              event.location!,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecurringIcon() {
    return Padding(
      padding: const EdgeInsets.only(left: 16),
      child: Tooltip(
        message: 'Recurring event',
        child: Icon(
          Icons.repeat,
          size: 16,
          color: Colors.grey[600],
        ),
      ),
    );
  }
}
