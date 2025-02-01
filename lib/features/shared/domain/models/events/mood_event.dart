import 'package:flutter/material.dart';
import '../../../../../core/constants/event_types.dart';
import '../event.dart';

class MoodEvent extends Event {
  final int level; // 1-5 or 1-10
  final List<String> triggers;
  final String? emotion; // happy, sad, anxious, etc.
  final String? notes;

  MoodEvent({
    required super.id,
    required super.title,
    super.description,
    required super.date,
    required this.level,
    this.triggers = const [],
    this.emotion,
    this.notes,
    super.metadata,
    super.customColor,
  }) : super(type: EventType.mood);

  @override
  Event copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? date,
    EventType? type,
    EventMetadata? metadata,
    Color? customColor,
    int? level,
    List<String>? triggers,
    String? emotion,
    String? notes,
  }) {
    return MoodEvent(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      level: level ?? this.level,
      triggers: triggers ?? this.triggers,
      emotion: emotion ?? this.emotion,
      notes: notes ?? this.notes,
      metadata: metadata ?? this.metadata,
      customColor: customColor ?? this.customColor,
    );
  }
}
