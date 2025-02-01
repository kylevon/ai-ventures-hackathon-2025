import 'package:flutter/material.dart';
import '../../../domain/models/input_option.dart';
import '../../../../input_chat/presentation/pages/input_chat_page.dart';
import 'circular_menu_layout.dart';
import 'circular_menu_options.dart';

class CircularMenu extends StatelessWidget {
  const CircularMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return CircularMenuLayout(
      options: CircularMenuOptions.getOptions(),
      onOptionTap: _handleOptionTap,
      onCenterTap: () => _navigateToInputChat(context),
    );
  }

  void _navigateToInputChat(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => const InputChatPage(),
      ),
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
