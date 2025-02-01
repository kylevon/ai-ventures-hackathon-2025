import 'package:flutter/material.dart';
import 'package:michro_flutter/features/shared/domain/models/event.dart';
import '../widgets/calendar_widget.dart';
import '../controllers/calendar_controller.dart';

class CalendarScreen extends StatefulWidget {
  final Function(List<Event>) onEventsChanged;

  const CalendarScreen({
    super.key,
    required this.onEventsChanged,
  });

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late CalendarController _controller;
  DateTime _selectedDay = DateTime.now();
  List<Event> _events = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = CalendarController(
      onEventsChanged: _handleEventsChanged,
      onSyncStateChanged: _handleSyncStateChanged,
    );
    _loadEvents();
  }

  Future<void> _loadEvents() async {
    setState(() => _isLoading = true);
    await _controller.loadInitialEvents();
    setState(() => _isLoading = false);
  }

  void _handleSyncStateChanged(bool isSyncing) {
    setState(() => _isLoading = isSyncing);
  }

  void _handleEventsChanged(List<Event> events) {
    setState(() => _events = events);
    widget.onEventsChanged(events);
  }

  void _handleDaySelected(DateTime selectedDay) {
    setState(() => _selectedDay = selectedDay);
  }

  void _handleEventTap(Event event) {
    // TODO: Show event details dialog
  }

  Future<void> _handleAddEvent() async {
    // TODO: Show add event dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Event'),
        content: const Text('Event creation dialog will be implemented here'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading && _events.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return Stack(
      children: [
        CalendarWidget(
          events: _events,
          selectedDay: _selectedDay,
          onDaySelected: _handleDaySelected,
          onEventTap: _handleEventTap,
        ),
        Positioned(
          right: 16,
          bottom: 16,
          child: FloatingActionButton(
            onPressed: _handleAddEvent,
            child: const Icon(Icons.add),
          ),
        ),
      ],
    );
  }
}
