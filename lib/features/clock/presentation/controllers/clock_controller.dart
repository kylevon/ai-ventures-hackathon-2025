import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:michro_flutter/features/shared/data/services/event_service.dart';
import 'package:michro_flutter/features/shared/domain/models/event.dart';

final clockControllerProvider = Provider<ClockController>((ref) {
  return ClockController();
});

class ClockController {
  final _eventService = EventService();
  final _logger = Logger('ClockController');

  Future<List<Event>> loadEvents() async {
    _logger.info('Loading events for clock view');
    return await _eventService.getEvents();
  }

  Future<Event> addEvent(Event event) async {
    _logger.info('Adding new event: ${event.title}');
    return await _eventService.addEvent(event);
  }

  Future<Event> updateEvent(Event event) async {
    _logger.info('Updating event: ${event.title}');
    return await _eventService.updateEvent(event);
  }

  Future<void> deleteEvent(String id) async {
    _logger.info('Deleting event: $id');
    await _eventService.deleteEvent(id);
  }
}
