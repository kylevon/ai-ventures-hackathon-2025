import 'dart:async';
import 'package:logging/logging.dart';
import '../../domain/models/event.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/event_types.dart';

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
      final events = [
        Event(
          id: '1',
          title: 'Morning Pills',
          description: 'Take morning medication',
          date: DateTime.now().copyWith(hour: 8, minute: 0),
          type: EventType.pills,
        ),
        Event(
          id: '2',
          title: 'Evening Pills',
          description: 'Take evening medication',
          date: DateTime.now().copyWith(hour: 20, minute: 0),
          type: EventType.pills,
        ),
        Event(
          id: '3',
          title: 'Morning Walk',
          description: '30 minutes walk in the park',
          date: DateTime.now().copyWith(hour: 7, minute: 30),
          type: EventType.exercise,
        ),
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
