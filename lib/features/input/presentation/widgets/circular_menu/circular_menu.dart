import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/models/input_option.dart';
import '../../../domain/controllers/input_controller.dart';
import '../../../../input_chat/presentation/pages/input_chat_page.dart';
import '../food_input_dialog.dart';
import 'circular_menu_layout.dart';
import 'circular_menu_options.dart';

class CircularMenu extends ConsumerWidget {
  const CircularMenu({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CircularMenuLayout(
      options: CircularMenuOptions.getOptions(),
      onOptionTap: (context, option) => _handleOptionTap(context, ref, option),
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

  Future<void> _handleOptionTap(
      BuildContext context, WidgetRef ref, InputOption option) async {
    if (option.label == 'Food') {
      showDialog<void>(
        context: context,
        builder: (context) => FoodInputDialog(
          selectedDate: DateTime.now(),
          onSave: (description) async {
            try {
              await ref.read(inputControllerProvider).addFoodFromDescription(
                    description,
                    DateTime.now(),
                  );
              if (context.mounted) {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Food entry saved'),
                    duration: Duration(seconds: 1),
                  ),
                );
              }
            } catch (e) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error saving food entry: ${e.toString()}'),
                    backgroundColor: Colors.red,
                    duration: const Duration(seconds: 3),
                  ),
                );
              }
            }
          },
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${option.label} input selected'),
          duration: const Duration(seconds: 1),
        ),
      );
    }
  }
}
