import 'package:flutter/material.dart';
import 'package:michro_flutter/features/shared/domain/models/event.dart';
import 'package:michro_flutter/features/shared/domain/utils/event_type_utils.dart';

class EventDetailsDialog extends StatefulWidget {
  final Event event;
  final Function(Event) onUpdate;
  final Function(String) onDelete;

  const EventDetailsDialog({
    super.key,
    required this.event,
    required this.onUpdate,
    required this.onDelete,
  });

  @override
  State<EventDetailsDialog> createState() => _EventDetailsDialogState();
}

class _EventDetailsDialogState extends State<EventDetailsDialog> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TimeOfDay? _startTime;
  late TimeOfDay? _endTime;
  late EventType _selectedType;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.event.title);
    _descriptionController =
        TextEditingController(text: widget.event.description ?? '');
    _startTime = widget.event.startTime;
    _endTime = widget.event.endTime;
    _selectedType = widget.event.type;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectTime(bool isStartTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isStartTime
          ? (_startTime ?? TimeOfDay.now())
          : (_endTime ?? TimeOfDay.now()),
    );
    if (picked != null) {
      setState(() {
        if (isStartTime) {
          _startTime = picked;
        } else {
          _endTime = picked;
        }
      });
    }
  }

  void _saveChanges() {
    final updatedEvent = widget.event.copyWith(
      title: _titleController.text,
      description: _descriptionController.text.isEmpty
          ? null
          : _descriptionController.text,
      startTime: _startTime,
      endTime: _endTime,
      type: _selectedType,
    );
    widget.onUpdate(updatedEvent);
    Navigator.of(context).pop();
  }

  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Event'),
        content: const Text('Are you sure you want to delete this event?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              widget.onDelete(widget.event.id);
              Navigator.of(context).pop();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _isEditing ? 'Edit Event' : 'Event Details',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Row(
                  children: [
                    if (!_isEditing)
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => setState(() => _isEditing = true),
                      ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: _confirmDelete,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (_isEditing) ...[
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<EventType>(
                value: _selectedType,
                decoration: const InputDecoration(
                  labelText: 'Event Type',
                  border: OutlineInputBorder(),
                ),
                items: EventType.values.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Row(
                      children: [
                        Icon(EventTypeUtils.getEventTypeIcon(type),
                            color: type.color),
                        const SizedBox(width: 8),
                        Text(type.displayName),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _selectedType = value);
                  }
                },
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.access_time),
                      label: Text(_startTime == null
                          ? 'Set Start Time'
                          : 'Start: ${_startTime!.format(context)}'),
                      onPressed: () => _selectTime(true),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.access_time),
                      label: Text(_endTime == null
                          ? 'Set End Time'
                          : 'End: ${_endTime!.format(context)}'),
                      onPressed: () => _selectTime(false),
                    ),
                  ),
                ],
              ),
            ] else ...[
              ListTile(
                leading: Icon(EventTypeUtils.getEventTypeIcon(_selectedType),
                    color: widget.event.color),
                title: Text(widget.event.title),
                subtitle: widget.event.description != null
                    ? Text(widget.event.description!)
                    : null,
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.access_time),
                title: Text(widget.event.timeRange),
              ),
            ],
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                if (_isEditing) ...[
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _saveChanges,
                    child: const Text('Save'),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
