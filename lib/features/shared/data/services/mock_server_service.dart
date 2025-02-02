import 'dart:async';
import 'package:logging/logging.dart';
import '../../domain/models/event.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/event_types.dart';
import 'dart:math' as math;
import '../../domain/models/events/exercise_event.dart';

class MockServerService {
  static final MockServerService _instance = MockServerService._internal();
  factory MockServerService() => _instance;
  MockServerService._internal();

  final List<Event> _serverEvents = [];
  final _delay = const Duration(milliseconds: 100);
  bool _isInitialized = false;
  final _logger = Logger('MockServerService');

  Future<void> _initializeServerData() async {
    if (_isInitialized) return;

    try {
      // Create events for January and February 2025
      final events = [
        // February events
        ..._createFebruaryEvents(),
        // January events
        ..._createJanuaryNutritionEvents(),
        // Exercise events
        ..._createExerciseEvents(),
      ];

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

  List<Event> _createFebruaryEvents() {
    final feb1 = DateTime(2025, 2, 1);
    final feb2 = DateTime(2025, 2, 2);

    return [
      // February 1st Events
      Event(
        id: 'feb1-1',
        title: 'Croissants',
        description: 'Morning croissants',
        date: DateTime(feb1.year, feb1.month, feb1.day, 10, 0),
        type: EventType.food,
      ),
      Event(
        id: 'feb1-2',
        title: 'Chicken and Beans and Rice burrito',
        description: 'Lunch burrito',
        date: DateTime(feb1.year, feb1.month, feb1.day, 13, 0),
        type: EventType.food,
      ),
      Event(
        id: 'feb1-3',
        title: 'Chicken and rice',
        description: 'Dinner',
        date: DateTime(feb1.year, feb1.month, feb1.day, 19, 0),
        type: EventType.food,
      ),
      Event(
        id: 'feb1-4',
        title: 'Metformin',
        description: 'Morning medication',
        date: DateTime(feb1.year, feb1.month, feb1.day, 9, 0),
        type: EventType.pills,
      ),
      Event(
        id: 'feb1-5',
        title: 'Very sleepy and tired',
        description: 'Feeling very sleepy and tired',
        date: DateTime(feb1.year, feb1.month, feb1.day, 12, 30),
        type: EventType.symptoms,
      ),
      // February 2nd Events
      Event(
        id: 'feb2-1',
        title: 'Metformin',
        description: 'Morning medication',
        date: DateTime(feb2.year, feb2.month, feb2.day, 8, 0),
        type: EventType.pills,
      ),
      Event(
        id: 'feb2-2',
        title: 'Omelette',
        description: 'Breakfast',
        date: DateTime(feb2.year, feb2.month, feb2.day, 10, 0),
        type: EventType.food,
      ),
      Event(
        id: 'feb2-3',
        title: 'Chicken and rice',
        description: 'Lunch',
        date: DateTime(feb2.year, feb2.month, feb2.day, 12, 30),
        type: EventType.food,
      ),
    ];
  }

  List<Event> _createJanuaryNutritionEvents() {
    final events = <Event>[];

    // Add meal events
    events.addAll(_createJanuaryMealEvents());

    // Add medication events
    events.addAll(_createJanuaryMedicationEvents());

    // Add symptom events
    events.addAll(_createJanuarySymptomEvents());

    return events;
  }

  List<Event> _createJanuaryMealEvents() {
    final events = <Event>[];

    // Common meals with their nutrition data
    final meals = [
      {
        'title': 'Oatmeal with Berries',
        'description': 'Breakfast - Oatmeal with mixed berries and honey',
        'time': const TimeOfDay(hour: 8, minute: 30),
        'nutrients': {
          'vitaminA': 80.0,
          'vitaminC': 15.0,
          'vitaminB1': 0.2,
          'iron': 2.5,
          'magnesium': 80.0,
          'omega3': 0.3,
          'omega6': 0.8,
        }
      },
      {
        'title': 'Greek Yogurt with Nuts',
        'description': 'Morning Snack - Greek yogurt with almonds and honey',
        'time': const TimeOfDay(hour: 10, minute: 30),
        'nutrients': {
          'calcium': 250.0,
          'vitaminD': 2.0,
          'vitaminB12': 0.9,
          'magnesium': 60.0,
          'omega3': 0.1,
          'omega6': 2.0,
        }
      },
      {
        'title': 'Grilled Salmon with Vegetables',
        'description': 'Lunch - Grilled salmon with roasted vegetables',
        'time': const TimeOfDay(hour: 13, minute: 0),
        'nutrients': {
          'vitaminD': 8.0,
          'vitaminB12': 4.0,
          'omega3': 2.5,
          'omega6': 0.5,
          'iron': 1.5,
          'zinc': 2.0,
        }
      },
      {
        'title': 'Mixed Salad with Chicken',
        'description': 'Lunch - Fresh salad with grilled chicken',
        'time': const TimeOfDay(hour: 13, minute: 0),
        'nutrients': {
          'vitaminA': 300.0,
          'vitaminC': 45.0,
          'vitaminK': 65.0,
          'folate': 160.0,
          'iron': 2.0,
          'omega3': 0.2,
          'omega6': 1.5,
        }
      },
      {
        'title': 'Trail Mix',
        'description': 'Afternoon Snack - Mixed nuts and dried fruits',
        'time': const TimeOfDay(hour: 16, minute: 0),
        'nutrients': {
          'vitaminE': 6.0,
          'magnesium': 80.0,
          'zinc': 1.5,
          'omega3': 0.3,
          'omega6': 3.0,
        }
      },
      {
        'title': 'Chicken and Rice Bowl',
        'description':
            'Dinner - Grilled chicken with brown rice and vegetables',
        'time': const TimeOfDay(hour: 19, minute: 0),
        'nutrients': {
          'vitaminB3': 8.0,
          'vitaminB6': 0.8,
          'iron': 2.5,
          'zinc': 3.0,
          'magnesium': 100.0,
          'omega3': 0.2,
          'omega6': 1.8,
        }
      },
      {
        'title': 'Stir-Fried Tofu with Vegetables',
        'description': 'Dinner - Tofu and vegetable stir-fry with brown rice',
        'time': const TimeOfDay(hour: 19, minute: 0),
        'nutrients': {
          'vitaminA': 250.0,
          'vitaminC': 35.0,
          'vitaminK': 45.0,
          'calcium': 350.0,
          'iron': 3.5,
          'omega3': 0.4,
          'omega6': 2.2,
        }
      },
    ];

    // Create events for each day in January
    for (int day = 1; day <= 31; day++) {
      final date = DateTime(2025, 1, day);

      // Add 3-4 meals per day
      final dailyMeals = List.from(meals)..shuffle();
      final numberOfMeals = 3 + (day % 2); // Alternates between 3 and 4 meals

      for (int i = 0; i < numberOfMeals; i++) {
        final meal = dailyMeals[i];
        final mealTime = meal['time'] as TimeOfDay;
        final metadata = EventMetadata();
        metadata.set('nutrients', meal['nutrients']);

        events.add(
          Event(
            id: 'jan-meal-$day-$i',
            title: meal['title'] as String,
            description: meal['description'] as String,
            date: DateTime(
              date.year,
              date.month,
              date.day,
              mealTime.hour,
              mealTime.minute,
            ),
            type: EventType.food,
            metadata: metadata,
          ),
        );
      }
    }

    return events;
  }

  List<Event> _createJanuaryMedicationEvents() {
    final events = <Event>[];
    final random = math.Random(42); // Fixed seed for consistent results

    // Create Metformin events for each day in January
    for (int day = 1; day <= 31; day++) {
      final date = DateTime(2025, 1, day);

      // Random time between 7:30 AM and 9:00 AM (90 minutes range)
      final minutesAfter730 = random.nextInt(90); // 0 to 89 minutes
      final hour = 7 + (minutesAfter730 ~/ 60);
      final minute = 30 + (minutesAfter730 % 60);

      events.add(
        Event(
          id: 'jan-med-$day',
          title: 'Metformin',
          description: 'Morning medication - Metformin',
          date: DateTime(
            date.year,
            date.month,
            date.day,
            hour,
            minute,
          ),
          type: EventType.pills,
        ),
      );
    }

    return events;
  }

  List<Event> _createJanuarySymptomEvents() {
    final events = <Event>[];

    final symptoms = [
      {
        'title': 'Fatigue',
        'description': 'Feeling unusually tired and low energy',
        'time': const TimeOfDay(hour: 14, minute: 30),
      },
      {
        'title': 'Headache',
        'description': 'Mild headache with slight pressure',
        'time': const TimeOfDay(hour: 16, minute: 0),
      },
      {
        'title': 'Nausea',
        'description': 'Slight nausea and discomfort',
        'time': const TimeOfDay(hour: 11, minute: 30),
      },
      {
        'title': 'Dizziness',
        'description': 'Brief episode of lightheadedness',
        'time': const TimeOfDay(hour: 15, minute: 45),
      },
      {
        'title': 'Brain Fog',
        'description': 'Difficulty concentrating and mental clarity issues',
        'time': const TimeOfDay(hour: 13, minute: 15),
      },
    ];

    // Add symptoms on specific days
    final symptomDays = [
      3, 7, 8, 12, 15, 17, 20, 23, 25, 28,
      31 // Distributed throughout the month
    ];

    for (final day in symptomDays) {
      final date = DateTime(2025, 1, day);

      // Randomly select 1-2 symptoms for each symptom day
      final dailySymptoms = List.from(symptoms)..shuffle();
      final numberOfSymptoms = 1 + (day % 2); // Either 1 or 2 symptoms

      for (int i = 0; i < numberOfSymptoms; i++) {
        final symptom = dailySymptoms[i];
        final symptomTime = symptom['time'] as TimeOfDay;

        events.add(
          Event(
            id: 'jan-symptom-$day-$i',
            title: symptom['title'] as String,
            description: symptom['description'] as String,
            date: DateTime(
              date.year,
              date.month,
              date.day,
              symptomTime.hour,
              symptomTime.minute,
            ),
            type: EventType.symptoms,
          ),
        );
      }
    }

    return events;
  }

  List<Event> _createExerciseEvents() {
    return [
      ExerciseEvent(
        id: '1',
        title: 'Morning Walk',
        description: 'Duration: 30 min • Intensity: Light',
        date: DateTime(2025, 1, 2, 7, 30),
        activity: 'Morning Walk',
        duration: 30,
        intensity: 'Light',
      ),
      ExerciseEvent(
        id: '2',
        title: 'Yoga',
        description: 'Duration: 45 min • Intensity: Moderate',
        date: DateTime(2025, 1, 3, 8, 0),
        activity: 'Yoga',
        duration: 45,
        intensity: 'Moderate',
      ),
      ExerciseEvent(
        id: '3',
        title: 'Stretching',
        description: 'Duration: 20 min • Intensity: Light',
        date: DateTime(2025, 1, 5, 7, 0),
        activity: 'Stretching',
        duration: 20,
        intensity: 'Light',
      ),
      ExerciseEvent(
        id: '4',
        title: 'Morning Walk',
        description: 'Duration: 35 min • Intensity: Moderate',
        date: DateTime(2025, 1, 8, 7, 30),
        activity: 'Morning Walk',
        duration: 35,
        intensity: 'Moderate',
      ),
      ExerciseEvent(
        id: '5',
        title: 'Yoga',
        description: 'Duration: 45 min • Intensity: Moderate',
        date: DateTime(2025, 1, 10, 8, 0),
        activity: 'Yoga',
        duration: 45,
        intensity: 'Moderate',
      ),
      ExerciseEvent(
        id: '6',
        title: 'Morning Walk',
        description: 'Duration: 30 min • Intensity: Light',
        date: DateTime(2025, 1, 12, 7, 30),
        activity: 'Morning Walk',
        duration: 30,
        intensity: 'Light',
      ),
      ExerciseEvent(
        id: '7',
        title: 'Stretching',
        description: 'Duration: 25 min • Intensity: Light',
        date: DateTime(2025, 1, 15, 7, 0),
        activity: 'Stretching',
        duration: 25,
        intensity: 'Light',
      ),
      ExerciseEvent(
        id: '8',
        title: 'Yoga',
        description: 'Duration: 45 min • Intensity: Moderate',
        date: DateTime(2025, 1, 17, 8, 0),
        activity: 'Yoga',
        duration: 45,
        intensity: 'Moderate',
      ),
      ExerciseEvent(
        id: '9',
        title: 'Morning Walk',
        description: 'Duration: 40 min • Intensity: Moderate',
        date: DateTime(2025, 1, 19, 7, 30),
        activity: 'Morning Walk',
        duration: 40,
        intensity: 'Moderate',
      ),
      ExerciseEvent(
        id: '10',
        title: 'Stretching',
        description: 'Duration: 20 min • Intensity: Light',
        date: DateTime(2025, 1, 22, 7, 0),
        activity: 'Stretching',
        duration: 20,
        intensity: 'Light',
      ),
      ExerciseEvent(
        id: '11',
        title: 'Yoga',
        description: 'Duration: 45 min • Intensity: Moderate',
        date: DateTime(2025, 1, 24, 8, 0),
        activity: 'Yoga',
        duration: 45,
        intensity: 'Moderate',
      ),
      ExerciseEvent(
        id: '12',
        title: 'Morning Walk',
        description: 'Duration: 35 min • Intensity: Moderate',
        date: DateTime(2025, 1, 26, 7, 30),
        activity: 'Morning Walk',
        duration: 35,
        intensity: 'Moderate',
      ),
      ExerciseEvent(
        id: '13',
        title: 'Stretching',
        description: 'Duration: 25 min • Intensity: Light',
        date: DateTime(2025, 1, 29, 7, 0),
        activity: 'Stretching',
        duration: 25,
        intensity: 'Light',
      ),
      ExerciseEvent(
        id: '14',
        title: 'Yoga',
        description: 'Duration: 45 min • Intensity: Moderate',
        date: DateTime(2025, 1, 31, 8, 0),
        activity: 'Yoga',
        duration: 45,
        intensity: 'Moderate',
      ),
      ExerciseEvent(
        id: '15',
        title: 'Morning Walk',
        description: 'Duration: 30 min • Intensity: Light',
        date: DateTime(2025, 2, 1, 7, 30),
        activity: 'Morning Walk',
        duration: 30,
        intensity: 'Light',
      ),
      ExerciseEvent(
        id: '16',
        title: 'Yoga',
        description: 'Duration: 45 min • Intensity: Moderate',
        date: DateTime(2025, 2, 2, 8, 0),
        activity: 'Yoga',
        duration: 45,
        intensity: 'Moderate',
      ),
    ];
  }

  Event _parseEvent(Map<String, dynamic> eventData) {
    final metadata = EventMetadata();
    if (eventData['metadata'] != null) {
      (eventData['metadata'] as Map<String, dynamic>).forEach((key, value) {
        metadata.set(key, value);
      });
    }

    // Map old event types to new ones
    final typeStr = eventData['type'] as String;
    final type = switch (typeStr) {
      'medication' => EventType.pills,
      'meal' => EventType.food,
      'exercise' => EventType.exercise,
      'measurement' => EventType.heartRate,
      _ => EventType.misc,
    };

    return Event(
      id: eventData['id'],
      title: eventData['title'],
      description: eventData['description'],
      date: DateTime.parse(eventData['startDate']),
      type: type,
      metadata: metadata,
    );
  }

  // GET - Return the static server events
  Future<List<Event>> get(String endpoint) async {
    await _initializeServerData();
    await Future.delayed(_delay);
    print('Mock Server returning ${_serverEvents.length} events:');
    for (final event in _serverEvents) {
      print('- ${event.title} at ${event.date.hour}:${event.date.minute}');
    }
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
