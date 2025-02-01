import 'package:flutter/material.dart';
import '../../../../../core/constants/event_types.dart';
import '../event.dart';

class HeartRateEvent extends Event {
  final int bpm;
  final String? context; // resting, exercise, stress, etc.
  final bool irregular;
  final String? symptoms;

  HeartRateEvent({
    required super.id,
    required super.title,
    super.description,
    required super.date,
    required this.bpm,
    this.context,
    this.irregular = false,
    this.symptoms,
    super.metadata,
    super.customColor,
  }) : super(type: EventType.heartRate);

  @override
  Event copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? date,
    EventType? type,
    EventMetadata? metadata,
    Color? customColor,
    int? bpm,
    String? context,
    bool? irregular,
    String? symptoms,
  }) {
    return HeartRateEvent(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      bpm: bpm ?? this.bpm,
      context: context ?? this.context,
      irregular: irregular ?? this.irregular,
      symptoms: symptoms ?? this.symptoms,
      metadata: metadata ?? this.metadata,
      customColor: customColor ?? this.customColor,
    );
  }
}
