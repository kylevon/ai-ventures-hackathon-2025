import 'package:flutter/material.dart';
import 'package:michro_flutter/features/shared/domain/models/events/food_event.dart';
import 'package:michro_flutter/core/constants/event_types.dart';

class FoodInputDialog extends StatefulWidget {
  final DateTime selectedDate;
  final Function(FoodEvent) onSave;

  const FoodInputDialog({
    super.key,
    required this.selectedDate,
    required this.onSave,
  });

  @override
  State<FoodInputDialog> createState() => _FoodInputDialogState();
}

class _FoodInputDialogState extends State<FoodInputDialog> {
  final _foodNameController = TextEditingController();
  final _caloriesController = TextEditingController();
  final _notesController = TextEditingController();
  final _proteinController = TextEditingController();
  final _carbsController = TextEditingController();
  final _fatController = TextEditingController();
  DateTime _selectedTime = DateTime.now();
  String _mealType = 'breakfast';

  @override
  void dispose() {
    _foodNameController.dispose();
    _caloriesController.dispose();
    _notesController.dispose();
    _proteinController.dispose();
    _carbsController.dispose();
    _fatController.dispose();
    super.dispose();
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_selectedTime),
    );
    if (picked != null) {
      setState(() {
        _selectedTime = DateTime(
          widget.selectedDate.year,
          widget.selectedDate.month,
          widget.selectedDate.day,
          picked.hour,
          picked.minute,
        );
      });
    }
  }

  void _handleSave() {
    if (_foodNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a food name')),
      );
      return;
    }

    final calories = int.tryParse(_caloriesController.text);
    if (calories == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter valid calories')),
      );
      return;
    }

    final protein = double.tryParse(_proteinController.text);
    final carbs = double.tryParse(_carbsController.text);
    final fat = double.tryParse(_fatController.text);

    final event = FoodEvent(
      id: DateTime.now().toString(),
      title: _foodNameController.text,
      description: _notesController.text.isEmpty ? null : _notesController.text,
      date: _selectedTime,
      calories: calories,
      protein: protein,
      carbs: carbs,
      fat: fat,
      mealType: _mealType,
    );

    widget.onSave(event);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Food'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _foodNameController,
              decoration: const InputDecoration(
                labelText: 'Food Name',
                hintText: 'Enter food name',
              ),
              textCapitalization: TextCapitalization.sentences,
            ),
            TextField(
              controller: _caloriesController,
              decoration: const InputDecoration(
                labelText: 'Calories',
                hintText: 'Enter calories',
              ),
              keyboardType: TextInputType.number,
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _proteinController,
                    decoration: const InputDecoration(
                      labelText: 'Protein (g)',
                      hintText: 'Optional',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _carbsController,
                    decoration: const InputDecoration(
                      labelText: 'Carbs (g)',
                      hintText: 'Optional',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _fatController,
                    decoration: const InputDecoration(
                      labelText: 'Fat (g)',
                      hintText: 'Optional',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            DropdownButtonFormField<String>(
              value: _mealType,
              decoration: const InputDecoration(
                labelText: 'Meal Type',
              ),
              items: ['breakfast', 'lunch', 'dinner', 'snack'].map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(type[0].toUpperCase() + type.substring(1)),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _mealType = value;
                  });
                }
              },
            ),
            TextField(
              controller: _notesController,
              decoration: const InputDecoration(
                labelText: 'Notes (optional)',
                hintText: 'Enter additional notes',
              ),
              maxLines: 3,
            ),
            ListTile(
              title: const Text('Time'),
              subtitle: Text(
                '${_selectedTime.hour.toString().padLeft(2, '0')}:${_selectedTime.minute.toString().padLeft(2, '0')}',
              ),
              trailing: const Icon(Icons.access_time),
              onTap: () => _selectTime(context),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton.icon(
          onPressed: _handleSave,
          icon: const Icon(Icons.restaurant_menu),
          label: const Text('Save'),
        ),
      ],
    );
  }
}
