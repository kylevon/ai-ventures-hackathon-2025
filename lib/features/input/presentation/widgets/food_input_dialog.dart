import 'package:flutter/material.dart';
import 'package:michro_flutter/features/shared/domain/models/events/food_event.dart';

class FoodInputDialog extends StatefulWidget {
  final DateTime selectedDate;
  final Function(String) onSave;

  const FoodInputDialog({
    super.key,
    required this.selectedDate,
    required this.onSave,
  });

  @override
  State<FoodInputDialog> createState() => _FoodInputDialogState();
}

class _FoodInputDialogState extends State<FoodInputDialog> {
  final _foodDescriptionController = TextEditingController();

  @override
  void dispose() {
    _foodDescriptionController.dispose();
    super.dispose();
  }

  void _handleSave() {
    if (_foodDescriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please describe your food')),
      );
      return;
    }

    widget.onSave(_foodDescriptionController.text);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('What did you eat?'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _foodDescriptionController,
            decoration: const InputDecoration(
              hintText: 'Describe your food...',
              helperText:
                  'Example: "I had a chicken sandwich with lettuce and tomato"',
            ),
            maxLines: 3,
            textCapitalization: TextCapitalization.sentences,
            autofocus: true,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton.icon(
          onPressed: _handleSave,
          icon: const Icon(Icons.send),
          label: const Text('Send'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).primaryColor,
            foregroundColor: Colors.white,
          ),
        ),
      ],
    );
  }
}
