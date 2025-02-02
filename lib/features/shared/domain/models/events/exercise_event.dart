import 'package:flutter/material.dart';
import '../../../../../core/constants/event_types.dart';
import '../event.dart';

class ExerciseEvent extends Event {
  final String activity;
  final int duration;
  final String intensity;

  ExerciseEvent({
    required String id,
    required String title,
    String? description,
    required DateTime date,
    required this.activity,
    required this.duration,
    required this.intensity,
    Color? customColor,
  }) : super(
          id: id,
          title: title,
          description: description,
          date: date,
          type: EventType.exercise,
          customColor: customColor,
        ) {
    metadata.set('activity', activity);
    metadata.set('duration', duration);
    metadata.set('intensity', intensity);
  }

  @override
  Event copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? date,
    EventType? type,
    EventMetadata? metadata,
    Color? customColor,
  }) {
    return ExerciseEvent(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      activity: this.activity,
      duration: this.duration,
      intensity: this.intensity,
      customColor: customColor ?? this.customColor,
    );
  }
}
