import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import '../../../shared/data/services/event_service.dart';
import '../../../shared/domain/models/events/food_event.dart';
import '../../../shared/data/services/ai_service.dart';

final inputControllerProvider = Provider<InputController>((ref) {
  return InputController();
});

class InputController {
  final _eventService = EventService();
  final _aiService = AIService();
  final _logger = Logger('InputController');

  Future<void> addFoodFromDescription(String description, DateTime date) async {
    try {
      _logger.info('Processing food description: $description');

      // Let AI analyze the food description and create a FoodEvent
      final foodEvent =
          await _aiService.analyzeFoodDescription(description, date);

      // Save the event
      await _eventService.addEvent(foodEvent);
      _logger.info('Successfully added food event from description');
    } catch (e, stackTrace) {
      _logger.severe('Error processing food description', e, stackTrace);
      rethrow;
    }
  }
}
