import 'package:flutter/material.dart';
import 'package:michro_flutter/core/theme/app_theme.dart';
import '../../../domain/models/input_option.dart';

class CircularMenuButton extends StatelessWidget {
  final InputOption option;
  final double size;
  final VoidCallback onTap;

  const CircularMenuButton({
    super.key,
    required this.option,
    required this.size,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => _buildButton();

  Widget _buildButton() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildCircularButton(),
        if (!option.isCenter) ...[
          const SizedBox(height: 8),
          _buildLabel(),
        ],
      ],
    );
  }

  Widget _buildCircularButton() {
    return Material(
      elevation: 4,
      color: option.color.withOpacity(0.9),
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: _buildButtonContent(),
      ),
    );
  }

  Widget _buildButtonContent() {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
      ),
      child: Icon(
        option.icon,
        color: AppTheme.gray[100],
        size: size * 0.5,
      ),
    );
  }

  Widget _buildLabel() {
    return Text(
      option.label,
      style: TextStyle(
        color: option.color,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
