import 'package:flutter/material.dart';
import '../../../domain/models/input_option.dart';
import 'circular_menu_layout.dart';
import 'circular_menu_options.dart';

class CircularMenu extends StatelessWidget {
  const CircularMenu({super.key});

  @override
  Widget build(BuildContext context) => _buildMenu();

  Widget _buildMenu() {
    return CircularMenuLayout(
      options: CircularMenuOptions.getOptions(),
      onOptionTap: _handleOptionTap,
    );
  }

  void _handleOptionTap(BuildContext context, InputOption option) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${option.label} input selected'),
        duration: const Duration(seconds: 1),
      ),
    );
  }
}
