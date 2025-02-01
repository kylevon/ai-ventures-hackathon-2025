import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/bottom_nav_bar.dart';

class MainScreen extends StatefulWidget {
  final Widget child;

  const MainScreen({
    super.key,
    required this.child,
  });

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _getSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.path;
    switch (location) {
      case '/':
        return 0;
      case '/input':
        return 1;
      case '/review':
        return 2;
      default:
        return 0;
    }
  }

  void _onDestinationSelected(int index) {
    switch (index) {
      case 0:
        context.go('/');
        break;
      case 1:
        context.go('/input');
        break;
      case 2:
        context.go('/review');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _getSelectedIndex(context),
        onDestinationSelected: _onDestinationSelected,
      ),
    );
  }
}
