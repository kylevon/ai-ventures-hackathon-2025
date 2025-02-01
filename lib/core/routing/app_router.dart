import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
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
        builder: (context, state) => const AuthenticatedLayout(
          currentPath: '/calendar',
          child: CalendarPage(),
        ),
      ),
      GoRoute(
        path: '/input',
        builder: (context, state) => const AuthenticatedLayout(
          currentPath: '/input',
          child: InputPage(),
        ),
      ),
      GoRoute(
        path: '/review',
        builder: (context, state) => const AuthenticatedLayout(
          currentPath: '/review',
          child: ReviewPage(),
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
