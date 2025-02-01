import 'package:flutter/material.dart';
import '../../domain/models/calendar_event.dart';
import 'event_card.dart';

class EventsList extends StatelessWidget {
  final DateTime selectedDay;
  final List<CalendarEvent> events;
  final void Function(CalendarEvent)? onEventTap;
  final void Function(DateTime)? onAddEvent;

  const EventsList({
    super.key,
    required this.selectedDay,
    required this.events,
    this.onEventTap,
    this.onAddEvent,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        _buildHeader(context),
        const SizedBox(height: 16),
        _buildEventsList(),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey[300]!,
            width: 1,
          ),
        ),
      ),
      child: _buildHeaderContent(context),
    );
  }

  Widget _buildHeaderContent(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildHeaderText(context),
        _buildAddButton(),
      ],
    );
  }

  Widget _buildHeaderText(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Events for ${selectedDay.day}/${selectedDay.month}/${selectedDay.year}',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          '${events.length} events',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
              ),
        ),
      ],
    );
  }

  Widget _buildAddButton() {
    return Material(
      color: Colors.blue[500]!.withOpacity(0.1),
      borderRadius: BorderRadius.circular(20),
      child: IconButton(
        icon: Icon(
          Icons.add_circle_outline,
          color: Colors.blue[500],
        ),
        onPressed: () => onAddEvent?.call(selectedDay),
        tooltip: 'Add event',
      ),
    );
  }

  Widget _buildEventsList() {
    if (events.isEmpty) {
      return _buildEmptyState();
    }
    return Column(
      children: events
          .map((event) => EventCard(
                event: event,
                onTap: onEventTap,
              ))
          .toList(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.event_available,
              size: 48,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No events for this day',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
