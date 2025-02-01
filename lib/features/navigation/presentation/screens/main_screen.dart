import 'package:flutter/material.dart';
import '../widgets/bottom_nav_bar.dart';
import '../../../input/presentation/screens/input_screen.dart';
import '../../../review/presentation/screens/review_screen.dart';
import '../../../shared/presentation/pages/daily_tracking_page.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _screens = [
    DailyTrackingPage(),
    InputScreen(),
    ReviewScreen(),
  ];

  void _onDestinationSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _buildCurrentScreen(),
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onDestinationSelected,
      ),
    );
  }

  Widget _buildCurrentScreen() {
    return IndexedStack(
      index: _selectedIndex,
      children: _screens,
    );
  }
}
