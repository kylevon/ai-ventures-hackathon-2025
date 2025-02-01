import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'core/utils/logging.dart';
import 'core/theme/app_theme.dart';
import 'features/navigation/presentation/screens/main_screen.dart';
import 'features/input/presentation/screens/input_screen.dart';
import 'features/review/presentation/screens/review_screen.dart';
import 'features/shared/presentation/pages/daily_tracking_page.dart';

final _router = GoRouter(
  initialLocation: '/',
  routes: [
    ShellRoute(
      builder: (context, state, child) => MainScreen(child: child),
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const DailyTrackingPage(),
        ),
        GoRoute(
          path: '/input',
          builder: (context, state) => const InputScreen(),
        ),
        GoRoute(
          path: '/review',
          builder: (context, state) => const ReviewScreen(),
        ),
      ],
    ),
  ],
);

void main() {
  initializeLogging();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Michro',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      routerConfig: _router,
    );
  }
}
