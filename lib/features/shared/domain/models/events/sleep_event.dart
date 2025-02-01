import 'package:flutter/material.dart';
import '../../../../../core/constants/event_types.dart';
import '../event.dart';

class SleepEvent extends Event {
  final int duration; // in minutes
  final String? quality; // poor, fair, good, excellent
  final bool interrupted;
  final String? notes;

  SleepEvent({
    required super.id,
    required super.title,
    super.description,
    required super.date,
    required this.duration,
    this.quality,
    this.interrupted = false,
    this.notes,
    super.metadata,
    super.customColor,
  }) : super(type: EventType.sleep);

  @override
  Event copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? date,
    EventType? type,
    EventMetadata? metadata,
    Color? customColor,
    int? duration,
    String? quality,
    bool? interrupted,
    String? notes,
  }) {
    return SleepEvent(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      duration: duration ?? this.duration,
      quality: quality ?? this.quality,
      interrupted: interrupted ?? this.interrupted,
      notes: notes ?? this.notes,
      metadata: metadata ?? this.metadata,
      customColor: customColor ?? this.customColor,
    );
  }
}
