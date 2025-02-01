import 'package:flutter/material.dart';
import '../../domain/models/calendar_event.dart';

class EventTypeUtils {
  static IconData getEventTypeIcon(EventType type) {
    switch (type) {
      case EventType.medication:
        return Icons.medication;
      case EventType.meal:
        return Icons.restaurant;
      case EventType.exercise:
        return Icons.fitness_center;
      case EventType.sleep:
        return Icons.bedtime;
      case EventType.symptom:
        return Icons.healing;
      case EventType.measurement:
        return Icons.monitor_heart;
      case EventType.appointment:
        return Icons.calendar_today;
      case EventType.reminder:
        return Icons.notifications;
      case EventType.custom:
        return Icons.event;
    }
  }
}
