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
  static const mealTypes = ['breakfast', 'lunch', 'dinner', 'snack'];

  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _caloriesController;
  late final TextEditingController _proteinController;
  late final TextEditingController _carbsController;
  late final TextEditingController _fatController;
  late final TextEditingController _ingredientController;
  late TimeOfDay _selectedTime;
  String? _selectedMealType;
  final List<String> _ingredients = [];

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
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

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() => _selectedTime = picked);
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
      mealType: _selectedMealType,
    );

    return CalendarEvent(
      id: widget.event?.id,
      title: _titleController.text,
      description: _descriptionController.text,
      startDate: widget.selectedDate,
      startTime: _selectedTime,
      type: EventType.meal,
      metadata: metadata,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: FoodFormLayout(
        basicFields: _buildBasicFields(),
        mealTimeSection: MealTimeSection(
          selectedMealType: _selectedMealType,
          selectedTime: _selectedTime,
          mealTypes: mealTypes,
          onMealTypeChanged: (value) =>
              setState(() => _selectedMealType = value),
          onTimePressed: () => _selectTime(context),
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
