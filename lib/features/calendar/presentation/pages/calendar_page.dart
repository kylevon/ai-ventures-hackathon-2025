import 'package:flutter/material.dart';
import '../widgets/calendar_widget.dart';
import '../../domain/models/calendar_event.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  // TODO: Replace with actual data from a service
  final List<CalendarEvent> _mockEvents = [
    CalendarEvent(
      title: 'Morning Medication',
      description: 'Take 2 pills with water',
      startDate: DateTime.now(),
      startTime: const TimeOfDay(hour: 8, minute: 0),
      type: EventType.medication,
      isRecurring: true,
      recurrenceRule: 'FREQ=DAILY',
    ),
    CalendarEvent(
      title: 'Breakfast',
      description: 'Oatmeal with fruits',
      startDate: DateTime.now(),
      startTime: const TimeOfDay(hour: 9, minute: 0),
      type: EventType.meal,
    ),
    CalendarEvent(
      title: 'Evening Walk',
      description: '30 minutes moderate pace',
      startDate: DateTime.now(),
      startTime: const TimeOfDay(hour: 18, minute: 0),
      endTime: const TimeOfDay(hour: 18, minute: 30),
      type: EventType.exercise,
    ),
    CalendarEvent(
      title: 'Blood Pressure Check',
      startDate: DateTime.now().add(const Duration(days: 1)),
      startTime: const TimeOfDay(hour: 10, minute: 0),
      type: EventType.measurement,
    ),
    CalendarEvent(
      title: 'Doctor Appointment',
      description: 'Annual checkup',
      startDate: DateTime.now().add(const Duration(days: 5)),
      startTime: const TimeOfDay(hour: 14, minute: 30),
      location: 'City Medical Center',
      type: EventType.appointment,
    ),
  ];

  void _handleDaySelected(DateTime selectedDay) {
    // TODO: Implement day selection handling
  }

  void _handleEventTap(CalendarEvent event) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(event.title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (event.description != null) ...[
              Text(event.description!),
              const SizedBox(height: 8),
            ],
            Text('Time: ${event.timeRange}'),
            if (event.location != null) ...[
              const SizedBox(height: 8),
              Text('Location: ${event.location}'),
            ],
            if (event.isRecurring) ...[
              const SizedBox(height: 8),
              const Text('Recurring event'),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
          TextButton(
            onPressed: () {
              // TODO: Implement edit functionality
              Navigator.of(context).pop();
            },
            child: const Text('Edit'),
          ),
        ],
      ),
    );
  }

  void _handleAddEvent(DateTime selectedDay) {
    // TODO: Implement add event functionality
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Event'),
        content: const Text('Event creation coming soon...'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // TODO: Implement filter functionality
            },
          ),
        ],
      ),
      body: CalendarWidget(
        events: _mockEvents,
        onDaySelected: _handleDaySelected,
        onEventTap: _handleEventTap,
        onAddEvent: _handleAddEvent,
      ),
    );
  }
} 