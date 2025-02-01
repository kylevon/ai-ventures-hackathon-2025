import 'package:flutter/material.dart';
import 'food_form_fields.dart';

class MealTimeSection extends StatelessWidget {
  final String? selectedMealType;
  final TimeOfDay selectedTime;
  final List<String> mealTypes;
  final Function(String?) onMealTypeChanged;
  final Function() onTimePressed;

  const MealTimeSection({
    super.key,
    required this.selectedMealType,
    required this.selectedTime,
    required this.mealTypes,
    required this.onMealTypeChanged,
    required this.onTimePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _buildMealTypeDropdown()),
        const SizedBox(width: 16),
        Expanded(child: _buildTimeSelector(context)),
      ],
    );
  }

  Widget _buildMealTypeDropdown() {
    return DropdownButtonFormField<String>(
      value: selectedMealType,
      decoration: FoodFormFields.getInputDecoration('Meal Type'),
      items: FoodFormFields.getMealTypeItems(mealTypes),
      onChanged: onMealTypeChanged,
      validator: (value) => value == null ? 'Please select a meal type' : null,
    );
  }

  Widget _buildTimeSelector(BuildContext context) {
    return InkWell(
      onTap: onTimePressed,
      child: InputDecorator(
        decoration: FoodFormFields.getInputDecoration('Time'),
        child: Text(selectedTime.format(context)),
      ),
    );
  }
}
