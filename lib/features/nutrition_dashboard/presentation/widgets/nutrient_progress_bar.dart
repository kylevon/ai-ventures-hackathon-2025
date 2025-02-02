import 'package:flutter/material.dart';
import '../../domain/models/nutrient_data.dart';

class NutrientProgressBar extends StatelessWidget {
  final NutrientData nutrient;

  const NutrientProgressBar({
    super.key,
    required this.nutrient,
  });

  Color _getProgressColor(double percentage) {
    if (percentage >= 120)
      return Colors.green[800]!; // Dark green for exceeding target
    if (percentage >= 100) return Colors.green; // Green for meeting target
    if (percentage >= 80) return Colors.yellow; // Yellow for close to target
    if (percentage >= 50) return Colors.orange; // Orange for below target
    return Colors.red; // Red for significantly below target
  }

  String _getRecommendationText(double percentage) {
    if (percentage >= 120) {
      return 'Your intake is above the recommended level. Consider reducing your supplementation or dietary sources.';
    } else if (percentage >= 100) {
      return 'You are meeting your target! Keep maintaining your current intake.';
    } else if (percentage >= 80) {
      return 'You are close to your target. A small increase in intake would be beneficial.';
    } else if (percentage >= 50) {
      return 'Your intake is moderately low. Consider increasing your intake through diet or supplements.';
    } else {
      return 'Your intake is significantly low. Prioritize increasing your intake through diet and possibly supplements.';
    }
  }

  List<String> _getFoodSources() {
    return switch (nutrient.name) {
      'Vitamin A' => [
          'Sweet potatoes',
          'Carrots',
          'Spinach',
          'Eggs',
          'Halal chicken liver'
        ],
      'Vitamin D' => [
          'Halal-certified fortified milk',
          'Egg yolks',
          'Mushrooms exposed to UV light',
          'Fortified orange juice',
          'Fortified cereals'
        ],
      'Vitamin E' => [
          'Almonds',
          'Sunflower seeds',
          'Avocados',
          'Spinach',
          'Olive oil'
        ],
      'Vitamin K' => [
          'Kale',
          'Collard greens',
          'Brussels sprouts',
          'Broccoli',
          'Halal chicken'
        ],
      'Vitamin C' => [
          'Oranges',
          'Bell peppers',
          'Strawberries',
          'Broccoli',
          'Kiwi'
        ],
      'B1 (Thiamin)' => [
          'Whole grains',
          'Legumes',
          'Nuts',
          'Halal chicken',
          'Fortified cereals'
        ],
      'B2 (Riboflavin)' => [
          'Halal-certified dairy products',
          'Eggs',
          'Halal meats',
          'Green vegetables',
          'Fortified cereals'
        ],
      'B3 (Niacin)' => [
          'Halal chicken',
          'Halal turkey',
          'Peanuts',
          'Mushrooms',
          'Fortified cereals'
        ],
      'B6 (Pyridoxine)' => [
          'Chickpeas',
          'Potatoes',
          'Bananas',
          'Halal chicken',
          'Fortified cereals'
        ],
      'B12 (Cobalamin)' => [
          'Halal beef',
          'Eggs',
          'Halal-certified dairy products',
          'Fortified cereals',
          'Nutritional yeast'
        ],
      'Folate (B9)' => [
          'Leafy greens',
          'Legumes',
          'Citrus fruits',
          'Avocado',
          'Fortified grains'
        ],
      'Iron' => [
          'Halal red meat',
          'Spinach',
          'Lentils',
          'Tofu',
          'Fortified cereals'
        ],
      'Calcium' => [
          'Halal-certified dairy products',
          'Tofu',
          'Leafy greens',
          'Fortified beverages',
          'Almonds'
        ],
      'Magnesium' => [
          'Nuts',
          'Seeds',
          'Whole grains',
          'Black beans',
          'Avocado'
        ],
      'Zinc' => [
          'Halal beef',
          'Halal chicken',
          'Pumpkin seeds',
          'Lentils',
          'Halal-certified yogurt'
        ],
      _ => [
          'Consult a healthcare provider for specific Halal and allergen-free recommendations'
        ],
    };
  }

  void _showRecommendations(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => _NutrientRecommendationsDialog(
        nutrient: nutrient,
        recommendationText: _getRecommendationText(nutrient.percentageOfTarget),
        foodSources: _getFoodSources(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final percentage = nutrient.percentageOfTarget;
    final color = _getProgressColor(percentage);

    return InkWell(
      onTap: () => _showRecommendations(context),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    nutrient.name,
                    style: Theme.of(context).textTheme.titleMedium,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${nutrient.currentValue.toStringAsFixed(1)}/${nutrient.weeklyTarget.toStringAsFixed(1)} ${nutrient.unit}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
            const SizedBox(height: 4),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: (percentage / 100).clamp(0.0, 1.5), // Cap at 150%
                backgroundColor: Colors.grey[200],
                color: color,
                minHeight: 8,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${percentage.toStringAsFixed(1)}% of weekly target',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NutrientRecommendationsDialog extends StatelessWidget {
  final NutrientData nutrient;
  final String recommendationText;
  final List<String> foodSources;

  const _NutrientRecommendationsDialog({
    required this.nutrient,
    required this.recommendationText,
    required this.foodSources,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('${nutrient.name} Recommendations'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Status',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(recommendationText),
            const SizedBox(height: 16),
            Text(
              'Good Food Sources (Halal & Seafood-Free)',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            ...foodSources.map((food) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    children: [
                      const Icon(Icons.fiber_manual_record, size: 8),
                      const SizedBox(width: 8),
                      Text(food),
                    ],
                  ),
                )),
            const SizedBox(height: 16),
            Text(
              'Note: All recommendations are Halal-compliant and seafood-free. Consult with a healthcare provider before making significant changes to your diet or starting any supplements.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontStyle: FontStyle.italic,
                  ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ],
    );
  }
}
