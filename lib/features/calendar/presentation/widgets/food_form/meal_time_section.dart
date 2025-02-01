import 'package:flutter/material.dart';
import '../../../domain/models/calendar_event.dart';
import 'food_form_fields.dart';

class EventTypeTimeSection extends StatelessWidget {
  final EventType? selectedEventType;
  final TimeOfDay selectedTime;
  final Function(EventType?) onEventTypeChanged;
  final Function() onTimePressed;

  const EventTypeTimeSection({
    super.key,
    required this.selectedEventType,
    required this.selectedTime,
    required this.onEventTypeChanged,
    required this.onTimePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _buildEventTypeDropdown()),
        const SizedBox(width: 16),
        Expanded(child: _buildTimeSelector(context)),
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
        decoration: FoodFormFields.getInputDecoration('Time'),
        child: Text(selectedTime.format(context)),
      ),
    );
  }
}
