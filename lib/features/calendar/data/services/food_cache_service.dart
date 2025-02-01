import '../../domain/models/calendar_event.dart';

class FoodCacheService {
  static final FoodCacheService _instance = FoodCacheService._internal();
  factory FoodCacheService() => _instance;
  FoodCacheService._internal();

  List<CalendarEvent> _cachedEvents = [];
  bool _needsSync = true;

  // Update cache with server data
  void updateCache(List<CalendarEvent> events) {
    _cachedEvents = List.from(events);
    _needsSync = false;
    print('Cache updated with ${events.length} events from server');
  }

  // Add event to cache
  void addEvent(CalendarEvent event) {
    _cachedEvents.add(event);
    print('Event added to cache: ${event.title}');
  }

  // Update event in cache
  void updateEvent(CalendarEvent event) {
    final index = _cachedEvents.indexWhere((e) => e.id == event.id);
    if (index != -1) {
      _cachedEvents[index] = event;
      print('Event updated in cache: ${event.title}');
    }
  }

  // Delete event from cache
  void deleteEvent(String id) {
    _cachedEvents.removeWhere((event) => event.id == id);
    print('Event deleted from cache: $id');
  }

  // Get all events from cache
  List<CalendarEvent> getAllEvents() {
    return List.from(_cachedEvents);
  }

  // Check if cache needs sync with server
  bool needsSync() => _needsSync;

  // Mark cache as needing sync
  void markForSync() {
    _needsSync = true;
  }
}
