import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/food_controller.dart';

class FoodPortionScreen extends ConsumerWidget {
  const FoodPortionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final foodItems = ref.watch(foodControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Food Portions'),
      ),
      body: ListView.builder(
        itemCount: foodItems.length,
        itemBuilder: (context, index) {
          final food = foodItems[index];
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    food.name,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Slider(
                    value: food.weightInGrams,
                    min: 0,
                    max: food.defaultWeightInGrams * 2,
                    divisions: 20,
                    label: '${food.weightInGrams.round()}g',
                    onChanged: (value) {
                      ref
                          .read(foodControllerProvider.notifier)
                          .updateFoodWeight(food.name, value);
                    },
                  ),
                ),
                Expanded(
                  child: Text(
                    '${food.weightInGrams.round()}g',
                    textAlign: TextAlign.end,
                  ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Save the portions and navigate back
          Navigator.pop(context);
        },
        child: const Icon(Icons.check),
      ),
    );
  }
}
