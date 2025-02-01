import 'package:flutter/material.dart';
import '../../../calendar/presentation/pages/calendar_page.dart';
import '../../../clock/presentation/pages/clock_page.dart';
import '../../../nutrition_dashboard/presentation/pages/nutrition_dashboard_page.dart';

class FoodTrackingPage extends StatefulWidget {
  const FoodTrackingPage({super.key});

  @override
  State<FoodTrackingPage> createState() => _FoodTrackingPageState();
}

class _FoodTrackingPageState extends State<FoodTrackingPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: TabBarView(
        controller: _tabController,
        children: const [
          CalendarPage(),
          ClockPage(),
          NutritionDashboardPage(),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text('Food Tracking'),
      bottom: TabBar(
        controller: _tabController,
        tabs: const [
          Tab(icon: Icon(Icons.calendar_today), text: 'Calendar'),
          Tab(icon: Icon(Icons.access_time), text: 'Clock'),
          Tab(icon: Icon(Icons.bar_chart), text: 'Nutrition'),
        ],
      ),
    );
  }
}
