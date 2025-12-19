/// 카드 정보
class Card {
  final String name;
  final int id;
  final int maxLevel;
  final int? maxEvolutionLevel;
  final String? rarity;
  final int? elixirCost;
  final CardIconUrls? iconUrls;

  Card({
    required this.name,
    required this.id,
    required this.maxLevel,
    this.maxEvolutionLevel,
    this.rarity,
    this.elixirCost,
    this.iconUrls,
  });

  factory Card.fromJson(Map<String, dynamic> json) {
    return Card(
      name: json['name'] ?? '',
      id: json['id'] ?? 0,
      maxLevel: json['maxLevel'] ?? 14,
      maxEvolutionLevel: json['maxEvolutionLevel'],
      rarity: json['rarity'],
      elixirCost: json['elixirCost'],
      iconUrls: json['iconUrls'] != null
          ? CardIconUrls.fromJson(json['iconUrls'])
          : null,
    );
  }

  /// 희귀도 텍스트
  String get rarityText {
    switch (rarity?.toLowerCase()) {
      case 'common':
        return '일반';
      case 'rare':
        return '레어';
      case 'epic':
        return '에픽';
      case 'legendary':
        return '전설';
      case 'champion':
        return '챔피언';
      default:
        return rarity ?? '';
    }
  }
}

/// 카드 아이콘 URL
class CardIconUrls {
  final String? medium;
  final String? evolutionMedium;

  CardIconUrls({
    this.medium,
    this.evolutionMedium,
  });

  factory CardIconUrls.fromJson(Map<String, dynamic> json) {
    return CardIconUrls(
      medium: json['medium'],
      evolutionMedium: json['evolutionMedium'],
    );
  }
}

/// 카드 목록 응답
class CardsResponse {
  final List<Card> items;

  CardsResponse({required this.items});

  factory CardsResponse.fromJson(Map<String, dynamic> json) {
    return CardsResponse(
      items: json['items'] != null
          ? (json['items'] as List).map((e) => Card.fromJson(e)).toList()
          : [],
    );
  }
}
