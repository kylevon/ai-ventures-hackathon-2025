import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import '../../domain/models/calendar_event.dart';
import '../../domain/models/food_event.dart';
import 'package:flutter/material.dart';

class MockServerService {
  static final MockServerService _instance = MockServerService._internal();
  factory MockServerService() => _instance;
  MockServerService._internal();

  // Static events that never change - simulating a server database
  List<CalendarEvent> _serverEvents = [];
  bool _isInitialized = false;

  // Simulate network delay
  static const _delay = Duration(milliseconds: 500);

  Future<void> _initializeServerData() async {
    if (_isInitialized) return;

    final jsonString = await rootBundle
        .loadString('lib/features/calendar/data/mock_data/food_events.json');
    final jsonData = json.decode(jsonString);
    _serverEvents = (jsonData['events'] as List).map((eventData) {
      final metadata = FoodMetadata(
        calories: eventData['metadata']['calories']?.toDouble(),
        protein: eventData['metadata']['protein']?.toDouble(),
        carbs: eventData['metadata']['carbs']?.toDouble(),
        fat: eventData['metadata']['fat']?.toDouble(),
        ingredients: List<String>.from(eventData['metadata']['ingredients']),
        mealType: eventData['metadata']['mealType'],
      );

      return CalendarEvent(
        id: eventData['id'],
        title: eventData['title'],
        description: eventData['description'],
        startDate: DateTime.now(), // For demo purposes
        startTime: _parseTimeString(eventData['startTime']),
        type: EventType.meal,
        metadata: metadata,
      );
    }).toList();

    _isInitialized = true;
    print('Initialized mock server with ${_serverEvents.length} static events');
  }

  TimeOfDay _parseTimeString(String timeString) {
    final parts = timeString.split(':');
    return TimeOfDay(
      hour: int.parse(parts[0]),
      minute: int.parse(parts[1]),
    );
  }

  // POST - Just simulate network request, don't modify server data
  Future<void> post(String endpoint, {Map<String, dynamic>? data}) async {
    await Future.delayed(_delay);
    print('POST request to $endpoint with data: $data');
    // Do nothing with the data - simulating external API
  }

  // DELETE - Just simulate network request, don't modify server data
  Future<void> delete(String endpoint) async {
    await Future.delayed(_delay);
    print('DELETE request to $endpoint');
    // Do nothing with the data - simulating external API
  }

  // PUT - Just simulate network request, don't modify server data
  Future<void> put(String endpoint, {Map<String, dynamic>? data}) async {
    await Future.delayed(_delay);
    print('PUT request to $endpoint with data: $data');
    // Do nothing with the data - simulating external API
  }

  // GET - Return the static server events
  Future<List<CalendarEvent>> get(String endpoint) async {
    await _initializeServerData();
    await Future.delayed(_delay);
    print(
        'GET request to $endpoint - returning ${_serverEvents.length} static events');
    return List.from(_serverEvents); // Return a copy of the static events
  }
}
