import '../../domain/models/calendar_event.dart';

class CalendarEventsManager {
  final List<CalendarEvent> events;
  late Map<DateTime, List<CalendarEvent>> _groupedEvents;

  CalendarEventsManager(this.events) {
    _groupEvents();
  }

  void _groupEvents() {
    _groupedEvents = {};
    for (final event in events) {
      final date = _normalizeDate(event.startDate);
      if (_groupedEvents[date] == null) _groupedEvents[date] = [];
      _groupedEvents[date]!.add(event);
    }
  }

  DateTime _normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  List<CalendarEvent> getEventsForDay(DateTime day) {
    final normalizedDay = _normalizeDate(day);
    return _groupedEvents[normalizedDay] ?? [];
  }
}
