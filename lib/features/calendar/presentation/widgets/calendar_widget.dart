import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:logging/logging.dart';
import '../../domain/models/calendar_event.dart';
import 'calendar_style_config.dart';
import 'events_list.dart';
import 'calendar_events_manager.dart';

class CalendarWidget extends StatefulWidget {
  final List<CalendarEvent> events;
  final void Function(DateTime selectedDay)? onDaySelected;
  final void Function(CalendarEvent event)? onEventTap;
  final void Function(DateTime selectedDay)? onAddEvent;

  const CalendarWidget({
    super.key,
    required this.events,
    this.onDaySelected,
    this.onEventTap,
    this.onAddEvent,
  });

  @override
  State<CalendarWidget> createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  late DateTime _focusedDay;
  late DateTime _selectedDay;
  late CalendarFormat _calendarFormat;
  late CalendarEventsManager _eventsManager;
  final _logger = Logger('CalendarWidget');

  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now();
    _selectedDay = DateTime.now();
    _calendarFormat = CalendarFormat.month;
    _eventsManager = CalendarEventsManager(widget.events);
    _logger.info('Calendar initialized with ${widget.events.length} events');
  }

  @override
  void didUpdateWidget(CalendarWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.events != widget.events) {
      _logger.info('Events updated: ${widget.events.length} events');
      setState(() {
        _eventsManager = CalendarEventsManager(widget.events);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final eventsForSelectedDay = _eventsManager.getEventsForDay(_selectedDay);
    _logger.info(
        'Building calendar with ${eventsForSelectedDay.length} events for selected day');

    return Column(
      children: [
        _buildCalendar(),
        const SizedBox(height: 8),
        Expanded(
          child: EventsList(
            selectedDay: _selectedDay,
            events: eventsForSelectedDay,
            onEventTap: widget.onEventTap,
            onAddEvent: widget.onAddEvent,
          ),
        ),
      ],
    );
  }

  Widget _buildCalendar() {
    return TableCalendar<CalendarEvent>(
      firstDay: DateTime.utc(2020, 1, 1),
      lastDay: DateTime.utc(2030, 12, 31),
      focusedDay: _focusedDay,
      selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
      calendarFormat: _calendarFormat,
      onFormatChanged: _onFormatChanged,
      eventLoader: _eventsManager.getEventsForDay,
      startingDayOfWeek: StartingDayOfWeek.monday,
      calendarStyle: CalendarStyleConfig.calendarStyle,
      headerStyle: CalendarStyleConfig.headerStyle,
      daysOfWeekStyle: CalendarStyleConfig.daysOfWeekStyle,
      onDaySelected: _onDaySelected,
      onPageChanged: _onPageChanged,
    );
  }

  void _onFormatChanged(CalendarFormat format) {
    setState(() {
      _calendarFormat = format;
    });
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
    });
    widget.onDaySelected?.call(selectedDay);
  }

  void _onPageChanged(DateTime focusedDay) {
    _focusedDay = focusedDay;
  }
}
