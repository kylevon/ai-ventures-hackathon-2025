import 'package:flutter/material.dart';
import '../widgets/calendar_widget.dart';
import '../../domain/models/calendar_event.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  final List<CalendarEvent> _events =
      []; // This should be managed by a state management solution

  void _handleDaySelected(DateTime selectedDay) {
    // Handle day selection
  }

  void _handleEventTap(CalendarEvent event) {
    // Handle event tap
  }

  void _handleAddEvent(DateTime selectedDay) {
    // Handle add event
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: CalendarWidget(
        events: _events,
        onDaySelected: _handleDaySelected,
        onEventTap: _handleEventTap,
        onAddEvent: _handleAddEvent,
      ),
    );
  }
}
