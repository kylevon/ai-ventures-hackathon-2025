import '../../domain/models/calendar_event.dart';

class EventCacheService {
  static final EventCacheService _instance = EventCacheService._internal();
  factory EventCacheService() => _instance;
  EventCacheService._internal();

  final List<CalendarEvent> _events = [];
  bool _needsSync = true;

  void cacheEvents(List<CalendarEvent> events) {
    _events.clear();
    _events.addAll(events);
    _needsSync = false;
  }

  List<CalendarEvent> getAllEvents() {
    return List.from(_events);
  }

  void addEvent(CalendarEvent event) {
    _events.add(event);
  }

  void updateEvent(CalendarEvent event) {
    final index = _events.indexWhere((e) => e.id == event.id);
    if (index != -1) {
      _events[index] = event;
    }
  }

  void deleteEvent(String id) {
    _events.removeWhere((e) => e.id == id);
  }

  bool needsSync() => _needsSync;

  void markForSync() {
    _needsSync = true;
  }
}
