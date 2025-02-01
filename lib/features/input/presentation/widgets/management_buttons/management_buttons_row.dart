import 'package:flutter/material.dart';
import 'package:michro_flutter/core/theme/app_theme.dart';
import 'management_button.dart';

class ManagementButtonsRow extends StatelessWidget {
  const ManagementButtonsRow({super.key});

  @override
  Widget build(BuildContext context) => _buildButtonsRow(context);

  Widget _buildButtonsRow(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildRemindersButton(context),
          _buildGoalsButton(context),
          _buildRestrictionsButton(context),
        ],
      ),
    );
  }

  Widget _buildRemindersButton(BuildContext context) {
    return ManagementButton(
      icon: Icons.notifications_active,
      label: 'Reminders',
      color: AppTheme.primary[300]!,
      onTap: () => _showComingSoonSnackBar(context, 'Reminders'),
    );
  }

  Widget _buildGoalsButton(BuildContext context) {
    return ManagementButton(
      icon: Icons.track_changes,
      label: 'Goals',
      color: AppTheme.primary[400]!,
      onTap: () => _showComingSoonSnackBar(context, 'Goals'),
    );
  }

  Widget _buildRestrictionsButton(BuildContext context) {
    return ManagementButton(
      icon: Icons.block,
      label: 'Restrictions',
      color: AppTheme.primary[500]!,
      onTap: () => _showComingSoonSnackBar(context, 'Restrictions'),
    );
  }

  void _showComingSoonSnackBar(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature management coming soon'),
        duration: const Duration(seconds: 1),
      ),
    );
  }
}
