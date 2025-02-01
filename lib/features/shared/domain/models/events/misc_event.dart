import 'package:flutter/material.dart';
import '../../../../../core/constants/event_types.dart';
import '../event.dart';

class MiscEvent extends Event {
  final String category;
  final Map<String, dynamic> customData;

  MiscEvent({
    required super.id,
    required super.title,
    super.description,
    required super.date,
    required this.category,
    this.customData = const {},
    super.metadata,
    super.customColor,
  }) : super(type: EventType.misc);

  @override
  Event copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? date,
    EventType? type,
    EventMetadata? metadata,
    Color? customColor,
    String? category,
    Map<String, dynamic>? customData,
  }) {
    return MiscEvent(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      category: category ?? this.category,
      customData: customData ?? this.customData,
      metadata: metadata ?? this.metadata,
      customColor: customColor ?? this.customColor,
    );
  }
}
