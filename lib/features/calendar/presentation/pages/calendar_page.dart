import 'package:flutter/material.dart';
import '../widgets/calendar_widget.dart';
import '../../domain/models/calendar_event.dart';
import '../../data/services/mock_food_service.dart';
import '../../domain/models/food_event.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  final _foodService = MockFoodService();
  List<CalendarEvent> _events = [];

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  Future<void> _loadEvents() async {
    await _foodService.init();
    if (mounted) {
      setState(() {
        _events = _foodService.getAllEvents();
      });
      print('Calendar page initialized with ${_events.length} events');
    }
  }

  void _handleDaySelected(DateTime selectedDay) {
    // No longer showing nutritional summary
  }

  void _handleEventTap(CalendarEvent event) {
    final foodMetadata = event.metadata as FoodMetadata;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(event.title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (event.description != null) ...[
              Text(event.description!),
              const SizedBox(height: 8),
            ],
            Text('Time: ${event.timeRange}'),
            const SizedBox(height: 8),
            Text('Meal Type: ${foodMetadata.mealType}'),
            const SizedBox(height: 8),
            Text('Calories: ${foodMetadata.calories?.toStringAsFixed(0)} cal'),
            Text('Protein: ${foodMetadata.protein?.toStringAsFixed(1)}g'),
            Text('Carbs: ${foodMetadata.carbs?.toStringAsFixed(1)}g'),
            Text('Fat: ${foodMetadata.fat?.toStringAsFixed(1)}g'),
            const SizedBox(height: 8),
            const Text('Ingredients:'),
            ...foodMetadata.ingredients.map((ingredient) => Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Text('• $ingredient'),
                )),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
          TextButton(
            onPressed: () {
              // TODO: Implement edit functionality
              Navigator.of(context).pop();
            },
            child: const Text('Edit'),
          ),
        ],
      ),
    );
  }

  void _handleAddEvent(DateTime selectedDay) {
    // TODO: Implement add event functionality
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Food Event'),
        content: const Text('Food event creation coming soon...'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print('Building calendar with ${_events.length} events');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Food Calendar'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _events = _foodService.getAllEvents();
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // TODO: Implement filter functionality
            },
          ),
        ],
      ),
      body: CalendarWidget(
        events: _events,
        onDaySelected: _handleDaySelected,
        onEventTap: _handleEventTap,
        onAddEvent: _handleAddEvent,
      ),
    );
  }
}
