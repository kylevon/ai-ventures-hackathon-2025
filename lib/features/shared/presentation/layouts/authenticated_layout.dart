import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:michro_flutter/core/theme/app_theme.dart';

class AuthenticatedLayout extends StatelessWidget {
  final Widget child;
  final String currentPath;

  const AuthenticatedLayout({
    super.key,
    required this.child,
    required this.currentPath,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _getCurrentIndex(),
          onTap: (index) => _onItemTapped(context, index),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today),
              label: 'Calendar',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_circle_outline, size: 32),
              label: 'Input',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.analytics),
              label: 'Review',
            ),
          ],
          selectedItemColor: AppTheme.primary[500],
          unselectedItemColor: AppTheme.gray[400],
          showUnselectedLabels: true,
        ),
      ),
    );
  }

  int _getCurrentIndex() {
    switch (currentPath) {
      case '/calendar':
        return 0;
      case '/input':
        return 1;
      case '/review':
        return 2;
      default:
        return 1; // Default to input
    }
  }

  void _onItemTapped(BuildContext context, int index) {
    String path;
    switch (index) {
      case 0:
        path = '/calendar';
        break;
      case 1:
        path = '/input';
        break;
      case 2:
        path = '/review';
        break;
      default:
        path = '/input';
    }

    if (path != currentPath) {
      context.go(path);
    }
  }
}
