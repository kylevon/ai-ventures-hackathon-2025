import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/constants/event_types.dart';
import '../../domain/models/free_form_event.dart';

class InputChatPage extends ConsumerStatefulWidget {
  const InputChatPage({super.key});

  @override
  ConsumerState<InputChatPage> createState() => _InputChatPageState();
}

class _InputChatPageState extends ConsumerState<InputChatPage> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  EventType _selectedEventType = EventType.misc;

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (_controller.text.trim().isEmpty) return;

    final event = FreeFormEvent(
      id: const Uuid().v4(),
      description: _controller.text.trim(),
      timestamp: DateTime.now(),
      eventType: _selectedEventType,
    );
    // TODO: Add event submission logic here

    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildEventTypeSelector(),
            const Divider(height: 1),
            Expanded(
              child: Container(
                color: Theme.of(context).colorScheme.surface.withOpacity(0.5),
                child: ListView(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  children: const [
                    // TODO: Add chat messages here
                  ],
                ),
              ),
            ),
            _buildInputArea(),
          ],
        ),
      ),
    );
  }

  Widget _buildEventTypeSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        alignment: WrapAlignment.center,
        children: EventType.values.map((eventType) {
          final isSelected = _selectedEventType == eventType;
          return ActionChip(
            label: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  eventType.icon,
                  size: 18,
                  color: isSelected ? Colors.white : eventType.color,
                ),
                const SizedBox(width: 4),
                Text(
                  eventType.displayName,
                  style: TextStyle(
                    color: isSelected ? Colors.white : null,
                    fontWeight: isSelected ? FontWeight.bold : null,
                  ),
                ),
              ],
            ),
            backgroundColor:
                isSelected ? eventType.color : eventType.color.withOpacity(0.1),
            onPressed: () {
              setState(() {
                _selectedEventType = eventType;
              });
            },
          );
        }).toList(),
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              maxLines: null,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                hintText:
                    'Add ${_selectedEventType.displayName.toLowerCase()} entry...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Theme.of(context).colorScheme.surfaceVariant,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: _handleSubmit,
            icon: const Icon(Icons.send),
            style: IconButton.styleFrom(
              backgroundColor: _selectedEventType.color,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
