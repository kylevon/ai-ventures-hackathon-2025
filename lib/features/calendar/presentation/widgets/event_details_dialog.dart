import 'package:flutter/material.dart';
import '../../domain/models/calendar_event.dart';
import '../../domain/models/food_event.dart';
import '../../data/services/mock_event_service.dart';
import 'food_event_form.dart';

class EventDetailsDialog extends StatefulWidget {
  final CalendarEvent event;
  final Future<void> Function() onDelete;
  final Future<void> Function(CalendarEvent) onUpdate;

  const EventDetailsDialog({
    super.key,
    required this.event,
    required this.onDelete,
    required this.onUpdate,
  });

  @override
  State<EventDetailsDialog> createState() => _EventDetailsDialogState();
}

class _EventDetailsDialogState extends State<EventDetailsDialog> {
  bool _isDeleting = false;
  bool _isSaving = false;

  Future<void> _handleDelete() async {
    setState(() => _isDeleting = true);
    try {
      await widget.onDelete();
    } finally {
      if (mounted) {
        setState(() => _isDeleting = false);
      }
    }
  }

  Future<void> _handleSave(CalendarEvent updatedEvent) async {
    setState(() => _isSaving = true);
    try {
      await widget.onUpdate(updatedEvent);
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Icon(Icons.event, color: widget.event.color),
          const SizedBox(width: 8),
          Expanded(child: Text(widget.event.title)),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.event.description != null) ...[
              const Text('Description:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text(widget.event.description!),
              const SizedBox(height: 16),
            ],
            Text('Time: ${widget.event.timeRange}'),
            const SizedBox(height: 8),
            Text('Type: ${widget.event.type.displayName}'),
            if (widget.event.location != null) ...[
              const SizedBox(height: 8),
              Text('Location: ${widget.event.location}'),
            ],
            _buildMetadataInfo(),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isDeleting ? null : () => _handleDelete(),
          child: const Text('Delete'),
        ),
        TextButton(
          onPressed: () => _handleEdit(context),
          child: const Text('Edit'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ],
    );
  }

  Widget _buildMetadataInfo() {
    if (widget.event.type == EventType.meal &&
        widget.event.metadata is FoodMetadata) {
      final foodMetadata = widget.event.metadata as FoodMetadata;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          const Text('Nutrition:',
              style: TextStyle(fontWeight: FontWeight.bold)),
          if (foodMetadata.calories != null)
            Text('Calories: ${foodMetadata.calories}'),
          if (foodMetadata.protein != null)
            Text('Protein: ${foodMetadata.protein}g'),
          if (foodMetadata.carbs != null) Text('Carbs: ${foodMetadata.carbs}g'),
          if (foodMetadata.fat != null) Text('Fat: ${foodMetadata.fat}g'),
          if (foodMetadata.ingredients.isNotEmpty) ...[
            const SizedBox(height: 8),
            const Text('Ingredients:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            Text(foodMetadata.ingredients.join(', ')),
          ],
        ],
      );
    }
    return const SizedBox.shrink();
  }

  Future<void> _handleEdit(BuildContext context) async {
    Navigator.of(context).pop(); // Close the details dialog

    if (!context.mounted) return;

    // Show edit form in a new dialog based on event type
    if (widget.event.type == EventType.meal) {
      final updatedEvent = await showDialog<CalendarEvent>(
        context: context,
        builder: (context) => Dialog(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: FoodEventForm(
                    event: widget.event,
                    selectedDate: widget.event.startDate,
                    onSave: (updatedEvent) async {
                      await _handleSave(updatedEvent);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      if (updatedEvent != null) {
        await _handleSave(updatedEvent);
      }
    } else {
      // TODO: Implement other event type forms
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Editing ${widget.event.type.displayName} events is not yet implemented'),
          ),
        );
      }
    }
  }
}
