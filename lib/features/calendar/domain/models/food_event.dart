import 'package:flutter/material.dart';
import 'calendar_event.dart';

class FoodMetadata extends EventMetadata {
  double? calories;
  double? protein;
  double? carbs;
  double? fat;
  List<String> ingredients;
  String? mealType; // breakfast, lunch, dinner, snack

  FoodMetadata({
    this.calories,
    this.protein,
    this.carbs,
    this.fat,
    List<String>? ingredients,
    this.mealType,
  }) : ingredients = ingredients ?? [] {
    set('calories', calories);
    set('protein', protein);
    set('carbs', carbs);
    set('fat', fat);
    set('ingredients', ingredients);
    set('mealType', mealType);
  }

  factory FoodMetadata.fromJson(Map<String, dynamic> json) {
    return FoodMetadata(
      calories: json['calories']?.toDouble(),
      protein: json['protein']?.toDouble(),
      carbs: json['carbs']?.toDouble(),
      fat: json['fat']?.toDouble(),
      ingredients: List<String>.from(json['ingredients'] ?? []),
      mealType: json['mealType'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'calories': calories,
      'protein': protein,
      'carbs': carbs,
      'fat': fat,
      'ingredients': ingredients,
      'mealType': mealType,
    };
  }
}
