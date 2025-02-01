import 'package:flutter/material.dart';

class OmegaRatioBar extends StatelessWidget {
  final double omega3Value;
  final double omega6Value;

  const OmegaRatioBar({
    super.key,
    required this.omega3Value,
    required this.omega6Value,
  });

  Color _getProgressColor(double ratio) {
    if (ratio >= 0.8) return Colors.green; // Close to 1:1 or better
    if (ratio >= 0.5) return Colors.yellow; // Moving towards good ratio
    if (ratio >= 0.25) return Colors.orange; // Poor ratio
    return Colors.red; // Very poor ratio
  }

  @override
  Widget build(BuildContext context) {
    final ratio = omega3Value / omega6Value;
    final color = _getProgressColor(ratio);
    final percentage = (ratio * 100).clamp(0.0, 150.0);

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
                  'Omega-3:6 Ratio',
                  style: Theme.of(context).textTheme.titleMedium,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${omega3Value.toStringAsFixed(1)}:${omega6Value.toStringAsFixed(1)}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: (percentage / 100).clamp(0.0, 1.5),
              backgroundColor: Colors.grey[200],
              color: color,
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '1:${(1 / ratio).toStringAsFixed(1)} ratio (ideal is 1:1 to 1:4)',
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
