import 'package:flutter/material.dart';
import 'package:michro_flutter/core/theme/app_theme.dart';
import '../../../../features/shared/data/services/mock_server_service.dart';
import '../../../../features/shared/domain/models/event.dart';
import '../../../../core/constants/event_types.dart';

class ReviewScreen extends StatefulWidget {
  const ReviewScreen({super.key});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  final _scrollController = ScrollController();
  final _mockServer = MockServerService();
  List<Event> _events = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _loadEvents();
    _controller.forward();
  }

  Future<void> _loadEvents() async {
    final events = await _mockServer.get('/events');
    setState(() {
      _events = events;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Map<String, dynamic> _analyzeNutrition() {
    final nutritionEvents = _events.where((e) => e.type == EventType.food);
    final nutrientTotals = <String, double>{
      // Vitamins
      'vitaminA': 0,
      'vitaminD': 0,
      'vitaminE': 0,
      'vitaminK': 0,
      'vitaminC': 0,
      // B Vitamins
      'B1': 0,
      'B2': 0,
      'B3': 0,
      'B6': 0,
      'B12': 0,
      'folate': 0,
      // Minerals
      'iron': 0,
      'calcium': 0,
      'magnesium': 0,
      'zinc': 0,
      // Essential Fatty Acids
      'omega3': 0,
      'omega6': 0,
    };

    int mealCount = 0;
    for (final event in nutritionEvents) {
      final nutrients = event.metadata.get<Map<String, dynamic>>('nutrients');
      if (nutrients != null) {
        mealCount++;
        for (final entry in nutrients.entries) {
          if (nutrientTotals.containsKey(entry.key)) {
            final value = entry.value;
            if (value is num) {
              nutrientTotals[entry.key] =
                  (nutrientTotals[entry.key] ?? 0) + value.toDouble();
            }
          }
        }
      }
    }

    // Calculate daily averages
    if (mealCount > 0) {
      for (final key in nutrientTotals.keys) {
        nutrientTotals[key] = nutrientTotals[key]! / mealCount;
      }
    }

    // Define target ranges for each nutrient (daily recommended values from nutrition dashboard)
    final targetRanges = {
      'vitaminA': {'min': 800.0, 'max': 1000.0, 'unit': 'mcg'},
      'vitaminD': {'min': 20.0, 'max': 25.0, 'unit': 'mcg'},
      'vitaminE': {'min': 15.0, 'max': 20.0, 'unit': 'mg'},
      'vitaminK': {'min': 90.0, 'max': 120.0, 'unit': 'mcg'},
      'vitaminC': {'min': 70.0, 'max': 90.0, 'unit': 'mg'},
      'B1': {'min': 1.2, 'max': 1.5, 'unit': 'mg'},
      'B2': {'min': 1.2, 'max': 1.5, 'unit': 'mg'},
      'B3': {'min': 16.0, 'max': 20.0, 'unit': 'mg'},
      'B6': {'min': 1.8, 'max': 2.2, 'unit': 'mg'},
      'B12': {'min': 2.4, 'max': 3.0, 'unit': 'mcg'},
      'folate': {'min': 400.0, 'max': 500.0, 'unit': 'mcg'},
      'iron': {'min': 8.0, 'max': 11.0, 'unit': 'mg'},
      'calcium': {'min': 1000.0, 'max': 1300.0, 'unit': 'mg'},
      'magnesium': {'min': 350.0, 'max': 400.0, 'unit': 'mg'},
      'zinc': {'min': 11.0, 'max': 14.0, 'unit': 'mg'},
      'omega3': {'min': 1.1, 'max': 1.6, 'unit': 'g'},
      'omega6': {'min': 12.0, 'max': 17.0, 'unit': 'g'},
    };

    // Calculate percentage of target for each nutrient
    final nutrientPercentages = <String, Map<String, dynamic>>{};
    for (final entry in nutrientTotals.entries) {
      final target = targetRanges[entry.key]!;
      final minValue = target['min'] as double;
      final percentage = (entry.value / minValue) * 100;
      nutrientPercentages[entry.key] = {
        'percentage': percentage,
        'value': entry.value,
        'unit': target['unit'],
        'target': minValue,
      };
    }

    return nutrientPercentages;
  }

  double _calculateNutritionScore() {
    final nutrientData = _analyzeNutrition();
    double totalPercentage = 0;

    for (final entry in nutrientData.entries) {
      final percentage = entry.value['percentage'] as double;
      totalPercentage += percentage > 100 ? 100 : percentage;
    }

    return totalPercentage / nutrientData.length;
  }

  Map<String, dynamic> _analyzeExercise() {
    final exerciseEvents = _events.where((e) => e.type == EventType.exercise);
    int totalMinutes = 0;
    int totalSessions = exerciseEvents.length;

    for (final event in exerciseEvents) {
      totalMinutes += event.metadata.get<int>('duration') ?? 0;
    }

    return {
      'totalMinutes': totalMinutes,
      'totalSessions': totalSessions,
      'averageMinutes': totalSessions > 0 ? totalMinutes ~/ totalSessions : 0,
    };
  }

  double _calculateMedicationAdherence() {
    final medicationEvents = _events.where((e) => e.type == EventType.pills);
    final daysInMonth =
        DateTime(2025, 2, 0).day; // Gets number of days in January
    return (medicationEvents.length / daysInMonth) * 100;
  }

  List<String> _getHairGrowthRecommendations() {
    final nutrientData = _analyzeNutrition();
    final exercise = _analyzeExercise();
    final medicationAdherence = _calculateMedicationAdherence();

    final recommendations = <String>[];

    // Nutrition recommendations based on actual nutrient data
    final nutrientRecommendations = {
      'iron': '🥬 Increase iron intake with leafy greens and lean red meat',
      'zinc': '🥜 Add more zinc-rich foods like nuts, seeds, and lean meats',
      'B7': '🥑 Add biotin-rich foods like eggs, nuts, and avocados',
      'omega3': '🐟 Include more omega-3 sources like flaxseeds and walnuts',
      'vitaminD': '☀️ Consider getting more sunlight and vitamin D rich foods',
      'vitaminA': '🥕 Increase vitamin A with carrots and sweet potatoes',
    };

    // Add recommendations for nutrients below 70%
    for (final entry in nutrientData.entries) {
      final percentage = entry.value['percentage'] as double;
      if (percentage < 70 && nutrientRecommendations.containsKey(entry.key)) {
        recommendations.add(nutrientRecommendations[entry.key]!);
      }
    }

    // Exercise recommendations
    if (exercise['totalMinutes'] < 600) {
      // Less than 10 hours per month
      recommendations.add(
          '🏃‍♀️ Aim for more regular exercise to improve blood circulation to your scalp');
    }
    if (exercise['averageMinutes'] < 30) {
      recommendations.add(
          '⏱️ Try to extend your exercise sessions to at least 30 minutes for better blood flow');
    }

    // Medication adherence recommendations
    if (medicationAdherence < 90) {
      recommendations.add(
          '💊 Maintain consistent medication schedule for optimal results');
    }

    // Add stress-related recommendations if there are frequent symptoms
    final symptoms = _events.where((e) => e.type == EventType.symptoms);
    if (symptoms.length > 5) {
      recommendations.add(
          '🧘‍♀️ Consider stress-management techniques as stress can affect hair health');
    }

    return recommendations;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                'Hair Growth Journey',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Theme.of(context).primaryColor,
                      Theme.of(context).primaryColor.withOpacity(0.8),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Monthly Overview Card
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Monthly Overview',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            _buildOverviewMetric(
                              'Nutrition Score',
                              '${_calculateNutritionScore().round()}%',
                              Icons.restaurant,
                            ),
                            _buildOverviewMetric(
                              'Exercise Consistency',
                              '${(_analyzeExercise()['totalSessions'] / 30 * 100).round()}%',
                              Icons.fitness_center,
                            ),
                            _buildOverviewMetric(
                              'Medication Adherence',
                              '${_calculateMedicationAdherence().round()}%',
                              Icons.medical_services,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Recommendations Section
                    const Text(
                      'Recommendations for Better Results',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ..._getHairGrowthRecommendations().map(
                      (recommendation) => Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading: const Icon(Icons.tips_and_updates),
                          title: Text(recommendation),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewMetric(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Icon(icon, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                LinearProgressIndicator(
                  value: double.parse(value.replaceAll('%', '')) / 100,
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
