import 'package:flutter/material.dart';
import '../../../../../core/constants/event_types.dart';
import '../event.dart';

class SymptomsEvent extends Event {
  final String symptom;
  final int severity; // 1-10
  final String? location; // body part
  final List<String> triggers;
  final String? relief;

  SymptomsEvent({
    required super.id,
    required super.title,
    super.description,
    required super.date,
    required this.symptom,
    required this.severity,
    this.location,
    this.triggers = const [],
    this.relief,
    super.metadata,
    super.customColor,
  }) : super(type: EventType.symptoms);

  @override
  Event copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? date,
    EventType? type,
    EventMetadata? metadata,
    Color? customColor,
    String? symptom,
    int? severity,
    String? location,
    List<String>? triggers,
    String? relief,
  }) {
    return SymptomsEvent(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      symptom: symptom ?? this.symptom,
      severity: severity ?? this.severity,
      location: location ?? this.location,
      triggers: triggers ?? this.triggers,
      relief: relief ?? this.relief,
      metadata: metadata ?? this.metadata,
      customColor: customColor ?? this.customColor,
    );
  }
}
