import 'package:flutter/material.dart';
import '../../domain/models/calendar_event.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../auth/presentation/theme/auth_theme.dart';

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
  late PageController _pageController;
  late Map<DateTime, List<CalendarEvent>> _groupedEvents;
  CalendarFormat _calendarFormat = CalendarFormat.month;

  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now();
    _selectedDay = DateTime.now();
    _pageController = PageController();
    _groupEvents();
  }

  @override
  void didUpdateWidget(CalendarWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.events != widget.events) {
      _groupEvents();
    }
  }

  void _groupEvents() {
    _groupedEvents = {};
    for (final event in widget.events) {
      final date = DateTime(
        event.startDate.year,
        event.startDate.month,
        event.startDate.day,
      );
      _groupedEvents[date] = [...(_groupedEvents[date] ?? []), event];
    }
  }

  List<CalendarEvent> _getEventsForDay(DateTime day) {
    return _groupedEvents[day] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TableCalendar<CalendarEvent>(
          firstDay: DateTime.utc(2020, 1, 1),
          lastDay: DateTime.utc(2030, 12, 31),
          focusedDay: _focusedDay,
          selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
          calendarFormat: _calendarFormat,
          onFormatChanged: (format) {
            setState(() {
              _calendarFormat = format;
            });
          },
          eventLoader: _getEventsForDay,
          startingDayOfWeek: StartingDayOfWeek.monday,
          calendarStyle: CalendarStyle(
            markersMaxCount: 3,
            markerDecoration: BoxDecoration(
              color: AuthTheme.primary[500],
              shape: BoxShape.circle,
            ),
            selectedDecoration: BoxDecoration(
              color: AuthTheme.primary[500],
              shape: BoxShape.circle,
            ),
            todayDecoration: BoxDecoration(
              color: AuthTheme.primary[500]!.withOpacity(0.5),
              shape: BoxShape.circle,
            ),
            weekendTextStyle: TextStyle(
              color: Colors.grey[600],
            ),
            outsideTextStyle: TextStyle(
              color: Colors.grey[400],
            ),
            markerSize: 6,
            markersAnchor: 1.5,
          ),
          headerStyle: HeaderStyle(
            titleCentered: true,
            formatButtonVisible: true,
            formatButtonDecoration: BoxDecoration(
              color: AuthTheme.primary[500]!.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            formatButtonTextStyle: TextStyle(
              color: AuthTheme.primary[500],
            ),
            formatButtonShowsNext: false,
            leftChevronIcon: Icon(
              Icons.chevron_left,
              color: AuthTheme.primary[500],
            ),
            rightChevronIcon: Icon(
              Icons.chevron_right,
              color: AuthTheme.primary[500],
            ),
          ),
          daysOfWeekStyle: DaysOfWeekStyle(
            weekdayStyle: const TextStyle(fontWeight: FontWeight.bold),
            weekendStyle: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
            });
            widget.onDaySelected?.call(selectedDay);
          },
          onPageChanged: (focusedDay) {
            _focusedDay = focusedDay;
          },
        ),
        const SizedBox(height: 8),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey[300]!,
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Events for ${_selectedDay.day}/${_selectedDay.month}/${_selectedDay.year}',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${_getEventsForDay(_selectedDay).length} events',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Colors.grey[600],
                                  ),
                        ),
                      ],
                    ),
                    Material(
                      color: AuthTheme.primary[500]!.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      child: IconButton(
                        icon: Icon(
                          Icons.add_circle_outline,
                          color: AuthTheme.primary[500],
                        ),
                        onPressed: () => widget.onAddEvent?.call(_selectedDay),
                        tooltip: 'Add event',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              if (_getEventsForDay(_selectedDay).isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 32),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.event_available,
                          size: 48,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No events for this day',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                ..._getEventsForDay(_selectedDay)
                    .map((event) => _buildEventCard(event)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEventCard(CalendarEvent event) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => widget.onEventTap?.call(event),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 4,
                height: 48,
                decoration: BoxDecoration(
                  color: event.color,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          _getEventTypeIcon(event.type),
                          size: 16,
                          color: event.color,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          event.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    if (event.description != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        event.description!,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 14,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          event.timeRange,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                        if (event.location != null) ...[
                          const SizedBox(width: 16),
                          Icon(
                            Icons.location_on,
                            size: 14,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              event.location!,
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              if (event.isRecurring) ...[
                const SizedBox(width: 16),
                Tooltip(
                  message: 'Recurring event',
                  child: Icon(
                    Icons.repeat,
                    size: 16,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  IconData _getEventTypeIcon(EventType type) {
    switch (type) {
      case EventType.medication:
        return Icons.medication;
      case EventType.meal:
        return Icons.restaurant;
      case EventType.exercise:
        return Icons.fitness_center;
      case EventType.sleep:
        return Icons.bedtime;
      case EventType.symptom:
        return Icons.healing;
      case EventType.measurement:
        return Icons.monitor_heart;
      case EventType.appointment:
        return Icons.calendar_today;
      case EventType.reminder:
        return Icons.notifications;
      case EventType.custom:
        return Icons.event;
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
