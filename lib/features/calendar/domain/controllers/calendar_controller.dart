import 'package:flutter/material.dart';
import '../../../shared/domain/models/event.dart';
import '../../../shared/data/services/mock_server_service.dart';

class CalendarController {
  final _mockServer = MockServerService();
  List<Event> _events = [];

  List<Event> get events => List.unmodifiable(_events);

  Future<void> loadEvents() async {
    _events = await _mockServer.get('/events');
  }

  List<Event> getEventsForDay(DateTime day) {
    return _events.where((event) {
      return event.date.year == day.year &&
          event.date.month == day.month &&
          event.date.day == day.day;
    }).toList();
  }

  Future<void> addEvent(Event event) async {
    await _mockServer.post('/events', data: {
      'id': event.id,
      'title': event.title,
      'description': event.description,
      'date': event.date.toIso8601String(),
      'type': event.type.name,
    });
    _events.add(event);
  }

  Future<void> updateEvent(Event event) async {
    await _mockServer.put('/events/${event.id}', data: {
      'title': event.title,
      'description': event.description,
      'date': event.date.toIso8601String(),
      'type': event.type.name,
    });
    final index = _events.indexWhere((e) => e.id == event.id);
    if (index != -1) {
      _events[index] = event;
    }
  }

  Future<void> deleteEvent(String eventId) async {
    await _mockServer.delete('/events/$eventId');
    _events.removeWhere((event) => event.id == eventId);
  }
}
