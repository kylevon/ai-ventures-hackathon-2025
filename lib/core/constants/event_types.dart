import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

enum EventType {
  pills,
  exercise,
  sleep,
  food,
  liquids,
  period,
  bowelMovement,
  heartRate,
  appointments,
  mood,
  symptoms,
  misc;

  String get displayName {
    switch (this) {
      case EventType.pills:
        return 'Pills';
      case EventType.exercise:
        return 'Exercise';
      case EventType.sleep:
        return 'Sleep';
      case EventType.food:
        return 'Food';
      case EventType.liquids:
        return 'Liquids';
      case EventType.period:
        return 'Period';
      case EventType.bowelMovement:
        return 'Bowel Movement';
      case EventType.heartRate:
        return 'Heart Rate';
      case EventType.appointments:
        return 'Appointments';
      case EventType.mood:
        return 'Mood';
      case EventType.symptoms:
        return 'Symptoms';
      case EventType.misc:
        return 'Misc';
    }
  }

  Color get color {
    switch (this) {
      case EventType.pills:
        return AppTheme.pills[500]!;
      case EventType.exercise:
        return AppTheme.exercise[500]!;
      case EventType.sleep:
        return AppTheme.sleep[500]!;
      case EventType.food:
        return AppTheme.food[500]!;
      case EventType.liquids:
        return AppTheme.liquids[500]!;
      case EventType.period:
        return AppTheme.period[500]!;
      case EventType.bowelMovement:
        return AppTheme.bowelMovement[500]!;
      case EventType.heartRate:
        return AppTheme.heartRate[500]!;
      case EventType.appointments:
        return AppTheme.appointments[500]!;
      case EventType.mood:
        return AppTheme.mood[500]!;
      case EventType.symptoms:
        return AppTheme.symptoms[500]!;
      case EventType.misc:
        return AppTheme.misc[500]!;
    }
  }

  IconData get icon {
    switch (this) {
      case EventType.pills:
        return Icons.medication;
      case EventType.exercise:
        return Icons.fitness_center;
      case EventType.sleep:
        return Icons.bedtime;
      case EventType.food:
        return Icons.restaurant;
      case EventType.liquids:
        return Icons.local_drink;
      case EventType.period:
        return Icons.water_drop;
      case EventType.bowelMovement:
        return Icons.wc;
      case EventType.heartRate:
        return Icons.favorite;
      case EventType.appointments:
        return Icons.event;
      case EventType.mood:
        return Icons.emoji_emotions;
      case EventType.symptoms:
        return Icons.healing;
      case EventType.misc:
        return Icons.more_horiz;
    }
  }
}
