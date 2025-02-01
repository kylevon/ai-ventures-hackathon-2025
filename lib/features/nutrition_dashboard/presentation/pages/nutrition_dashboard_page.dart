import 'package:flutter/material.dart';

class NutritionDashboardPage extends StatelessWidget {
  const NutritionDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.bar_chart, size: 48),
          SizedBox(height: 16),
          Text('Nutrition Dashboard Coming Soon'),
        ],
      ),
    );
  }
}
