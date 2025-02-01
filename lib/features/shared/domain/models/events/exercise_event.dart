import 'package:flutter/material.dart';
import '../../../../../core/constants/event_types.dart';
import '../event.dart';

class ExerciseEvent extends Event {
  final String activity;
  final int? duration; // in minutes
  final double? distance; // in kilometers
  final int? calories;
  final String? intensity; // low, medium, high

  ExerciseEvent({
    required super.id,
    required super.title,
    super.description,
    required super.date,
    required this.activity,
    this.duration,
    this.distance,
    this.calories,
    this.intensity,
    super.metadata,
    super.customColor,
  }) : super(type: EventType.exercise);

  @override
  Event copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? date,
    EventType? type,
    EventMetadata? metadata,
    Color? customColor,
    String? activity,
    int? duration,
    double? distance,
    int? calories,
    String? intensity,
  }) {
    return ExerciseEvent(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      activity: activity ?? this.activity,
      duration: duration ?? this.duration,
      distance: distance ?? this.distance,
      calories: calories ?? this.calories,
      intensity: intensity ?? this.intensity,
      metadata: metadata ?? this.metadata,
      customColor: customColor ?? this.customColor,
    );
  }
}
