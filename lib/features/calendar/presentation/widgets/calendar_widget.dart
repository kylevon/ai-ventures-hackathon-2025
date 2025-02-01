import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:michro_flutter/features/shared/domain/models/event.dart';
import 'package:michro_flutter/core/constants/event_types.dart';
import 'calendar_style_config.dart';

class CalendarWidget extends StatefulWidget {
  final List<Event> events;
  final Function(DateTime, DateTime) onDaySelected;
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
  DateTime? _hoveredDay;

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
    final events = _groupedEvents[normalizedDay] ?? [];
    // Sort events by time
    events.sort((a, b) => a.date.compareTo(b.date));
    return events;
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
    });
    widget.onDaySelected(selectedDay, focusedDay);
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

  Widget _buildDay(BuildContext context, DateTime day, DateTime focusedDay) {
    final isSelected = isSameDay(_selectedDay, day);
    final isToday = isSameDay(day, DateTime.now());
    final isHovered = isSameDay(_hoveredDay, day);
    final events = _getEventsForDay(day);
    final hasEvents = events.isNotEmpty;

    return MouseRegion(
      onEnter: (_) => setState(() => _hoveredDay = day),
      onExit: (_) => setState(() => _hoveredDay = null),
      child: Container(
        margin: const EdgeInsets.all(4.0),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).primaryColor.withOpacity(0.7)
              : isToday
                  ? Theme.of(context).primaryColor.withOpacity(0.3)
                  : isHovered
                      ? Theme.of(context).hoverColor
                      : Colors.transparent,
          shape: BoxShape.circle,
          border: hasEvents
              ? Border.all(
                  color: events.first.color,
                  width: 2,
                )
              : null,
        ),
        child: Center(
          child: Text(
            '${day.day}',
            style: TextStyle(
              fontWeight:
                  isSelected || isToday ? FontWeight.bold : FontWeight.normal,
              color: isSelected
                  ? Colors.white
                  : isToday
                      ? Theme.of(context).primaryColor
                      : null,
            ),
          ),
        ),
      ),
    );
  }

  String _getSymptomExplanation(Event symptomEvent, List<Event> allDayEvents) {
    // Find food events that happened before the symptom
    final previousFoodEvents = allDayEvents
        .where((e) =>
            e.type == EventType.food && e.date.isBefore(symptomEvent.date))
        .toList();

    if (symptomEvent.title.toLowerCase().contains('tired') ||
        symptomEvent.title.toLowerCase().contains('sleepy')) {
      // Check for sweet foods like croissants
      final hasSweetFood = previousFoodEvents
          .any((e) => e.title.toLowerCase().contains('croissant'));

      if (hasSweetFood) {
        return 'You had a sweet croissant earlier, which likely caused a spike in your blood glucose levels. '
            'When blood sugar rises quickly and then drops, it can cause fatigue and sleepiness. '
            'Consider having a more balanced breakfast with protein and fiber to avoid these energy crashes.';
      }
    }

    // Default explanation if no specific pattern is found
    return 'No clear pattern found. Keep tracking your symptoms and meals to identify potential triggers.';
  }

  @override
  Widget build(BuildContext context) {
    final selectedDayEvents = _getEventsForDay(_selectedDay);

    return Column(
      children: [
        TableCalendar<Event>(
          firstDay: DateTime.utc(2023, 1, 1),
          lastDay: DateTime.utc(2030, 12, 31),
          focusedDay: _focusedDay,
          selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
          calendarFormat: CalendarFormat.month,
          eventLoader: _getEventsForDay,
          startingDayOfWeek: StartingDayOfWeek.monday,
          calendarStyle: CalendarStyle(
            markersMaxCount: 1,
            markerDecoration: const BoxDecoration(color: Colors.transparent),
            selectedDecoration: const BoxDecoration(color: Colors.transparent),
            todayDecoration: const BoxDecoration(color: Colors.transparent),
            outsideDaysVisible: false,
          ),
          headerStyle: CalendarStyleConfig.headerStyle,
          daysOfWeekStyle: CalendarStyleConfig.daysOfWeekStyle,
          onDaySelected: _onDaySelected,
          onPageChanged: (focusedDay) {
            setState(() => _focusedDay = focusedDay);
          },
          calendarBuilders: CalendarBuilders(
            defaultBuilder: _buildDay,
            selectedBuilder: _buildDay,
            todayBuilder: _buildDay,
            markerBuilder: (context, date, events) {
              if (events.isEmpty) return null;
              return _buildEventsMarker(date, events.cast<Event>().toList());
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
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          leading: Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: event.color,
                              shape: BoxShape.circle,
                            ),
                          ),
                          title: Text(event.title),
                          subtitle: Text(
                            '${event.date.hour.toString().padLeft(2, '0')}:${event.date.minute.toString().padLeft(2, '0')}',
                          ),
                          onTap: () => widget.onEventTap?.call(event),
                        ),
                        if (event.type == EventType.symptoms)
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 72, right: 16, bottom: 8),
                            child: ElevatedButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title:
                                        Text('Why might this have happened?'),
                                    content: Text(_getSymptomExplanation(
                                        event, selectedDayEvents)),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: Text('Close'),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: event.color,
                                foregroundColor: Colors.white,
                              ),
                              child: Text('Explain'),
                            ),
                          ),
                      ],
                    );
                  },
                ),
        ),
      ],
    );
  }
}
