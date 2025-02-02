enum RestrictionType {
  food('Food', 'Dietary restrictions and food allergies'),
  activity('Activity', 'Physical activity limitations'),
  medication('Medication', 'Medication-related restrictions'),
  lifestyle('Lifestyle', 'General lifestyle restrictions');

  final String label;
  final String description;

  const RestrictionType(this.label, this.description);

  factory RestrictionType.fromString(String value) {
    return RestrictionType.values.firstWhere(
      (type) => type.name == value,
      orElse: () => RestrictionType.food,
    );
  }
}

class Restriction {
  final String id;
  final String title;
  final String description;
  final RestrictionType type;
  final DateTime createdAt;
  final bool isActive;

  const Restriction({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.createdAt,
    this.isActive = true,
  });

  factory Restriction.fromJson(Map<String, dynamic> json) {
    return Restriction(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      type: RestrictionType.fromString(json['type'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      isActive: json['isActive'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'type': type.name,
      'createdAt': createdAt.toIso8601String(),
      'isActive': isActive,
    };
  }

  Restriction copyWith({
    String? id,
    String? title,
    String? description,
    RestrictionType? type,
    DateTime? createdAt,
    bool? isActive,
  }) {
    return Restriction(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      isActive: isActive ?? this.isActive,
    );
  }
}
