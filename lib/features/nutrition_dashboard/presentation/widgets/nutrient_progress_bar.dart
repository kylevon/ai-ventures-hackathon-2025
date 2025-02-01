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

  @override
  Widget build(BuildContext context) {
    final percentage = nutrient.percentageOfTarget;
    final color = _getProgressColor(percentage);

    return Padding(
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
    );
  }
}
