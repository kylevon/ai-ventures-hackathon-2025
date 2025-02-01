import 'package:flutter/material.dart';
import '../../../../../core/constants/event_types.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../domain/models/input_option.dart';

class CircularMenuOptions {
  static List<InputOption> getOptions() {
    return [
      _createCenterOption(),
      ..._createSurroundingOptions(),
    ];
  }

  static InputOption _createCenterOption() {
    return InputOption(
      icon: Icons.chat_bubble_outline,
      label: 'Chat',
      color: AppTheme.primary[500]!,
      isCenter: true,
    );
  }

  static List<InputOption> _createSurroundingOptions() {
    // Keep the original 8 event types for the circle
    final mainEventTypes = [
      EventType.exercise,
      EventType.pills,
      EventType.food,
      EventType.liquids,
      EventType.period,
      EventType.bowelMovement,
      EventType.mood,
      EventType.symptoms,
    ];

    return mainEventTypes
        .map((eventType) => _createOption(
              eventType.icon,
              eventType.displayName,
              eventType.color,
            ))
        .toList();
  }

  static InputOption _createOption(IconData icon, String label, Color color) {
    return InputOption(
      icon: icon,
      label: label,
      color: color,
    );
  }
}
