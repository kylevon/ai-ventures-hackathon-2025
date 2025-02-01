import 'package:flutter/material.dart';
import 'package:michro_flutter/features/shared/domain/models/event.dart';
import '../widgets/food_event_form.dart';

class EditEventDialog extends StatelessWidget {
  final Event event;
  final Function(Event) onSave;

  const EditEventDialog({
    super.key,
    required this.event,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildAppBar(context),
          Expanded(child: _buildForm()),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text('Edit Food Event'),
      automaticallyImplyLeading: false,
      actions: [
        IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }

  Widget _buildForm() {
    return FoodEventForm(
      event: event,
      selectedDate: event.date,
      onSave: onSave,
    );
  }
}
