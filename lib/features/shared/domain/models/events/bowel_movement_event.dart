import 'package:flutter/material.dart';
import '../../../../../core/constants/event_types.dart';
import '../event.dart';

class BowelMovementEvent extends Event {
  final String consistency; // hard, normal, soft, liquid
  final String stoolColor; // brown, black, red, etc.
  final bool pain;
  final bool blood;
  final bool mucus;

  BowelMovementEvent({
    required super.id,
    required super.title,
    super.description,
    required super.date,
    required this.consistency,
    required this.stoolColor,
    this.pain = false,
    this.blood = false,
    this.mucus = false,
    super.metadata,
    super.customColor,
  }) : super(type: EventType.bowelMovement);

  @override
  Event copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? date,
    EventType? type,
    EventMetadata? metadata,
    Color? customColor,
    String? consistency,
    String? stoolColor,
    bool? pain,
    bool? blood,
    bool? mucus,
  }) {
    return BowelMovementEvent(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      consistency: consistency ?? this.consistency,
      stoolColor: stoolColor ?? this.stoolColor,
      pain: pain ?? this.pain,
      blood: blood ?? this.blood,
      mucus: mucus ?? this.mucus,
      metadata: metadata ?? this.metadata,
      customColor: customColor ?? this.customColor,
    );
  }
}
