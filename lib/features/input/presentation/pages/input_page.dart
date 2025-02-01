import 'package:flutter/material.dart';
import '../widgets/management_buttons/management_buttons_row.dart';
import '../widgets/circular_menu/circular_menu.dart';

class InputPage extends StatelessWidget {
  const InputPage({super.key});

  @override
  Widget build(BuildContext context) => _buildPage();

  Widget _buildPage() {
    return const CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: ManagementButtonsRow(),
        ),
        SliverFillRemaining(
          child: CircularMenu(),
        ),
      ],
    );
  }
}
