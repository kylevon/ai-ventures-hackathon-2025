import 'package:flutter/material.dart';
import '../../../../../core/constants/event_types.dart';
import '../event.dart';

class PeriodEvent extends Event {
  final String flow; // light, medium, heavy
  final List<String> symptoms;
  final bool cramps;
  final int? painLevel; // 1-10

  PeriodEvent({
    required super.id,
    required super.title,
    super.description,
    required super.date,
    required this.flow,
    this.symptoms = const [],
    this.cramps = false,
    this.painLevel,
    super.metadata,
    super.customColor,
  }) : super(type: EventType.period);

  @override
  Event copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? date,
    EventType? type,
    EventMetadata? metadata,
    Color? customColor,
    String? flow,
    List<String>? symptoms,
    bool? cramps,
    int? painLevel,
  }) {
    return PeriodEvent(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      flow: flow ?? this.flow,
      symptoms: symptoms ?? this.symptoms,
      cramps: cramps ?? this.cramps,
      painLevel: painLevel ?? this.painLevel,
      metadata: metadata ?? this.metadata,
      customColor: customColor ?? this.customColor,
    );
  }
}
