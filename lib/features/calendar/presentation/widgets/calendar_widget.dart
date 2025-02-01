import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:michro_flutter/features/shared/domain/models/event.dart';
import 'calendar_style_config.dart';

class CalendarWidget extends StatefulWidget {
  final List<Event> events;
  final Function(DateTime) onDaySelected;
  final Function(Event)? onEventTap;
  final DateTime? selectedDay;

  const CalendarWidget({
    super.key,
    required this.events,
    required this.onDaySelected,
    this.onEventTap,
    this.selectedDay,
  });

  @override
  State<CalendarWidget> createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  late DateTime _focusedDay;
  late DateTime _selectedDay;
  late Map<DateTime, List<Event>> _groupedEvents;

  @override
  void initState() {
    super.initState();
    _focusedDay = widget.selectedDay ?? DateTime.now();
    _selectedDay = widget.selectedDay ?? DateTime.now();
    _groupEvents();
  }

  @override
  void didUpdateWidget(CalendarWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.events != oldWidget.events) {
      _groupEvents();
    }
    if (widget.selectedDay != null && widget.selectedDay != _selectedDay) {
      setState(() {
        _selectedDay = widget.selectedDay!;
        _focusedDay = widget.selectedDay!;
      });
    }
  }

  void _groupEvents() {
    _groupedEvents = {};
    for (final event in widget.events) {
      final date = DateTime(
        event.date.year,
        event.date.month,
        event.date.day,
      );
      if (_groupedEvents[date] == null) _groupedEvents[date] = [];
      _groupedEvents[date]!.add(event);
    }
  }

  List<Event> _getEventsForDay(DateTime day) {
    final normalizedDay = DateTime(day.year, day.month, day.day);
    return _groupedEvents[normalizedDay] ?? [];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
    });
    widget.onDaySelected(selectedDay);
  }

  Widget _buildEventsMarker(DateTime date, List<Event> events) {
    return Positioned(
      bottom: 1,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: events.first.color.withOpacity(0.7),
        ),
        width: 16,
        height: 16,
        child: Center(
          child: Text(
            events.length.toString(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedDayEvents = _getEventsForDay(_selectedDay);

    return Column(
      children: [
        TableCalendar<Event>(
          firstDay: DateTime.utc(2023, 1, 1),
          lastDay: DateTime.utc(2024, 12, 31),
          focusedDay: _focusedDay,
          selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
          calendarFormat: CalendarFormat.month,
          eventLoader: _getEventsForDay,
          startingDayOfWeek: StartingDayOfWeek.monday,
          calendarStyle: CalendarStyle(
            markersMaxCount: 1,
            markerDecoration: const BoxDecoration(color: Colors.transparent),
            selectedDecoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              shape: BoxShape.circle,
            ),
            todayDecoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.5),
              shape: BoxShape.circle,
            ),
            outsideDaysVisible: false,
          ),
          headerStyle: CalendarStyleConfig.headerStyle,
          daysOfWeekStyle: CalendarStyleConfig.daysOfWeekStyle,
          onDaySelected: _onDaySelected,
          onPageChanged: (focusedDay) {
            setState(() => _focusedDay = focusedDay);
          },
          calendarBuilders: CalendarBuilders(
            markerBuilder: (context, date, events) {
              if (events.isEmpty) return null;
              return _buildEventsMarker(date, events.cast<Event>().toList());
            },
            selectedBuilder: (context, date, _) {
              return Container(
                margin: const EdgeInsets.all(4.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '${date.day}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: selectedDayEvents.isEmpty
              ? Center(
                  child: Text(
                    'No events for ${_selectedDay.day}/${_selectedDay.month}/${_selectedDay.year}',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                )
              : ListView.builder(
                  itemCount: selectedDayEvents.length,
                  itemBuilder: (context, index) {
                    final event = selectedDayEvents[index];
                    return ListTile(
                      leading: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: event.color,
                          shape: BoxShape.circle,
                        ),
                      ),
                      title: Text(event.title),
                      subtitle: Text(event.timeRange),
                      onTap: () => widget.onEventTap?.call(event),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
