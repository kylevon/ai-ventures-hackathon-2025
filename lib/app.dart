import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'features/navigation/presentation/widgets/bottom_nav_bar.dart';
import 'features/home/presentation/pages/home_page.dart';
import 'features/input/presentation/pages/input_page.dart';
import 'features/connect/presentation/pages/connect_page.dart';
import 'features/review/presentation/pages/review_page.dart';
import 'features/restrictions/presentation/pages/restrictions_page.dart';

class App extends StatelessWidget {
  App({super.key});

  final _router = GoRouter(
    routes: [
      ShellRoute(
        builder: (context, state, child) {
          return Scaffold(
            body: child,
            bottomNavigationBar: BottomNavBar(
              location: state.uri.path,
            ),
          );
        },
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => const HomePage(),
          ),
          GoRoute(
            path: '/input',
            builder: (context, state) => const InputPage(),
          ),
          GoRoute(
            path: '/connect',
            builder: (context, state) => const ConnectPage(),
          ),
          GoRoute(
            path: '/review',
            builder: (context, state) => const ReviewPage(),
          ),
          GoRoute(
            path: '/restrictions',
            builder: (context, state) => const RestrictionsPage(),
          ),
        ],
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Health App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routerConfig: _router,
    );
  }
}
