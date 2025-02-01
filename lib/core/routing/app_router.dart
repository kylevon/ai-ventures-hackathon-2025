import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/auth/presentation/pages/logged_in_page.dart';
import '../../features/auth/data/services/auth_service.dart';
import '../../features/shared/presentation/layouts/authenticated_layout.dart';
import '../../features/calendar/presentation/pages/calendar_page.dart';
import '../../features/input/presentation/pages/input_page.dart';
import '../../features/review/presentation/pages/review_page.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/login',
    redirect: (context, state) {
      final isAuthenticated = AuthService().isAuthenticated;
      final isAuthRoute = state.matchedLocation == '/login' || 
                         state.matchedLocation == '/register';

      if (!isAuthenticated && !isAuthRoute) {
        return '/login';
      }
      if (isAuthenticated && isAuthRoute) {
        return '/input';
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: '/calendar',
        builder: (context, state) => AuthenticatedLayout(
          currentPath: '/calendar',
          child: const CalendarPage(),
        ),
      ),
      GoRoute(
        path: '/input',
        builder: (context, state) => AuthenticatedLayout(
          currentPath: '/input',
          child: const InputPage(),
        ),
      ),
      GoRoute(
        path: '/review',
        builder: (context, state) => AuthenticatedLayout(
          currentPath: '/review',
          child: const ReviewPage(),
        ),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text(
          'Error: ${state.error}',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
    ),
  );
} 