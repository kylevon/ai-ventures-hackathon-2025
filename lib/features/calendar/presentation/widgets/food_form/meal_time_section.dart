import 'package:flutter/material.dart';
import 'package:michro_flutter/features/shared/domain/models/event.dart';
import 'food_form_fields.dart';

class EventTypeTimeSection extends StatelessWidget {
  final EventType? selectedEventType;
  final TimeOfDay selectedTime;
  final TimeOfDay? selectedEndTime;
  final bool showEndTime;
  final Function(EventType?) onEventTypeChanged;
  final Function() onTimePressed;
  final Function() onEndTimePressed;

  const EventTypeTimeSection({
    super.key,
    required this.selectedEventType,
    required this.selectedTime,
    this.selectedEndTime,
    this.showEndTime = false,
    required this.onEventTypeChanged,
    required this.onTimePressed,
    required this.onEndTimePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _buildEventTypeDropdown()),
            const SizedBox(width: 16),
            Expanded(child: _buildTimeSelector(context)),
          ],
        ),
        if (showEndTime) ...[
          const SizedBox(height: 8),
          Row(
            children: [
              const Spacer(),
              const SizedBox(width: 16),
              Expanded(child: _buildEndTimeSelector(context)),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildEventTypeDropdown() {
    return DropdownButtonFormField<EventType>(
      value: selectedEventType,
      decoration: FoodFormFields.getInputDecoration('Event Type'),
      items: EventType.values
          .map((type) => DropdownMenuItem(
                value: type,
                child: Text(type.displayName),
              ))
          .toList(),
      onChanged: onEventTypeChanged,
      validator: (value) =>
          value == null ? 'Please select an event type' : null,
    );
  }

  Widget _buildTimeSelector(BuildContext context) {
    return InkWell(
      onTap: onTimePressed,
      child: InputDecorator(
        decoration: FoodFormFields.getInputDecoration('Start Time'),
        child: Text(selectedTime.format(context)),
      ),
    );
  }

  Widget _buildEndTimeSelector(BuildContext context) {
    return InkWell(
      onTap: onEndTimePressed,
      child: InputDecorator(
        decoration: FoodFormFields.getInputDecoration('End Time'),
        child: Text(selectedEndTime?.format(context) ?? 'Select End Time'),
      ),
    );
  }
}
