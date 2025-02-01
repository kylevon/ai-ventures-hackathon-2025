import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../domain/models/calendar_event.dart';
import '../../domain/models/food_event.dart';

class MockFoodService {
  static final MockFoodService _instance = MockFoodService._internal();
  factory MockFoodService() => _instance;
  MockFoodService._internal();

  final List<CalendarEvent> _events = [];

  // Initialize with data from JSON
  Future<void> init() async {
    _events.clear();
    try {
      // Load the JSON file
      final String jsonString = await rootBundle.loadString(
        'lib/features/calendar/data/mock_data/food_events.json',
      );
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      final List<dynamic> eventList = jsonData['events'];

      // Get today's date for date-based events
      final now = DateTime.now();
      final tomorrow = DateTime(now.year, now.month, now.day + 1);

      // Convert JSON events to CalendarEvent objects
      for (var eventData in eventList) {
        // Parse time string to TimeOfDay
        final timeStr = eventData['startTime'].split(':');
        final timeOfDay = TimeOfDay(
          hour: int.parse(timeStr[0]),
          minute: int.parse(timeStr[1]),
        );

        // Create metadata
        final metadata = FoodMetadata(
          calories: eventData['metadata']['calories']?.toDouble(),
          protein: eventData['metadata']['protein']?.toDouble(),
          carbs: eventData['metadata']['carbs']?.toDouble(),
          fat: eventData['metadata']['fat']?.toDouble(),
          ingredients: List<String>.from(eventData['metadata']['ingredients']),
          mealType: eventData['metadata']['mealType'],
        );

        // Determine the date based on the event ID
        final date = eventData['id'].contains('2') ? tomorrow : now;

        // Create the event
        final event = CalendarEvent(
          id: eventData['id'],
          title: eventData['title'],
          description: eventData['description'],
          startDate: date,
          startTime: timeOfDay,
          type: EventType.values.firstWhere(
            (e) => e.name == eventData['type'],
            orElse: () => EventType.custom,
          ),
          metadata: metadata,
        );

        _events.add(event);
      }

      print('Loaded ${_events.length} events from JSON');
    } catch (e) {
      print('Error loading events from JSON: $e');
    }
  }

  // Get all events
  List<CalendarEvent> getAllEvents() {
    print('Getting all events: ${_events.length} events found');
    return List.from(_events);
  }

  // Get all events as JSON
  List<Map<String, dynamic>> getAllEventsAsJson() {
    return _events.map((event) => event.toJson()).toList();
  }

  // Get events for a specific day
  List<CalendarEvent> getEventsForDay(DateTime day) {
    final events = _events
        .where((event) =>
            event.startDate.year == day.year &&
            event.startDate.month == day.month &&
            event.startDate.day == day.day)
        .toList();
    print(
        'Getting events for ${day.toString()}: ${events.length} events found');
    return events;
  }

  // Add a new event
  void addEvent(CalendarEvent event) {
    _events.add(event);
  }

  // Update an existing event
  void updateEvent(CalendarEvent event) {
    final index = _events.indexWhere((e) => e.id == event.id);
    if (index != -1) {
      _events[index] = event;
    }
  }

  // Delete an event
  void deleteEvent(String eventId) {
    _events.removeWhere((event) => event.id == eventId);
  }

  // Get total calories for a day
  double getTotalCaloriesForDay(DateTime day) {
    return getEventsForDay(day)
        .map((event) => (event.metadata as FoodMetadata).calories ?? 0)
        .fold(0, (sum, calories) => sum + calories);
  }

  // Get nutritional summary for a day
  Map<String, double> getNutritionalSummaryForDay(DateTime day) {
    var events = getEventsForDay(day);
    return {
      'calories': events
          .map((e) => (e.metadata as FoodMetadata).calories ?? 0)
          .fold(0, (sum, val) => sum + val),
      'protein': events
          .map((e) => (e.metadata as FoodMetadata).protein ?? 0)
          .fold(0, (sum, val) => sum + val),
      'carbs': events
          .map((e) => (e.metadata as FoodMetadata).carbs ?? 0)
          .fold(0, (sum, val) => sum + val),
      'fat': events
          .map((e) => (e.metadata as FoodMetadata).fat ?? 0)
          .fold(0, (sum, val) => sum + val),
    };
  }
}
