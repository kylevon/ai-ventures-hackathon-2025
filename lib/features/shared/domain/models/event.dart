import 'package:flutter/material.dart';
import '../../../../core/constants/event_types.dart';

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
  final EventType type;
  final EventMetadata metadata;
  final Color? customColor;

  Event({
    required this.id,
    required this.title,
    this.description,
    required this.date,
    required this.type,
    EventMetadata? metadata,
    this.customColor,
  }) : metadata = metadata ?? EventMetadata();

  // Helper method to get event color
  Color get color => customColor ?? type.color;

  // Create a copy with some fields changed
  Event copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? date,
    EventType? type,
    EventMetadata? metadata,
    Color? customColor,
  }) {
    return Event(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      type: type ?? this.type,
      metadata: metadata ?? this.metadata,
      customColor: customColor ?? this.customColor,
    );
  }
}
