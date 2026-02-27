class RateMultiplier {
  final String name;
  final String description;
  final String category;
  final String multiplier;

  RateMultiplier({
    this.name = '',
    this.description = '',
    this.category = '',
    this.multiplier = '',
  });

  RateMultiplier copyWith({
    String? name,
    String? description,
    String? category,
    String? multiplier,
  }) {
    return RateMultiplier(
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      multiplier: multiplier ?? this.multiplier,
    );
  }
}
