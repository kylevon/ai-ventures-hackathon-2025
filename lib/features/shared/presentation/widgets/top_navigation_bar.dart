import 'package:flutter/material.dart';

class TopNavigationBar extends StatelessWidget implements PreferredSizeWidget {
  final TabController tabController;

  const TopNavigationBar({
    super.key,
    required this.tabController,
  });

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return AppBar(
      backgroundColor: Colors.grey[50],
      elevation: 0,
      toolbarHeight: 26,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(kTextTabBarHeight),
        child: TabBar(
          controller: tabController,
          labelColor: colorScheme.primary,
          unselectedLabelColor: Colors.grey[600],
          indicatorColor: colorScheme.primary,
          tabs: const [
            Tab(icon: Icon(Icons.calendar_today), text: 'Calendar'),
            Tab(icon: Icon(Icons.access_time), text: 'Clock'),
            Tab(icon: Icon(Icons.bar_chart), text: 'Nutrition'),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kTextTabBarHeight + 26);
}
