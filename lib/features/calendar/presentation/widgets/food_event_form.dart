import 'package:flutter/material.dart';
import '../../domain/models/calendar_event.dart';
import '../../domain/models/food_event.dart';
import 'food_form/food_form_fields.dart';
import 'food_form/nutrition_fields.dart';
import 'food_form/ingredients_section.dart';
import 'food_form/meal_time_section.dart';
import 'food_form/food_form_layout.dart';

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

  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _caloriesController;
  late final TextEditingController _proteinController;
  late final TextEditingController _carbsController;
  late final TextEditingController _fatController;
  late final TextEditingController _ingredientController;
  late TimeOfDay _selectedTime;
  late TimeOfDay? _selectedEndTime;
  EventType? _selectedEventType;
  final List<String> _ingredients = [];

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  FoodMetadata? _getFoodMetadata(CalendarEvent? event) {
    if (event?.type != EventType.meal) return null;
    if (event?.metadata is! FoodMetadata) return null;
    return event?.metadata as FoodMetadata;
  }

  void _initializeControllers() {
    final event = widget.event;
    final metadata = _getFoodMetadata(event);

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
    _selectedEndTime = event?.endTime;
    _selectedEventType = event?.type ?? EventType.meal;

    if (metadata != null) {
      _ingredients.addAll(metadata.ingredients);
    }
  }

  @override
  void dispose() {
    _disposeControllers();
    super.dispose();
  }

  void _disposeControllers() {
    _titleController.dispose();
    _descriptionController.dispose();
    _caloriesController.dispose();
    _proteinController.dispose();
    _carbsController.dispose();
    _fatController.dispose();
    _ingredientController.dispose();
  }

  Future<void> _selectTime(BuildContext context,
      {bool isEndTime = false}) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime:
          isEndTime ? (_selectedEndTime ?? _selectedTime) : _selectedTime,
    );
    if (picked != null) {
      setState(() {
        if (isEndTime) {
          _selectedEndTime = picked;
        } else {
          _selectedTime = picked;
          if (_selectedEventType?.requiresDuration == true) {
            _selectedEndTime = TimeOfDay(
              hour: (picked.hour + 1) % 24,
              minute: picked.minute,
            );
          }
        }
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

  void _handleSave() {
    if (_formKey.currentState!.validate()) {
      widget.onSave(_createEvent());
    }
  }

  CalendarEvent _createEvent() {
    final metadata = FoodMetadata(
      calories: double.tryParse(_caloriesController.text),
      protein: double.tryParse(_proteinController.text),
      carbs: double.tryParse(_carbsController.text),
      fat: double.tryParse(_fatController.text),
      ingredients: _ingredients,
    );

    return CalendarEvent(
      id: widget.event?.id,
      title: _titleController.text,
      description: _descriptionController.text,
      startDate: widget.selectedDate,
      startTime: _selectedTime,
      endTime: _selectedEndTime,
      type: _selectedEventType ?? EventType.meal,
      metadata: metadata,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: FoodFormLayout(
        basicFields: _buildBasicFields(),
        eventTypeSection: EventTypeTimeSection(
          selectedEventType: _selectedEventType,
          selectedTime: _selectedTime,
          selectedEndTime: _selectedEndTime,
          showEndTime: _selectedEventType?.requiresDuration == true,
          onEventTypeChanged: (value) {
            setState(() {
              _selectedEventType = value;
              if (value?.requiresDuration == true) {
                _selectedEndTime = TimeOfDay(
                  hour: (_selectedTime.hour + 1) % 24,
                  minute: _selectedTime.minute,
                );
              } else {
                _selectedEndTime = null;
              }
            });
          },
          onTimePressed: () => _selectTime(context),
          onEndTimePressed: () => _selectTime(context, isEndTime: true),
        ),
        nutritionFields: NutritionFields(
          caloriesController: _caloriesController,
          proteinController: _proteinController,
          carbsController: _carbsController,
          fatController: _fatController,
        ),
        ingredientsSection: IngredientsSection(
          ingredientController: _ingredientController,
          ingredients: _ingredients,
          onAdd: _addIngredient,
          onRemove: (ingredient) =>
              setState(() => _ingredients.remove(ingredient)),
        ),
        onSave: _handleSave,
      ),
    );
  }

  Widget _buildBasicFields() {
    return Column(
      children: [
        TextFormField(
          controller: _titleController,
          decoration: FoodFormFields.getInputDecoration('Title'),
          validator: (value) => FoodFormFields.validateRequired(value, 'title'),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _descriptionController,
          decoration: FoodFormFields.getInputDecoration('Description'),
          maxLines: 2,
        ),
      ],
    );
  }
}
