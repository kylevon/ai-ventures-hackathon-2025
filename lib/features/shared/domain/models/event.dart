import 'package:flutter/material.dart';

/// Enum for different types of events
enum EventType {
  medication,
  meal,
  exercise,
  sleep,
  symptom,
  measurement,
  appointment,
  reminder,
  custom;

  String get displayName => name[0].toUpperCase() + name.substring(1);

  Color get color {
    switch (this) {
      case EventType.medication:
        return Colors.blue;
      case EventType.meal:
        return Colors.orange;
      case EventType.exercise:
        return Colors.green;
      case EventType.sleep:
        return Colors.indigo;
      case EventType.symptom:
        return Colors.red;
      case EventType.measurement:
        return Colors.purple;
      case EventType.appointment:
        return Colors.teal;
      case EventType.reminder:
        return Colors.amber;
      case EventType.custom:
        return Colors.grey;
    }
  }
}

/// Base class for event metadata
class EventMetadata {
  final Map<String, dynamic> _data = {};

  EventMetadata();

  void set(String key, dynamic value) => _data[key] = value;
  T? get<T>(String key) => _data[key] as T?;
  bool has(String key) => _data.containsKey(key);
  void remove(String key) => _data.remove(key);
  Map<String, dynamic> toJson() => Map.from(_data);
}

/// Base event class that can be used by both calendar and clock
class Event {
  final String id;
  final String title;
  final String? description;
  final DateTime date;
  final TimeOfDay? startTime;
  final TimeOfDay? endTime;
  final EventType type;
  final EventMetadata metadata;
  final Color? customColor;

  Event({
    required this.id,
    required this.title,
    this.description,
    required this.date,
    this.startTime,
    this.endTime,
    required this.type,
    EventMetadata? metadata,
    this.customColor,
  }) : metadata = metadata ?? EventMetadata();

  // Helper method to get event color
  Color get color => customColor ?? type.color;

  // Helper method to format time range
  String get timeRange {
    if (startTime == null) return 'No time specified';

    String formatTime(TimeOfDay time) {
      final hour = time.hour.toString().padLeft(2, '0');
      final minute = time.minute.toString().padLeft(2, '0');
      return '$hour:$minute';
    }

    if (endTime == null) {
      return formatTime(startTime!);
    }
    return '${formatTime(startTime!)} - ${formatTime(endTime!)}';
  }

  // Create a copy with some fields changed
  Event copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? date,
    TimeOfDay? startTime,
    TimeOfDay? endTime,
    EventType? type,
    EventMetadata? metadata,
    Color? customColor,
  }) {
    return Event(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      type: type ?? this.type,
      metadata: metadata ?? this.metadata,
      customColor: customColor ?? this.customColor,
    );
  }
}
