import 'package:flutter/material.dart';
import '../widgets/management_buttons/management_buttons_row.dart';
import '../widgets/circular_menu/circular_menu.dart';
import '../../../../core/theme/app_theme.dart';

class InputPage extends StatelessWidget {
  const InputPage({super.key});

  @override
  Widget build(BuildContext context) => _buildPage();

  Widget _buildPage() {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildBiowearableBar(),
            const ManagementButtonsRow(),
            const Expanded(
              child: CircularMenu(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBiowearableBar() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Material(
        elevation: 2,
        borderRadius: BorderRadius.circular(12),
        color: AppTheme.primary[100],
        child: InkWell(
          onTap: () {
            // TODO: Handle biowearable device addition
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.primary[300]!,
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.watch,
                  color: AppTheme.primary[700],
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Add a Biowearable Device',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.primary[700],
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: AppTheme.primary[400],
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
