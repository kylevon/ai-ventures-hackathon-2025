import '../../domain/models/calendar_event.dart';
import '../../data/services/mock_food_service.dart';
import '../../data/services/food_cache_service.dart';

class CalendarController {
  final MockFoodService _foodService;
  final FoodCacheService _cacheService;
  final Function(List<CalendarEvent>) onEventsChanged;
  final Function(bool) onSyncStateChanged;

  CalendarController({
    required this.onEventsChanged,
    required this.onSyncStateChanged,
  })  : _foodService = MockFoodService(),
        _cacheService = FoodCacheService();

  Future<void> loadInitialEvents() async {
    if (_cacheService.needsSync()) {
      await syncWithServer();
    } else {
      _updateEvents();
    }
  }

  Future<void> syncWithServer() async {
    onSyncStateChanged(true);
    try {
      await _foodService.fetchEvents();
      _updateEvents();
    } catch (e) {
      _updateEvents();
      print('Error syncing with server: $e');
    } finally {
      onSyncStateChanged(false);
    }
  }

  Future<void> addEvent(CalendarEvent event) async {
    await _foodService.addEvent(event);
    _updateEvents();
  }

  Future<void> updateEvent(CalendarEvent event) async {
    await _foodService.updateEvent(event);
    _updateEvents();
  }

  Future<void> deleteEvent(String id) async {
    await _foodService.deleteEvent(id);
    _updateEvents();
  }

  void _updateEvents() {
    final events = _cacheService.getAllEvents();
    onEventsChanged(events);
  }
}
