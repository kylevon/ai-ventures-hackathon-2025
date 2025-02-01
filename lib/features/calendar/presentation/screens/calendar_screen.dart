import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:michro_flutter/features/shared/domain/models/event.dart';
import '../widgets/calendar_widget.dart';
import '../controllers/calendar_controller.dart';
import '../widgets/event_details_dialog.dart';

class CalendarScreen extends StatefulWidget {
  final Function(List<Event>) onEventsChanged;
  final Function(bool) onSyncStateChanged;

  const CalendarScreen({
    super.key,
    required this.onEventsChanged,
    required this.onSyncStateChanged,
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
    widget.onSyncStateChanged(isSyncing);
  }

  void _handleEventsChanged(List<Event> events) {
    setState(() => _events = events);
    widget.onEventsChanged(events);
  }

  void _handleDaySelected(DateTime selectedDay) {
    setState(() => _selectedDay = selectedDay);
  }

  void _handleEventTap(Event event) {
    showDialog(
      context: context,
      builder: (context) => EventDetailsDialog(
        event: event,
        onUpdate: (updatedEvent) async {
          await _controller.updateEvent(updatedEvent);
        },
        onDelete: (id) async {
          await _controller.deleteEvent(id);
        },
      ),
    );
  }

  Future<void> _handleAddEvent() async {
    context.go('/input');
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_isLoading)
                const Padding(
                  padding: EdgeInsets.only(bottom: 8.0),
                  child: CircularProgressIndicator(),
                ),
              FloatingActionButton(
                heroTag: 'sync',
                onPressed:
                    _isLoading ? null : () => _controller.syncWithServer(),
                child: const Icon(Icons.sync),
              ),
              const SizedBox(height: 8),
              FloatingActionButton(
                heroTag: 'add',
                onPressed: _handleAddEvent,
                child: const Icon(Icons.add),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
