import 'package:flutter/material.dart';
import '../../domain/models/calendar_event.dart';
import '../../domain/models/food_event.dart';

class FoodEventForm extends StatefulWidget {
  final CalendarEvent? event;
  final DateTime selectedDate;
  final Function(CalendarEvent event) onSave;

  const FoodEventForm({
    super.key,
    this.event,
    required this.selectedDate,
    required this.onSave,
  });

  @override
  State<FoodEventForm> createState() => _FoodEventFormState();
}

class _FoodEventFormState extends State<FoodEventForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _caloriesController;
  late TextEditingController _proteinController;
  late TextEditingController _carbsController;
  late TextEditingController _fatController;
  late TextEditingController _ingredientController;
  late TimeOfDay _selectedTime;
  String? _selectedMealType;
  final List<String> _ingredients = [];

  static const mealTypes = ['breakfast', 'lunch', 'dinner', 'snack'];

  @override
  void initState() {
    super.initState();
    final event = widget.event;
    final metadata = event?.metadata as FoodMetadata?;

    _titleController = TextEditingController(text: event?.title ?? '');
    _descriptionController =
        TextEditingController(text: event?.description ?? '');
    _caloriesController = TextEditingController(
      text: metadata?.calories?.toString() ?? '',
    );
    _proteinController = TextEditingController(
      text: metadata?.protein?.toString() ?? '',
    );
    _carbsController = TextEditingController(
      text: metadata?.carbs?.toString() ?? '',
    );
    _fatController = TextEditingController(
      text: metadata?.fat?.toString() ?? '',
    );
    _ingredientController = TextEditingController();
    _selectedTime = event?.startTime ?? TimeOfDay.now();
    _selectedMealType = metadata?.mealType;

    if (metadata != null) {
      _ingredients.addAll(metadata.ingredients);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _caloriesController.dispose();
    _proteinController.dispose();
    _carbsController.dispose();
    _fatController.dispose();
    _ingredientController.dispose();
    super.dispose();
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  void _addIngredient() {
    final ingredient = _ingredientController.text.trim();
    if (ingredient.isNotEmpty) {
      setState(() {
        _ingredients.add(ingredient);
        _ingredientController.clear();
      });
    }
  }

  void _removeIngredient(String ingredient) {
    setState(() {
      _ingredients.remove(ingredient);
    });
  }

  void _handleSave() {
    if (_formKey.currentState!.validate()) {
      final metadata = FoodMetadata(
        calories: double.tryParse(_caloriesController.text),
        protein: double.tryParse(_proteinController.text),
        carbs: double.tryParse(_carbsController.text),
        fat: double.tryParse(_fatController.text),
        ingredients: _ingredients,
        mealType: _selectedMealType,
      );

      final event = CalendarEvent(
        id: widget.event?.id,
        title: _titleController.text,
        description: _descriptionController.text,
        startDate: widget.selectedDate,
        startTime: _selectedTime,
        type: EventType.meal,
        metadata: metadata,
      );

      widget.onSave(event);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextFormField(
            controller: _titleController,
            decoration: const InputDecoration(
              labelText: 'Title',
              border: OutlineInputBorder(),
            ),
            validator: (value) =>
                value?.isEmpty == true ? 'Please enter a title' : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _descriptionController,
            decoration: const InputDecoration(
              labelText: 'Description',
              border: OutlineInputBorder(),
            ),
            maxLines: 2,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _selectedMealType,
                  decoration: const InputDecoration(
                    labelText: 'Meal Type',
                    border: OutlineInputBorder(),
                  ),
                  items: mealTypes
                      .map((type) => DropdownMenuItem(
                            value: type,
                            child: Text(
                              type[0].toUpperCase() + type.substring(1),
                            ),
                          ))
                      .toList(),
                  onChanged: (value) =>
                      setState(() => _selectedMealType = value),
                  validator: (value) =>
                      value == null ? 'Please select a meal type' : null,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: InkWell(
                  onTap: () => _selectTime(context),
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Time',
                      border: OutlineInputBorder(),
                    ),
                    child: Text(_selectedTime.format(context)),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _caloriesController,
                  decoration: const InputDecoration(
                    labelText: 'Calories',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextFormField(
                  controller: _proteinController,
                  decoration: const InputDecoration(
                    labelText: 'Protein (g)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _carbsController,
                  decoration: const InputDecoration(
                    labelText: 'Carbs (g)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextFormField(
                  controller: _fatController,
                  decoration: const InputDecoration(
                    labelText: 'Fat (g)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _ingredientController,
                  decoration: const InputDecoration(
                    labelText: 'Add Ingredient',
                    border: OutlineInputBorder(),
                  ),
                  onFieldSubmitted: (_) => _addIngredient(),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.add_circle),
                onPressed: _addIngredient,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _ingredients
                .map((ingredient) => Chip(
                      label: Text(ingredient),
                      onDeleted: () => _removeIngredient(ingredient),
                      deleteIcon: const Icon(Icons.cancel, size: 18),
                    ))
                .toList(),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _handleSave,
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
