class NutrientData {
  final String name;
  final double currentValue;
  final double weeklyTarget;
  final String unit;

  const NutrientData({
    required this.name,
    required this.currentValue,
    required this.weeklyTarget,
    required this.unit,
  });

  double get percentageOfTarget => (currentValue / weeklyTarget) * 100;
  bool get isAboveTarget => currentValue >= weeklyTarget;
}
