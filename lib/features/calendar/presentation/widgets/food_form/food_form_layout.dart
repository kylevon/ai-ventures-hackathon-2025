import 'package:flutter/material.dart';
import 'meal_time_section.dart';
import 'nutrition_fields.dart';
import 'ingredients_section.dart';

class FoodFormLayout extends StatelessWidget {
  final Widget basicFields;
  final MealTimeSection mealTimeSection;
  final NutritionFields nutritionFields;
  final IngredientsSection ingredientsSection;
  final VoidCallback onSave;

  const FoodFormLayout({
    super.key,
    required this.basicFields,
    required this.mealTimeSection,
    required this.nutritionFields,
    required this.ingredientsSection,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSection(basicFields),
        _buildSection(mealTimeSection),
        _buildSection(nutritionFields),
        _buildSection(ingredientsSection),
        _buildSaveButton(),
      ],
    );
  }

  Widget _buildSection(Widget section) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: section,
    );
  }

  Widget _buildSaveButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: ElevatedButton(
        onPressed: onSave,
        child: const Text('Save'),
      ),
    );
  }
}
