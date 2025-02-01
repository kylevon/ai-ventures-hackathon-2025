import 'package:flutter/material.dart';
import '../../domain/models/nutrient_data.dart';
import '../widgets/nutrient_progress_bar.dart';
import '../widgets/omega_ratio_bar.dart';

class NutritionDashboardPage extends StatelessWidget {
  const NutritionDashboardPage({super.key});

  List<NutrientData> _getMockNutrientData() {
    return [
      // Vitamins
      NutrientData(
        name: 'Vitamin A',
        currentValue: 4500,
        weeklyTarget: 5600, // 800 mcg daily * 7
        unit: 'mcg',
      ),
      NutrientData(
        name: 'Vitamin D',
        currentValue: 105,
        weeklyTarget: 140, // 20 mcg daily * 7
        unit: 'mcg',
      ),
      NutrientData(
        name: 'Vitamin E',
        currentValue: 150,
        weeklyTarget: 105, // 15 mg daily * 7
        unit: 'mg',
      ),
      NutrientData(
        name: 'Vitamin K',
        currentValue: 420,
        weeklyTarget: 630, // 90 mcg daily * 7
        unit: 'mcg',
      ),
      NutrientData(
        name: 'Vitamin C',
        currentValue: 480,
        weeklyTarget: 490, // 70 mg daily * 7
        unit: 'mg',
      ),
      // B Vitamins
      NutrientData(
        name: 'B1 (Thiamin)',
        currentValue: 5.2,
        weeklyTarget: 8.4, // 1.2 mg daily * 7
        unit: 'mg',
      ),
      NutrientData(
        name: 'B2 (Riboflavin)',
        currentValue: 9.8,
        weeklyTarget: 8.4, // 1.2 mg daily * 7
        unit: 'mg',
      ),
      NutrientData(
        name: 'B3 (Niacin)',
        currentValue: 95,
        weeklyTarget: 112, // 16 mg daily * 7
        unit: 'mg',
      ),
      NutrientData(
        name: 'B6 (Pyridoxine)',
        currentValue: 8.5,
        weeklyTarget: 12.6, // 1.8 mg daily * 7
        unit: 'mg',
      ),
      NutrientData(
        name: 'B12 (Cobalamin)',
        currentValue: 18,
        weeklyTarget: 16.8, // 2.4 mcg daily * 7
        unit: 'mcg',
      ),
      NutrientData(
        name: 'Folate (B9)',
        currentValue: 2100,
        weeklyTarget: 2800, // 400 mcg daily * 7
        unit: 'mcg',
      ),
      // Minerals
      NutrientData(
        name: 'Iron',
        currentValue: 45,
        weeklyTarget: 56, // 8 mg daily * 7
        unit: 'mg',
      ),
      NutrientData(
        name: 'Calcium',
        currentValue: 5600,
        weeklyTarget: 7000, // 1000 mg daily * 7
        unit: 'mg',
      ),
      NutrientData(
        name: 'Magnesium',
        currentValue: 2800,
        weeklyTarget: 2450, // 350 mg daily * 7
        unit: 'mg',
      ),
      NutrientData(
        name: 'Zinc',
        currentValue: 55,
        weeklyTarget: 77, // 11 mg daily * 7
        unit: 'mg',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final nutrients = _getMockNutrientData();
    // Example omega values (you can adjust these)
    const omega3Value = 2.5; // g
    const omega6Value = 5.0; // g

    return Scaffold(
      appBar: AppBar(
        title: const Text('Weekly Nutrition Overview'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Essential Vitamins',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          ...nutrients
              .where(
                  (n) => !n.name.startsWith('B') && n.name.contains('Vitamin'))
              .map((n) => NutrientProgressBar(nutrient: n)),
          const SizedBox(height: 16),
          Text(
            'B Complex Vitamins',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          ...nutrients
              .where((n) => n.name.startsWith('B'))
              .map((n) => NutrientProgressBar(nutrient: n)),
          const SizedBox(height: 16),
          Text(
            'Essential Minerals',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          ...nutrients
              .where((n) =>
                  ['Iron', 'Calcium', 'Magnesium', 'Zinc'].contains(n.name))
              .map((n) => NutrientProgressBar(nutrient: n)),
          const SizedBox(height: 16),
          Text(
            'Essential Fatty Acids',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          const OmegaRatioBar(
            omega3Value: omega3Value,
            omega6Value: omega6Value,
          ),
        ],
      ),
    );
  }
}
