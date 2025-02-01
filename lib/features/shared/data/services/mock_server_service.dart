import 'dart:async';
import 'package:logging/logging.dart';
import '../../domain/models/event.dart';
import 'package:flutter/material.dart';

class MockServerService {
  static final MockServerService _instance = MockServerService._internal();
  factory MockServerService() => _instance;
  MockServerService._internal();

  final _logger = Logger('MockServerService');
  final List<Event> _serverEvents = [];
  bool _isInitialized = false;
  static const _delay = Duration(milliseconds: 500);

  Future<void> _initializeServerData() async {
    if (_isInitialized) return;

    try {
      // Temporary hardcoded events for testing
      final mockEvents = [
        {
          "id": "1",
          "title": "Morning Run",
          "description": "5km run in the park",
          "startDate": DateTime.now().toIso8601String(),
          "startTime": "07:00",
          "type": "exercise",
          "metadata": {"duration": 30, "distance": 5, "calories": 300}
        },
        {
          "id": "2",
          "title": "Breakfast",
          "description": "Oatmeal with fruits",
          "startDate": DateTime.now().toIso8601String(),
          "startTime": "08:00",
          "type": "meal",
          "metadata": {
            "calories": 350,
            "protein": 12,
            "carbs": 45,
            "fat": 8,
            "ingredients": ["oats", "banana", "berries", "honey"],
            "mealType": "breakfast"
          }
        },
        {
          "id": "3",
          "title": "Lunch",
          "description": "Salad and sandwich",
          "startDate": DateTime.now().toIso8601String(),
          "startTime": "12:00",
          "type": "meal",
          "metadata": {
            "calories": 450,
            "protein": 20,
            "carbs": 45,
            "fat": 15,
            "mealType": "lunch"
          }
        },
        {
          "id": "4",
          "title": "Afternoon Walk",
          "description": "Quick walk around the block",
          "startDate": DateTime.now().toIso8601String(),
          "startTime": "15:00",
          "type": "exercise",
          "metadata": {"duration": 15, "distance": 1, "calories": 100}
        },
        {
          "id": "5",
          "title": "Dinner",
          "description": "Grilled chicken and vegetables",
          "startDate": DateTime.now().toIso8601String(),
          "startTime": "18:00",
          "type": "meal",
          "metadata": {
            "calories": 550,
            "protein": 35,
            "carbs": 40,
            "fat": 20,
            "mealType": "dinner"
          }
        },
        {
          "id": "6",
          "title": "Evening Meditation",
          "description": "Mindfulness practice",
          "startDate": DateTime.now().toIso8601String(),
          "startTime": "21:00",
          "type": "exercise",
          "metadata": {"duration": 20}
        },
        {
          "id": "7",
          "title": "Take Medication",
          "description": "Evening medication",
          "startDate": DateTime.now().toIso8601String(),
          "startTime": "22:00",
          "type": "medication",
          "metadata": {"dosage": "1 pill"}
        }
      ];

      final events = mockEvents.map((eventData) {
        return _parseEvent(eventData);
      }).toList();

      _serverEvents.addAll(events);
      _isInitialized = true;
      _logger
          .info('Initialized mock server with ${_serverEvents.length} events');
    } catch (e, stackTrace) {
      _logger.warning('Error loading mock data: $e\n$stackTrace');
      _serverEvents.clear();
      _isInitialized = true;
    }
  }

  Event _parseEvent(Map<String, dynamic> eventData) {
    final metadata = EventMetadata();
    if (eventData['metadata'] != null) {
      (eventData['metadata'] as Map<String, dynamic>).forEach((key, value) {
        metadata.set(key, value);
      });
    }

    final type = EventType.values.firstWhere(
      (e) => e.name == eventData['type'],
      orElse: () => EventType.custom,
    );

    final startDate = DateTime.parse(eventData['startDate']);
    return Event(
      id: eventData['id'],
      title: eventData['title'],
      description: eventData['description'],
      date: startDate,
      startTime: _parseTimeString(eventData['startTime']),
      type: type,
      metadata: metadata,
    );
  }

  TimeOfDay _parseTimeString(String timeString) {
    final parts = timeString.split(':');
    return TimeOfDay(
      hour: int.parse(parts[0]),
      minute: int.parse(parts[1]),
    );
  }

  // GET - Return the static server events
  Future<List<Event>> get(String endpoint) async {
    await _initializeServerData();
    await Future.delayed(_delay);
    _logger.info('GET request returning ${_serverEvents.length} events');
    return List.from(_serverEvents);
  }

  // POST - Just simulate network request, don't modify server data
  Future<void> post(String endpoint, {Map<String, dynamic>? data}) async {
    await Future.delayed(_delay);
    _logger.info('POST request to $endpoint with data: $data');
  }

  // PUT - Just simulate network request, don't modify server data
  Future<void> put(String endpoint, {Map<String, dynamic>? data}) async {
    await Future.delayed(_delay);
    _logger.info('PUT request to $endpoint with data: $data');
  }

  // DELETE - Just simulate network request, don't modify server data
  Future<void> delete(String endpoint) async {
    await Future.delayed(_delay);
    _logger.info('DELETE request to $endpoint');
  }
}
