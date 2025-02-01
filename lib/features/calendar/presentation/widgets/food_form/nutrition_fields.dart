import 'package:flutter/material.dart';
import 'food_form_fields.dart';

class NutritionFields extends StatelessWidget {
  final TextEditingController caloriesController;
  final TextEditingController proteinController;
  final TextEditingController carbsController;
  final TextEditingController fatController;

  const NutritionFields({
    super.key,
    required this.caloriesController,
    required this.proteinController,
    required this.carbsController,
    required this.fatController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildNutritionRow(
          firstField: _buildCaloriesField(),
          secondField: _buildProteinField(),
        ),
        const SizedBox(height: 16),
        _buildNutritionRow(
          firstField: _buildCarbsField(),
          secondField: _buildFatField(),
        ),
      ],
    );
  }

  Widget _buildNutritionRow({
    required Widget firstField,
    required Widget secondField,
  }) {
    return Row(
      children: [
        Expanded(child: firstField),
        const SizedBox(width: 16),
        Expanded(child: secondField),
      ],
    );
  }

  Widget _buildCaloriesField() {
    return TextFormField(
      controller: caloriesController,
      decoration: FoodFormFields.getInputDecoration('Calories'),
      keyboardType: TextInputType.number,
    );
  }

  Widget _buildProteinField() {
    return TextFormField(
      controller: proteinController,
      decoration: FoodFormFields.getInputDecoration('Protein (g)'),
      keyboardType: TextInputType.number,
    );
  }

  Widget _buildCarbsField() {
    return TextFormField(
      controller: carbsController,
      decoration: FoodFormFields.getInputDecoration('Carbs (g)'),
      keyboardType: TextInputType.number,
    );
  }

  Widget _buildFatField() {
    return TextFormField(
      controller: fatController,
      decoration: FoodFormFields.getInputDecoration('Fat (g)'),
      keyboardType: TextInputType.number,
    );
  }
}
