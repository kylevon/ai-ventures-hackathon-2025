import 'package:flutter/material.dart';
import '../../../../../core/constants/event_types.dart';
import '../event.dart';

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
    int? calories,
    double? protein,
    double? carbs,
    double? fat,
    List<String>? ingredients,
    String? mealType,
  }) {
    return FoodEvent(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      calories: calories ?? this.calories,
      protein: protein ?? this.protein,
      carbs: carbs ?? this.carbs,
      fat: fat ?? this.fat,
      ingredients: ingredients ?? this.ingredients,
      mealType: mealType ?? this.mealType,
      metadata: metadata ?? this.metadata,
      customColor: customColor ?? this.customColor,
    );
  }
}
