import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/food_item.dart';

final foodControllerProvider =
    StateNotifierProvider<FoodController, List<FoodItem>>((ref) {
  return FoodController();
});

class FoodController extends StateNotifier<List<FoodItem>> {
  FoodController()
      : super([
          const FoodItem(
            name: 'Chicken',
            weightInGrams: 150,
            defaultWeightInGrams: 150,
          ),
          const FoodItem(
            name: 'Rice',
            weightInGrams: 200,
            defaultWeightInGrams: 200,
          ),
        ]);

  void updateFoodWeight(String name, double weight) {
    state = state.map((food) {
      if (food.name == name) {
        return food.copyWith(weightInGrams: weight);
      }
      return food;
    }).toList();
  }
}
