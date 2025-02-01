import 'package:flutter/material.dart';
import '../../../calendar/presentation/pages/calendar_page.dart';
import '../../../clock/presentation/pages/clock_page.dart';
import '../../../nutrition_dashboard/presentation/pages/nutrition_dashboard_page.dart';
import '../widgets/top_navigation_bar.dart';

class DailyTrackingPage extends StatefulWidget {
  const DailyTrackingPage({super.key});

  @override
  State<DailyTrackingPage> createState() => _DailyTrackingPageState();
}

class _DailyTrackingPageState extends State<DailyTrackingPage>
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
    return SafeArea(
      child: Scaffold(
        appBar: TopNavigationBar(tabController: _tabController),
        body: TabBarView(
          controller: _tabController,
          children: const [
            CalendarPage(),
            ClockPage(),
            NutritionDashboardPage(),
          ],
        ),
      ),
    );
  }
}
