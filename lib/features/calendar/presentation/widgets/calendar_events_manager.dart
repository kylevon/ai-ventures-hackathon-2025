import '../../domain/models/calendar_event.dart';
import 'package:logging/logging.dart';

class CalendarEventsManager {
  final List<CalendarEvent> events;
  late Map<DateTime, List<CalendarEvent>> _groupedEvents;
  final _logger = Logger('CalendarEventsManager');

  CalendarEventsManager(this.events) {
    _logger.info(
        'Initializing CalendarEventsManager with ${events.length} events');
    _groupEvents();
  }

  void _groupEvents() {
    _groupedEvents = {};
    for (final event in events) {
      final date = _normalizeDate(event.startDate);
      if (_groupedEvents[date] == null) _groupedEvents[date] = [];
      _groupedEvents[date]!.add(event);
    }
    _logger.info('Grouped events by date: ${_groupedEvents.length} dates');
  }

  DateTime _normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  List<CalendarEvent> getEventsForDay(DateTime day) {
    final normalizedDay = _normalizeDate(day);
    final events = _groupedEvents[normalizedDay] ?? [];
    _logger.info(
        'Getting events for ${normalizedDay.toIso8601String()}: ${events.length} events');
    return events;
  }
}
