/// 다가오는 상자 목록 응답
class UpcomingChests {
  final List<Chest> items;

  UpcomingChests({
    required this.items,
  });

  factory UpcomingChests.fromJson(Map<String, dynamic> json) {
    return UpcomingChests(
      items: json['items'] != null
          ? (json['items'] as List).map((e) => Chest.fromJson(e)).toList()
          : [],
    );
  }
}

/// 상자 정보
class Chest {
  final int index;
  final String name;

  Chest({
    required this.index,
    required this.name,
  });

  factory Chest.fromJson(Map<String, dynamic> json) {
    return Chest(
      index: json['index'] ?? 0,
      name: json['name'] ?? '',
    );
  }

  /// 상자까지 남은 개수
  String get remainingText => '$index번 후';
}
