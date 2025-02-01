import 'package:flutter/material.dart';
import 'package:michro_flutter/features/shared/domain/models/event.dart';
import 'package:michro_flutter/features/shared/domain/utils/event_type_utils.dart';
import '../dialogs/edit_event_dialog.dart';

class EventDetailsDialog extends StatelessWidget {
  final Event event;
  final VoidCallback onDelete;
  final Future<void> Function(Event) onUpdate;

  const EventDetailsDialog({
    super.key,
    required this.event,
    required this.onDelete,
    required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Icon(
            EventTypeUtils.getEventTypeIcon(event.type),
            color: event.color,
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(event.title)),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (event.description != null) ...[
            Text(event.description!),
            const SizedBox(height: 16),
          ],
          _buildInfoRow(Icons.access_time, event.timeRange),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () async {
            Navigator.of(context).pop();
            onDelete();
          },
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

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Text(text),
      ],
    );
  }

  Future<void> _handleEdit(BuildContext context) async {
    final updatedEvent = await showDialog<Event>(
      context: context,
      builder: (context) => EditEventDialog(
        event: event,
        onSave: (event) => Navigator.of(context).pop(event),
      ),
    );

    if (updatedEvent != null) {
      Navigator.of(context).pop();
      await onUpdate(updatedEvent);
    }
  }
}
