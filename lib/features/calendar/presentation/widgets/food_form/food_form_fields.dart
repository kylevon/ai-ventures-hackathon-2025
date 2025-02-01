import 'package:flutter/material.dart';

class FoodFormFields {
  static InputDecoration getInputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: const OutlineInputBorder(),
    );
  }

  static String? validateRequired(String? value, String fieldName) {
    return value?.isEmpty == true ? 'Please enter $fieldName' : null;
  }

  static List<DropdownMenuItem<String>> getMealTypeItems(
      List<String> mealTypes) {
    return mealTypes
        .map((type) => DropdownMenuItem(
              value: type,
              child: Text(type[0].toUpperCase() + type.substring(1)),
            ))
        .toList();
  }
}
