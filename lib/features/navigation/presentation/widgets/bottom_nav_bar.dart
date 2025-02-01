import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onDestinationSelected;

  const BottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      height: 65,
      selectedIndex: selectedIndex,
      onDestinationSelected: onDestinationSelected,
      destinations: _buildDestinations(),
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      elevation: 8,
      animationDuration: const Duration(milliseconds: 800),
      indicatorColor: Theme.of(context).colorScheme.primaryContainer,
    );
  }

  List<NavigationDestination> _buildDestinations() {
    return [
      _buildDestination(
        icon: Icons.calendar_month_outlined,
        selectedIcon: Icons.calendar_month,
        label: 'Calendar',
      ),
      _buildDestination(
        icon: Icons.add_circle_outline,
        selectedIcon: Icons.add_circle,
        label: 'Input',
      ),
      _buildDestination(
        icon: Icons.analytics_outlined,
        selectedIcon: Icons.analytics,
        label: 'Review',
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
