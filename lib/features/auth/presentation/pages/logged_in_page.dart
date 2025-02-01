import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../data/services/auth_service.dart';
import 'package:michro_flutter/core/theme/app_theme.dart';

class LoggedInPage extends StatelessWidget {
  const LoggedInPage({super.key});

  @override
  Widget build(BuildContext context) {
    final token = AuthService().token;
    final tokenParts = token?.split('.') ?? [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Logged In'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await AuthService().logout();
              if (context.mounted) {
                context.go('/login');
              }
            },
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(
                Icons.check_circle_outline,
                color: Colors.green,
                size: 64,
              ),
              const SizedBox(height: 24),
              Text(
                'Successfully logged in!',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: AppTheme.primary[700],
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              if (tokenParts.length == 3) ...[
                const Text(
                  'JWT Token:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.gray[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTokenPart('Header', tokenParts[0]),
                      const Divider(),
                      _buildTokenPart('Payload', tokenParts[1]),
                      const Divider(),
                      _buildTokenPart('Signature', tokenParts[2]),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTokenPart(String title, String token) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          token,
          style: const TextStyle(
            fontFamily: 'monospace',
            fontSize: 12,
          ),
          softWrap: true,
        ),
      ],
    );
  }
}
