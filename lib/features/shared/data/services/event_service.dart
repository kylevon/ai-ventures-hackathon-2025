import 'package:logging/logging.dart';
import '../../domain/models/event.dart';
import 'mock_server_service.dart';

class EventService {
  static final EventService _instance = EventService._internal();
  factory EventService() => _instance;
  EventService._internal() {
    _initializeCache();
  }

  final _serverService = MockServerService();
  final List<Event> _cache = [];
  bool _isInitialized = false;
  final _logger = Logger('EventService');

  Future<void> _initializeCache() async {
    if (_isInitialized) return;

    _logger.info('Initializing event cache...');
    final events = await _serverService.get('/api/events');
    _cache.clear();
    _cache.addAll(events);
    _isInitialized = true;
    _logger.info('Cache initialized with ${events.length} events');
  }

  // Add event locally and send to server
  Future<Event> addEvent(Event event) async {
    // Generate a simple ID (in a real app, this would come from the server)
    final newEvent = event.copyWith(
      id: 'event-${DateTime.now().millisecondsSinceEpoch}',
    );

    // Update cache immediately
    _cache.add(newEvent);
    _logger.info('Cache after addition: ${_cache.length} events');

    // Send to server (but don't wait for response to update UI)
    await _serverService.post('/api/events', data: _eventToJson(newEvent));
    _logger.info('Post request sent to server');

    return newEvent;
  }

  // Update event locally and send to server
  Future<void> updateEvent(Event event) async {
    final eventIndex = _cache.indexWhere((e) => e.id == event.id);
    if (eventIndex == -1) {
      _logger.warning('Event not found in cache: ${event.id}');
      return;
    }

    // Update cache immediately
    _cache[eventIndex] = event;
    _logger.info('Cache after update: ${_cache.length} events');

    // Send to server (but don't wait for response to update UI)
    await _serverService.put('/api/events/${event.id}',
        data: _eventToJson(event));
    _logger.info('Update request sent to server');
  }

  // Delete event locally and send to server
  Future<void> deleteEvent(String id) async {
    final eventIndex = _cache.indexWhere((e) => e.id == id);
    if (eventIndex == -1) {
      _logger.warning('Event not found in cache: $id');
      return;
    }

    _cache.removeAt(eventIndex);
    _logger.info('Cache after deletion: ${_cache.length} events');

    // Send to server (but don't wait for response to update UI)
    await _serverService.delete('/api/events/$id');
    _logger.info('Delete request sent to server');
  }

  // Get events from cache
  Future<List<Event>> getEvents() async {
    await _initializeCache(); // Ensure cache is initialized
    _logger.info('Getting ${_cache.length} events from cache');
    return List.from(_cache);
  }

  // Convert event to JSON
  Map<String, dynamic> _eventToJson(Event event) {
    return {
      'id': event.id,
      'title': event.title,
      'description': event.description,
      'date': event.date.toIso8601String(),
      'type': event.type.name,
      'metadata': event.metadata.toJson(),
    };
  }
}
