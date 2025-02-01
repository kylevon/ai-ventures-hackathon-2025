import 'package:flutter/material.dart';
import '../../../../../core/constants/event_types.dart';
import '../event.dart';

class LiquidsEvent extends Event {
  final double amount; // in milliliters
  final String liquidType; // water, coffee, tea, etc.
  final bool caffeinated;
  final bool alcoholic;

  LiquidsEvent({
    required super.id,
    required super.title,
    super.description,
    required super.date,
    required this.amount,
    required this.liquidType,
    this.caffeinated = false,
    this.alcoholic = false,
    super.metadata,
    super.customColor,
  }) : super(type: EventType.liquids);

  @override
  Event copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? date,
    EventType? type,
    EventMetadata? metadata,
    Color? customColor,
    double? amount,
    String? liquidType,
    bool? caffeinated,
    bool? alcoholic,
  }) {
    return LiquidsEvent(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      amount: amount ?? this.amount,
      liquidType: liquidType ?? this.liquidType,
      caffeinated: caffeinated ?? this.caffeinated,
      alcoholic: alcoholic ?? this.alcoholic,
      metadata: metadata ?? this.metadata,
      customColor: customColor ?? this.customColor,
    );
  }
}
