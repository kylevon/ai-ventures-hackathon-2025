import 'package:logging/logging.dart';
import 'package:michro_flutter/features/shared/domain/models/event.dart';
import 'package:michro_flutter/features/shared/data/services/event_service.dart';

class CalendarController {
  final _eventService = EventService();
  final Function(List<Event>) onEventsChanged;
  final Function(bool) onSyncStateChanged;
  final _logger = Logger('CalendarController');

  CalendarController({
    required this.onEventsChanged,
    required this.onSyncStateChanged,
  });

  Future<void> loadInitialEvents() async {
    _logger.info('Loading initial events');
    final events = await _eventService.getCachedEvents();
    onEventsChanged(events);
    _logger.info('Loaded ${events.length} events from cache');
    if (_eventService.needsSync()) {
      _logger.info('Cache needs sync, syncing with server');
      await syncWithServer();
    }
  }

  Future<void> syncWithServer() async {
    _logger.info('Starting server sync');
    onSyncStateChanged(true);
    try {
      final events = await _eventService.fetchEvents();
      onEventsChanged(events);
      _logger.info('Synced ${events.length} events from server');
    } catch (e, stackTrace) {
      _logger.warning('Error syncing with server: $e\n$stackTrace');
    } finally {
      onSyncStateChanged(false);
    }
  }

  Future<Event> addEvent(Event event) async {
    _logger.info('Adding new event: ${event.title}');
    final newEvent = await _eventService.addEvent(event);
    final events = await _eventService.getCachedEvents();
    onEventsChanged(events);
    return newEvent;
  }

  Future<Event> updateEvent(Event event) async {
    _logger.info('Updating event: ${event.title}');
    final updatedEvent = await _eventService.updateEvent(event);
    final events = await _eventService.getCachedEvents();
    onEventsChanged(events);
    return updatedEvent;
  }

  Future<void> deleteEvent(String id) async {
    _logger.info('Deleting event: $id');
    await _eventService.deleteEvent(id);
    final events = _eventService.getCachedEvents();
    _logger.info('Updated events after deletion: ${events.length} events');
    onEventsChanged(events);
  }
}
