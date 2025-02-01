import 'package:flutter/material.dart';
import '../../../../../core/constants/event_types.dart';
import '../event.dart';

class AppointmentEvent extends Event {
  final String provider; // doctor, dentist, etc.
  final String? location;
  final bool completed;
  final String? outcome;

  AppointmentEvent({
    required super.id,
    required super.title,
    super.description,
    required super.date,
    required this.provider,
    this.location,
    this.completed = false,
    this.outcome,
    super.metadata,
    super.customColor,
  }) : super(type: EventType.appointments);

  @override
  Event copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? date,
    EventType? type,
    EventMetadata? metadata,
    Color? customColor,
    String? provider,
    String? location,
    bool? completed,
    String? outcome,
  }) {
    return AppointmentEvent(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      provider: provider ?? this.provider,
      location: location ?? this.location,
      completed: completed ?? this.completed,
      outcome: outcome ?? this.outcome,
      metadata: metadata ?? this.metadata,
      customColor: customColor ?? this.customColor,
    );
  }
}
