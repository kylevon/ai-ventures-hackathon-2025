import 'package:flutter/material.dart';
import '../../../../../core/constants/event_types.dart';
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
      color: EventType.misc.color,
      isCenter: true,
    );
  }

  static List<InputOption> _createSurroundingOptions() {
    // Select 8 most important event types for the circular menu
    final mainEventTypes = [
      EventType.exercise,
      EventType.sleep,
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
