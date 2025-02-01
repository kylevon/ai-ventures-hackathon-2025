import 'package:flutter/material.dart';
import '../../../auth/presentation/theme/auth_theme.dart';

class ReviewPage extends StatelessWidget {
  const ReviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        const SliverAppBar(
          title: Text('Review Progress'),
          floating: true,
        ),
        SliverFillRemaining(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.analytics_outlined,
                  size: 64,
                  color: AuthTheme.primary[500],
                ),
                const SizedBox(height: 16),
                const Text(
                  'Review Progress',
                  style: TextStyle(fontSize: 24),
                ),
                const SizedBox(height: 8),
                Text(
                  'Coming soon...',
                  style: TextStyle(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
