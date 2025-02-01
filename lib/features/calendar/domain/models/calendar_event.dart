import 'package:flutter/material.dart';

/// Base class for event metadata that can be extended
class EventMetadata {
  final Map<String, dynamic> _data = {};

  void set(String key, dynamic value) => _data[key] = value;
  T? get<T>(String key) => _data[key] as T?;
  bool has(String key) => _data.containsKey(key);
  void remove(String key) => _data.remove(key);
  Map<String, dynamic> toJson() => Map.from(_data);
}

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

  bool get requiresDuration {
    switch (this) {
      case EventType.exercise:
      case EventType.sleep:
      case EventType.appointment:
        return true;
      default:
        return false;
    }
  }

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

/// Main calendar event class
class CalendarEvent {
  final String id;
  final String title;
  final String? description;
  final DateTime startDate;
  final DateTime endDate;
  final TimeOfDay? startTime;
  TimeOfDay? endTime;
  final EventType type;
  final bool isAllDay;
  final bool isRecurring;
  final String? recurrenceRule;
  final EventMetadata metadata;
  final Color? customColor;
  final String? location;
  final List<String> tags;
  final DateTime createdAt;
  final DateTime updatedAt;

  CalendarEvent({
    String? id,
    required this.title,
    this.description,
    required this.startDate,
    DateTime? endDate,
    this.startTime,
    this.endTime,
    this.type = EventType.custom,
    this.isAllDay = false,
    this.isRecurring = false,
    this.recurrenceRule,
    EventMetadata? metadata,
    this.customColor,
    this.location,
    List<String>? tags,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : id = id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        endDate = type.requiresDuration
            ? (endDate ?? startDate.add(const Duration(hours: 1)))
            : startDate,
        metadata = metadata ?? EventMetadata(),
        tags = tags ?? [],
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now() {
    // Enforce endTime for duration-based events
    if (type.requiresDuration && startTime != null) {
      this.endTime = endTime ??
          TimeOfDay(
            hour: (startTime!.hour + 1) % 24,
            minute: startTime!.minute,
          );
    }
  }

  // Copy with method for immutability
  CalendarEvent copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? startDate,
    DateTime? endDate,
    TimeOfDay? startTime,
    TimeOfDay? endTime,
    EventType? type,
    bool? isAllDay,
    bool? isRecurring,
    String? recurrenceRule,
    EventMetadata? metadata,
    Color? customColor,
    String? location,
    List<String>? tags,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CalendarEvent(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      type: type ?? this.type,
      isAllDay: isAllDay ?? this.isAllDay,
      isRecurring: isRecurring ?? this.isRecurring,
      recurrenceRule: recurrenceRule ?? this.recurrenceRule,
      metadata: metadata ?? this.metadata,
      customColor: customColor ?? this.customColor,
      location: location ?? this.location,
      tags: tags ?? List.from(this.tags),
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  // Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'startTime':
          startTime != null ? '${startTime!.hour}:${startTime!.minute}' : null,
      'endTime': endTime != null ? '${endTime!.hour}:${endTime!.minute}' : null,
      'type': type.name,
      'isAllDay': isAllDay,
      'isRecurring': isRecurring,
      'recurrenceRule': recurrenceRule,
      'metadata': metadata.toJson(),
      'customColor': customColor?.value,
      'location': location,
      'tags': tags,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // Create from JSON
  factory CalendarEvent.fromJson(Map<String, dynamic> json) {
    TimeOfDay? parseTimeString(String? timeStr) {
      if (timeStr == null) return null;
      final parts = timeStr.split(':');
      return TimeOfDay(
        hour: int.parse(parts[0]),
        minute: int.parse(parts[1]),
      );
    }

    final metadata = EventMetadata();
    if (json['metadata'] != null) {
      (json['metadata'] as Map<String, dynamic>).forEach((key, value) {
        metadata.set(key, value);
      });
    }

    return CalendarEvent(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      startTime: parseTimeString(json['startTime']),
      endTime: parseTimeString(json['endTime']),
      type: EventType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => EventType.custom,
      ),
      isAllDay: json['isAllDay'] ?? false,
      isRecurring: json['isRecurring'] ?? false,
      recurrenceRule: json['recurrenceRule'],
      metadata: metadata,
      customColor:
          json['customColor'] != null ? Color(json['customColor']) : null,
      location: json['location'],
      tags: List<String>.from(json['tags'] ?? []),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  // Helper method to get event color
  Color get color => customColor ?? type.color;

  // Helper method to check if event is happening now
  bool get isHappeningNow {
    final now = DateTime.now();
    return now.isAfter(startDate) && now.isBefore(endDate);
  }

  // Helper method to get duration
  Duration get duration => endDate.difference(startDate);

  // Helper method to format time range
  String get timeRange {
    if (isAllDay) return 'All day';
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

  // Helper method to check conflicts with another event
  bool conflictsWith(CalendarEvent other) {
    if (isAllDay || other.isAllDay) return false;
    if (endDate.isBefore(other.startDate) || startDate.isAfter(other.endDate)) {
      return false;
    }
    return true;
  }
}
