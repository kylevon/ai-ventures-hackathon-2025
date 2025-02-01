import 'package:flutter/material.dart';
import 'package:michro_flutter/features/shared/domain/models/event.dart';
import '../screens/calendar_screen.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  bool _isSyncing = false;

  void _handleEventsChanged(List<Event> events) {
    // Handle events changed if needed
  }

  void _handleSyncStateChanged(bool isSyncing) {
    setState(() => _isSyncing = isSyncing);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar'),
        actions: [
          if (_isSyncing)
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            ),
        ],
      ),
      body: CalendarScreen(
        onEventsChanged: _handleEventsChanged,
      ),
    );
  }
}
