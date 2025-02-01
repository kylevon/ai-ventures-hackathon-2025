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
        color: Theme.of(context).primaryColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SafeArea(
        child: NavigationBar(
          height: 60,
          selectedIndex: selectedIndex,
          onDestinationSelected: onDestinationSelected,
          destinations: _buildDestinations(),
          backgroundColor: Colors.transparent,
          indicatorColor: Theme.of(context).primaryColor.withOpacity(0.2),
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        ),
      ),
    );
  }

  List<NavigationDestination> _buildDestinations() {
    return [
      _buildDestination(
        icon: Icons.calendar_today,
        selectedIcon: Icons.calendar_today,
        label: 'Calendar',
      ),
      _buildDestination(
        icon: Icons.access_time,
        selectedIcon: Icons.access_time_filled,
        label: 'Clock',
      ),
      _buildDestination(
        icon: Icons.restaurant_menu,
        selectedIcon: Icons.restaurant_menu,
        label: 'Nutrition',
      ),
    ];
  }

  NavigationDestination _buildDestination({
    required IconData icon,
    required IconData selectedIcon,
    required String label,
  }) {
    return NavigationDestination(
      icon: Icon(icon),
      selectedIcon: Icon(selectedIcon),
      label: label,
    );
  }
}
