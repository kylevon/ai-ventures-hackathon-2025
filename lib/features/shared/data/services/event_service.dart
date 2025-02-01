import 'package:logging/logging.dart';
import '../../domain/models/event.dart';
import 'mock_server_service.dart';

class EventService {
  static final EventService _instance = EventService._internal();
  factory EventService() => _instance;
  EventService._internal();

  final _serverService = MockServerService();
  final List<Event> _cache = [];
  bool _needsSync = true;
  final _logger = Logger('EventService');

  // Fetch events from server and update cache
  Future<List<Event>> fetchEvents() async {
    _logger.info('Fetching events from server...');
    final events = await _serverService.get('/api/events');
    _logger.info('Received ${events.length} events from server');
    _updateCache(events);
    return List.from(_cache);
  }

  // Add event locally and send to server
  Future<Event> addEvent(Event event) async {
    // Generate a simple ID (in a real app, this would come from the server)
    final newEvent = event.copyWith(
      id: 'event-${DateTime.now().millisecondsSinceEpoch}',
    );

    // Update cache immediately
    _cache.add(newEvent);
    _needsSync = true;

    // Send to server (but don't wait for response to update UI)
    _serverService.post(
      '/api/events',
      data: {'event': _eventToJson(newEvent)},
    );

    return newEvent;
  }

  // Update event locally and send to server
  Future<Event> updateEvent(Event event) async {
    // Update cache immediately
    final index = _cache.indexWhere((e) => e.id == event.id);
    if (index != -1) {
      _cache[index] = event;
    }
    _needsSync = true;

    // Send to server (but don't wait for response to update UI)
    _serverService.put(
      '/api/events/${event.id}',
      data: {'event': _eventToJson(event)},
    );

    return event;
  }

  // Delete event locally and send to server
  Future<void> deleteEvent(String id) async {
    _logger.info('Deleting event with id: $id');
    _logger.info('Cache before deletion: ${_cache.length} events');

    // Update cache immediately
    final eventIndex = _cache.indexWhere((e) => e.id == id);
    if (eventIndex == -1) {
      _logger.warning('Event with id $id not found in cache');
      return;
    }

    _cache.removeAt(eventIndex);
    _needsSync = true;
    _logger.info('Cache after deletion: ${_cache.length} events');

    // Send to server (but don't wait for response to update UI)
    await _serverService.delete('/api/events/$id');
    _logger.info('Delete request sent to server');
  }

  // Get events from cache
  List<Event> getCachedEvents() {
    _logger.info('Getting ${_cache.length} events from cache');
    return List.from(_cache);
  }

  // Check if cache needs sync
  bool needsSync() => _needsSync;

  // Update cache with new events
  void _updateCache(List<Event> events) {
    _cache.clear();
    _cache.addAll(events);
    _needsSync = false;
    _logger.info('Updated cache with ${events.length} events');
  }

  // Convert event to JSON
  Map<String, dynamic> _eventToJson(Event event) {
    return {
      'id': event.id,
      'title': event.title,
      'description': event.description,
      'startDate': event.date.toIso8601String(),
      'startTime': event.startTime != null
          ? '${event.startTime!.hour}:${event.startTime!.minute}'
          : null,
      'type': event.type.name,
      'metadata': event.metadata.toJson(),
    };
  }

  Future<List<Event>> getEvents() async {
    return getCachedEvents();
  }
}
