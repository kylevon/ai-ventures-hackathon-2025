import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../../domain/models/input_option.dart';
import 'circular_menu_button.dart';

class CircularMenuLayout extends StatelessWidget {
  final List<InputOption> options;
  final Function(BuildContext, InputOption) onOptionTap;
  final VoidCallback? onCenterTap;

  const CircularMenuLayout({
    super.key,
    required this.options,
    required this.onOptionTap,
    this.onCenterTap,
  });

  @override
  Widget build(BuildContext context) => _buildLayout();

  Widget _buildLayout() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final dimensions = _calculateDimensions(constraints);
        return Stack(
          children: [
            _buildCenterButton(context, dimensions),
            ..._buildSurroundingButtons(context, dimensions),
          ],
        );
      },
    );
  }

  Widget _buildCenterButton(BuildContext context, _MenuDimensions dimensions) {
    final centerOption = options.firstWhere((option) => option.isCenter);
    return Positioned.fill(
      child: Center(
        child: CircularMenuButton(
          option: centerOption,
          size: dimensions.centerButtonSize,
          onTap: onCenterTap ?? () => onOptionTap(context, centerOption),
        ),
      ),
    );
  }

  List<Widget> _buildSurroundingButtons(
    BuildContext context,
    _MenuDimensions dimensions,
  ) {
    final otherOptions = options.where((option) => !option.isCenter).toList();
    return List.generate(otherOptions.length, (index) {
      final position = _calculateButtonPosition(
        index,
        otherOptions.length,
        dimensions,
      );
      final option = otherOptions[index];

      return Positioned(
        left: position.left,
        top: position.top,
        child: CircularMenuButton(
          option: option,
          size: dimensions.surroundingButtonSize,
          onTap: () => onOptionTap(context, option),
        ),
      );
    });
  }

  _MenuDimensions _calculateDimensions(BoxConstraints constraints) {
    final smallerDimension = math.min(
      constraints.maxWidth,
      constraints.maxHeight,
    );
    return _MenuDimensions(
      radius: smallerDimension * 0.35,
      centerButtonSize: smallerDimension * 0.2,
      surroundingButtonSize: smallerDimension * 0.15,
      containerWidth: constraints.maxWidth,
      containerHeight: constraints.maxHeight,
    );
  }

  _ButtonPosition _calculateButtonPosition(
    int index,
    int totalButtons,
    _MenuDimensions dimensions,
  ) {
    final angle = (2 * math.pi * index) / totalButtons;
    final x = dimensions.radius * math.cos(angle - math.pi / 2);
    final y = dimensions.radius * math.sin(angle - math.pi / 2);

    return _ButtonPosition(
      left: dimensions.containerWidth / 2 +
          x -
          dimensions.surroundingButtonSize / 2,
      top: dimensions.containerHeight / 2 +
          y -
          dimensions.surroundingButtonSize / 2,
    );
  }
}

class _MenuDimensions {
  final double radius;
  final double centerButtonSize;
  final double surroundingButtonSize;
  final double containerWidth;
  final double containerHeight;

  const _MenuDimensions({
    required this.radius,
    required this.centerButtonSize,
    required this.surroundingButtonSize,
    required this.containerWidth,
    required this.containerHeight,
  });
}

class _ButtonPosition {
  final double left;
  final double top;

  const _ButtonPosition({
    required this.left,
    required this.top,
  });
}
