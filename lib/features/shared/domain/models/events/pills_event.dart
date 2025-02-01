import 'package:flutter/material.dart';
import '../../../../../core/constants/event_types.dart';
import '../event.dart';

class PillsEvent extends Event {
  final String medication;
  final String? dosage;
  final bool taken;

  PillsEvent({
    required super.id,
    required super.title,
    super.description,
    required super.date,
    required this.medication,
    this.dosage,
    this.taken = false,
    super.metadata,
    super.customColor,
  }) : super(type: EventType.pills);

  @override
  Event copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? date,
    EventType? type,
    EventMetadata? metadata,
    Color? customColor,
    String? medication,
    String? dosage,
    bool? taken,
  }) {
    return PillsEvent(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      medication: medication ?? this.medication,
      dosage: dosage ?? this.dosage,
      taken: taken ?? this.taken,
      metadata: metadata ?? this.metadata,
      customColor: customColor ?? this.customColor,
    );
  }
}
