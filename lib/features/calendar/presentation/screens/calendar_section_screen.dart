import 'package:flutter/material.dart';
import '../../../navigation/presentation/widgets/calendar_top_nav_bar.dart';
import 'calendar_screen.dart';
import '../../../clock/presentation/screens/clock_screen.dart';
import '../../../nutrition/presentation/screens/nutrition_dashboard_screen.dart';

class CalendarSectionScreen extends StatefulWidget {
  const CalendarSectionScreen({super.key});

  @override
  State<CalendarSectionScreen> createState() => _CalendarSectionScreenState();
}

class _CalendarSectionScreenState extends State<CalendarSectionScreen> {
  int _selectedTopIndex = 0;

  static const List<Widget> _screens = [
    CalendarScreen(),
    ClockScreen(),
    NutritionDashboardScreen(),
  ];

  void _onTopDestinationSelected(int index) {
    setState(() {
      _selectedTopIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CalendarTopNavBar(
          selectedIndex: _selectedTopIndex,
          onDestinationSelected: _onTopDestinationSelected,
        ),
        Expanded(
          child: _buildCurrentScreen(),
        ),
      ],
    );
  }

  Widget _buildCurrentScreen() {
    return IndexedStack(
      index: _selectedTopIndex,
      children: _screens,
    );
  }
}
