import '../../domain/models/calendar_event.dart';
import '../../domain/models/food_event.dart';
import 'mock_server_service.dart';
import 'food_cache_service.dart';

class MockFoodService {
  static final MockFoodService _instance = MockFoodService._internal();
  factory MockFoodService() => _instance;
  MockFoodService._internal();

  final _serverService = MockServerService();
  final _cacheService = FoodCacheService();

  // Fetch events from server and update cache
  Future<List<CalendarEvent>> fetchEvents() async {
    final events = await _serverService.get('/api/events');
    _cacheService.updateCache(events);
    return _cacheService.getAllEvents();
  }

  // Add event locally and send to server
  Future<CalendarEvent> addEvent(CalendarEvent event) async {
    // Generate a simple ID (in a real app, this would come from the server)
    final newEvent = event.copyWith(
      id: 'event-${DateTime.now().millisecondsSinceEpoch}',
    );

    // Update cache immediately
    _cacheService.addEvent(newEvent);

    // Send to server (but don't wait for response to update UI)
    _serverService.post(
      '/api/events',
      data: {
        'event': newEvent.toJson(),
        'action': 'create',
      },
    );

    return newEvent;
  }

  // Update event locally and send to server
  Future<CalendarEvent> updateEvent(CalendarEvent event) async {
    // Update cache immediately
    _cacheService.updateEvent(event);

    // Send to server (but don't wait for response to update UI)
    _serverService.put(
      '/api/events/${event.id}',
      data: {
        'event': event.toJson(),
        'action': 'update',
      },
    );

    return event;
  }

  // Delete event locally and send to server
  Future<void> deleteEvent(String id) async {
    // Update cache immediately
    _cacheService.deleteEvent(id);

    // Send to server (but don't wait for response to update UI)
    _serverService.delete('/api/events/$id');
  }

  // Get events from cache
  List<CalendarEvent> getCachedEvents() {
    return _cacheService.getAllEvents();
  }

  // Check if cache needs sync
  bool needsSync() {
    return _cacheService.needsSync();
  }
}

extension CalendarEventJson on CalendarEvent {
  Map<String, dynamic> toJson() {
    final metadata = this.metadata as FoodMetadata;
    return {
      'id': id,
      'title': title,
      'description': description,
      'startDate': startDate.toIso8601String(),
      'startTime':
          startTime != null ? '${startTime!.hour}:${startTime!.minute}' : null,
      'type': type.toString(),
      'metadata': {
        'calories': metadata.calories,
        'protein': metadata.protein,
        'carbs': metadata.carbs,
        'fat': metadata.fat,
        'ingredients': metadata.ingredients,
        'mealType': metadata.mealType,
      },
    };
  }
}
