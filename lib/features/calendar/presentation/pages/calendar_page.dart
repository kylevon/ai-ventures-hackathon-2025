import 'package:flutter/material.dart';
import 'package:michro_flutter/features/shared/domain/models/event.dart';
import '../screens/calendar_screen.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  void _handleEventsChanged(List<Event> events) {
    // Handle events changed if needed
  }

  void _handleSyncStateChanged(bool isSyncing) {
    // Handle sync state if needed
  }

  @override
  Widget build(BuildContext context) {
    return CalendarScreen(
      onEventsChanged: _handleEventsChanged,
      onSyncStateChanged: _handleSyncStateChanged,
    );
  }
}
