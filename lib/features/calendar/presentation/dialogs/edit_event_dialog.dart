import 'package:flutter/material.dart';
import '../../domain/models/calendar_event.dart';
import '../widgets/food_event_form.dart';

class EditEventDialog extends StatelessWidget {
  final CalendarEvent event;
  final Function(CalendarEvent) onSave;
  final VoidCallback onDelete;

  const EditEventDialog({
    super.key,
    required this.event,
    required this.onSave,
    required this.onDelete,
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

  Widget _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text('Edit Food Event'),
      automaticallyImplyLeading: false,
      actions: [
        IconButton(
          icon: const Icon(Icons.delete),
          onPressed: onDelete,
          tooltip: 'Delete event',
        ),
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
      selectedDate: event.startDate,
      onSave: onSave,
    );
  }
}
