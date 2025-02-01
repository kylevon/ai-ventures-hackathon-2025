import 'package:flutter/material.dart';
import '../../../../core/constants/event_types.dart';
import '../../../shared/domain/models/event.dart';
import '../widgets/calendar_widget.dart';
import '../widgets/event_details_dialog.dart';
import '../../domain/controllers/calendar_controller.dart';

class CalendarScreen extends StatefulWidget {
  final Function(List<Event>)? onEventsChanged;
  final Function(bool)? onSyncStateChanged;

  const CalendarScreen({
    super.key,
    this.onEventsChanged,
    this.onSyncStateChanged,
  });

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  final _calendarController = CalendarController();
  DateTime _selectedDay = DateTime.now();
  List<Event> _selectedEvents = [];

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  Future<void> _loadEvents() async {
    await _calendarController.loadEvents();
    _updateSelectedEvents(_selectedDay);
    widget.onEventsChanged?.call(_calendarController.events);
  }

  void _updateSelectedEvents(DateTime day) {
    setState(() {
      _selectedDay = day;
      _selectedEvents = _calendarController.getEventsForDay(day);
    });
  }

  void _handleDaySelected(DateTime selectedDay, DateTime focusedDay) {
    _updateSelectedEvents(selectedDay);
  }

  void _handleEventTap(Event event) {
    showDialog(
      context: context,
      builder: (context) => EventDetailsDialog(
        event: event,
        onSave: _handleEventUpdate,
      ),
    );
  }

  Future<void> _handleEventUpdate(Event event) async {
    await _calendarController.updateEvent(event);
    _updateSelectedEvents(_selectedDay);
    widget.onEventsChanged?.call(_calendarController.events);
  }

  Future<void> _handleEventDelete(String eventId) async {
    await _calendarController.deleteEvent(eventId);
    _updateSelectedEvents(_selectedDay);
    widget.onEventsChanged?.call(_calendarController.events);
  }

  void _handleAddEvent() {
    final newEvent = Event(
      id: DateTime.now().toString(),
      title: '',
      description: '',
      date: _selectedDay,
      type: EventType.misc,
    );

    showDialog(
      context: context,
      builder: (context) => EventDetailsDialog(
        event: newEvent,
        onSave: _handleEventAdd,
      ),
    );
  }

  Future<void> _handleEventAdd(Event event) async {
    await _calendarController.addEvent(event);
    _updateSelectedEvents(_selectedDay);
    widget.onEventsChanged?.call(_calendarController.events);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: CalendarWidget(
              events: _calendarController.events,
              onDaySelected: _handleDaySelected,
              onEventTap: _handleEventTap,
              selectedDay: _selectedDay,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _handleAddEvent,
        child: const Icon(Icons.add),
      ),
    );
  }
}
