import 'package:flutter/material.dart';
import 'package:michro_flutter/core/theme/app_theme.dart';
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
    return [
      _createOption(
        Icons.restaurant_menu,
        'Food',
        AppTheme.primary[400]!,
      ),
      _createOption(
        Icons.medication,
        'Pills',
        AppTheme.primary[500]!,
      ),
      _createOption(
        Icons.mic,
        'Voice',
        AppTheme.primary[600]!,
      ),
      _createOption(
        Icons.camera_alt,
        'Camera',
        AppTheme.primary[700]!,
      ),
      _createOption(
        Icons.wc,
        'Bowel',
        AppTheme.primary[800]!,
      ),
      _createOption(
        Icons.mood,
        'Mood',
        AppTheme.primary[300]!,
      ),
      _createOption(
        Icons.water_drop,
        'Menstrual',
        AppTheme.primary[400]!,
      ),
      _createOption(
        Icons.bedtime,
        'Sleep',
        AppTheme.primary[600]!,
      ),
    ];
  }

  static InputOption _createOption(IconData icon, String label, Color color) {
    return InputOption(
      icon: icon,
      label: label,
      color: color,
    );
  }
}
