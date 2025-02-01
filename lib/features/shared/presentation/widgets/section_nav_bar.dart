import 'package:flutter/material.dart';

class TopNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onDestinationSelected;

  const TopNavBar({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
          ),
        ),
      ),
      child: TabBar(
        onTap: onDestinationSelected,
        tabs: [
          Tab(
            icon: Icon(selectedIndex == 0
                ? Icons.calendar_today
                : Icons.calendar_today_outlined),
            text: 'Calendar',
          ),
          Tab(
            icon: Icon(selectedIndex == 1
                ? Icons.access_time_filled
                : Icons.access_time_outlined),
            text: 'Clock',
          ),
          Tab(
            icon: Icon(selectedIndex == 2
                ? Icons.restaurant_menu
                : Icons.restaurant_menu_outlined),
            text: 'Nutrition',
          ),
        ],
      ),
    );
  }
}
