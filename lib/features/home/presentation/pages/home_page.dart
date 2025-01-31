import 'package:flutter/material.dart';
import '../../../../core/responsive/responsive_layout.dart';
import '../../../../core/config/app_config.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobile: _HomeMobileLayout(),
      tablet: _HomeTabletLayout(),
      desktop: _HomeDesktopLayout(),
    );
  }
}

class _ConfigDisplay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final configItems = [
      {'API Base URL': AppConfig.apiBaseUrl},
      {'API Version': AppConfig.apiVersion},
      {'Login Endpoint': AppConfig.loginUrl},
      {'Register Endpoint': AppConfig.registerUrl},
      {'User Goals URL': AppConfig.userGoalsUrl},
      {'User Medications URL': AppConfig.userMedicationsUrl},
      {'User Restrictions URL': AppConfig.userRestrictionsUrl},
      {'Nutrition Data URL': AppConfig.nutritionDataUrl},
      {'Foods URL': AppConfig.foodsUrl},
      {'Food By ID URL (example)': AppConfig.getFoodByIdUrl('123')},
      {'Food Consumption URL': AppConfig.foodConsumptionUrl},
    ];

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Configuration Variables',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: configItems.length,
                itemBuilder: (context, index) {
                  final item = configItems[index];
                  final title = item.keys.first;
                  final value = item.values.first;
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: ListTile(
                      title: Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        value,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeMobileLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Michro Flutter Config'),
      ),
      body: _ConfigDisplay(),
    );
  }
}

class _HomeTabletLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Michro Flutter Config'),
      ),
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: 0,
            onDestinationSelected: (value) {},
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.settings),
                label: Text('Config'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.info),
                label: Text('About'),
              ),
            ],
          ),
          Expanded(
            child: _ConfigDisplay(),
          ),
        ],
      ),
    );
  }
}

class _HomeDesktopLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            extended: true,
            selectedIndex: 0,
            onDestinationSelected: (value) {},
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.settings),
                label: Text('Configuration'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.info),
                label: Text('About'),
              ),
            ],
          ),
          Expanded(
            child: _ConfigDisplay(),
          ),
        ],
      ),
    );
  }
} 