class FoodItem {
  const FoodItem({
    required this.name,
    required this.weightInGrams,
    required this.defaultWeightInGrams,
  });

  final String name;
  final double weightInGrams;
  final double defaultWeightInGrams;

  FoodItem copyWith({
    String? name,
    double? weightInGrams,
    double? defaultWeightInGrams,
  }) {
    return FoodItem(
      name: name ?? this.name,
      weightInGrams: weightInGrams ?? this.weightInGrams,
      defaultWeightInGrams: defaultWeightInGrams ?? this.defaultWeightInGrams,
    );
  }
}
