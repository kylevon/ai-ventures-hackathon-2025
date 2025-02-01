import 'package:flutter/material.dart';

class InputOption {
  final IconData icon;
  final String label;
  final Color color;
  final bool isCenter;
  final Offset? customPosition;

  const InputOption({
    required this.icon,
    required this.label,
    required this.color,
    this.isCenter = false,
    this.customPosition,
  });
}
