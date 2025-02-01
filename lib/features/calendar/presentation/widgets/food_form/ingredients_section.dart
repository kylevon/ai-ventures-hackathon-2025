import 'package:flutter/material.dart';
import 'food_form_fields.dart';

class IngredientsSection extends StatelessWidget {
  final TextEditingController ingredientController;
  final List<String> ingredients;
  final Function() onAdd;
  final Function(String) onRemove;

  const IngredientsSection({
    super.key,
    required this.ingredientController,
    required this.ingredients,
    required this.onAdd,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildIngredientInput(),
        const SizedBox(height: 8),
        _buildIngredientsList(),
      ],
    );
  }

  Widget _buildIngredientInput() {
    return Row(
      children: [
        Expanded(child: _buildTextField()),
        const SizedBox(width: 8),
        _buildAddButton(),
      ],
    );
  }

  Widget _buildTextField() {
    return TextFormField(
      controller: ingredientController,
      decoration: FoodFormFields.getInputDecoration('Add Ingredient'),
      onFieldSubmitted: (_) => onAdd(),
    );
  }

  Widget _buildAddButton() {
    return IconButton(
      icon: const Icon(Icons.add_circle),
      onPressed: onAdd,
    );
  }

  Widget _buildIngredientsList() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: ingredients.map(_buildIngredientChip).toList(),
    );
  }

  Widget _buildIngredientChip(String ingredient) {
    return Chip(
      label: Text(ingredient),
      onDeleted: () => onRemove(ingredient),
      deleteIcon: const Icon(Icons.cancel, size: 18),
    );
  }
}
