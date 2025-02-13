import 'package:flutter/material.dart';
import '../../../../core/constants/event_types.dart';
import 'event.dart';

class FoodEvent extends Event {
  final int calories;
  final double? protein;
  final double? carbs;
  final double? fat;
  final List<String>? ingredients;
  final String? mealType;

  FoodEvent({
    required super.id,
    required super.title,
    super.description,
    required super.date,
    required this.calories,
    this.protein,
    this.carbs,
    this.fat,
    this.ingredients,
    this.mealType,
    super.metadata,
    super.customColor,
  }) : super(type: EventType.food);

  @override
  Event copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? date,
    EventType? type,
    EventMetadata? metadata,
    Color? customColor,
  }) {
    return FoodEvent(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      calories: calories,
      protein: protein,
      carbs: carbs,
      fat: fat,
      ingredients: ingredients,
      mealType: mealType,
      metadata: metadata ?? this.metadata,
      customColor: customColor ?? this.customColor,
    );
  }
}
