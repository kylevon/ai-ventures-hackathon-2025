import 'dart:async';
import 'package:logging/logging.dart';
import '../../domain/models/calendar_event.dart';
import '../../domain/models/food_event.dart';
import 'package:flutter/material.dart';

class MockServerService {
  static final MockServerService _instance = MockServerService._internal();
  factory MockServerService() => _instance;
  MockServerService._internal();

  final _logger = Logger('MockServerService');
  final List<CalendarEvent> _serverEvents = [];
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

  CalendarEvent _parseEvent(Map<String, dynamic> eventData) {
    EventMetadata? metadata;
    final type = EventType.values.firstWhere(
      (e) => e.name == eventData['type'],
      orElse: () => EventType.custom,
    );

    // Parse metadata based on event type
    switch (type) {
      case EventType.meal:
        metadata = _parseFoodMetadata(eventData['metadata']);
        break;
      case EventType.exercise:
        // TODO: Parse exercise metadata
        metadata = EventMetadata();
        break;
      case EventType.medication:
        // TODO: Parse medication metadata
        metadata = EventMetadata();
        break;
      default:
        metadata = EventMetadata();
    }

    final startDate = DateTime.parse(eventData['startDate']);
    return CalendarEvent(
      id: eventData['id'],
      title: eventData['title'],
      description: eventData['description'],
      startDate: startDate,
      endDate: eventData['endDate'] != null
          ? DateTime.parse(eventData['endDate'])
          : startDate.add(const Duration(hours: 1)), // Default 1 hour duration
      startTime: _parseTimeString(eventData['startTime']),
      type: type,
      metadata: metadata,
    );
  }

  FoodMetadata _parseFoodMetadata(Map<String, dynamic> metadata) {
    return FoodMetadata(
      calories: metadata['calories']?.toDouble(),
      protein: metadata['protein']?.toDouble(),
      carbs: metadata['carbs']?.toDouble(),
      fat: metadata['fat']?.toDouble(),
      ingredients: List<String>.from(metadata['ingredients'] ?? []),
      mealType: metadata['mealType'],
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
  Future<List<CalendarEvent>> get(String endpoint) async {
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
