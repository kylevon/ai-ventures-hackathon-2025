import 'package:flutter/material.dart';
import '../../domain/models/calendar_event.dart';
import '../widgets/food_event_form.dart';

class AddEventDialog extends StatelessWidget {
  final DateTime selectedDate;
  final Function(CalendarEvent) onSave;

  const AddEventDialog({
    super.key,
    required this.selectedDate,
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
      title: const Text('Add Food Event'),
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
      selectedDate: selectedDate,
      onSave: onSave,
    );
  }
}
