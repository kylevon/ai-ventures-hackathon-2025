import 'package:flutter/material.dart';
import '../../../auth/presentation/theme/auth_theme.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarStyleConfig {
  static CalendarStyle get calendarStyle => CalendarStyle(
        markersMaxCount: 3,
        markerDecoration: BoxDecoration(
          color: AuthTheme.primary[500],
          shape: BoxShape.circle,
        ),
        selectedDecoration: BoxDecoration(
          color: AuthTheme.primary[500],
          shape: BoxShape.circle,
        ),
        todayDecoration: BoxDecoration(
          color: AuthTheme.primary[500]!.withOpacity(0.5),
          shape: BoxShape.circle,
        ),
        weekendTextStyle: TextStyle(color: Colors.grey[600]),
        outsideTextStyle: TextStyle(color: Colors.grey[400]),
        markerSize: 6,
        markersAnchor: 1.5,
      );

  static HeaderStyle get headerStyle => HeaderStyle(
        titleCentered: true,
        formatButtonVisible: true,
        formatButtonDecoration: BoxDecoration(
          color: AuthTheme.primary[500]!.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        formatButtonTextStyle: TextStyle(color: AuthTheme.primary[500]),
        formatButtonShowsNext: false,
        leftChevronIcon:
            Icon(Icons.chevron_left, color: AuthTheme.primary[500]),
        rightChevronIcon:
            Icon(Icons.chevron_right, color: AuthTheme.primary[500]),
      );

  static DaysOfWeekStyle get daysOfWeekStyle => DaysOfWeekStyle(
        weekdayStyle: const TextStyle(fontWeight: FontWeight.bold),
        weekendStyle: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.grey[600],
        ),
      );
}
