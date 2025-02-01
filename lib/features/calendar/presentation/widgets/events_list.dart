import 'package:flutter/material.dart';
import 'package:michro_flutter/features/shared/domain/models/event.dart';
import 'event_card.dart';

class EventsList extends StatelessWidget {
  final DateTime selectedDay;
  final List<Event> events;
  final Function(Event)? onEventTap;
  final Function(DateTime)? onAddEvent;

  const EventsList({
    super.key,
    required this.selectedDay,
    required this.events,
    this.onEventTap,
    this.onAddEvent,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeader(context),
        const SizedBox(height: 8),
        Expanded(
          child: events.isEmpty
              ? _buildEmptyState(context)
              : _buildEventsList(context),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Events',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => onAddEvent?.call(selectedDay),
            tooltip: 'Add event',
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.event_busy,
            size: 48,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No events for this day',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          const SizedBox(height: 8),
          TextButton.icon(
            onPressed: () => onAddEvent?.call(selectedDay),
            icon: const Icon(Icons.add),
            label: const Text('Add Event'),
          ),
        ],
      ),
    );
  }

  Widget _buildEventsList(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: events.length,
      itemBuilder: (context, index) {
        final event = events[index];
        return EventCard(
          event: event,
          onTap: () => onEventTap?.call(event),
        );
      },
    );
  }
}
