import 'package:flutter/material.dart';

class InputOption {
  final IconData icon;
  final String label;
  final Color color;
  final bool isCenter;

  const InputOption({
    required this.icon,
    required this.label,
    required this.color,
    this.isCenter = false,
  });
}
