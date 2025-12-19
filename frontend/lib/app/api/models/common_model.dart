/// 위치/지역 정보
class Location {
  final int id;
  final String name;
  final String? localizedName;
  final bool isCountry;
  final String? countryCode;

  Location({
    required this.id,
    required this.name,
    this.localizedName,
    required this.isCountry,
    this.countryCode,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      localizedName: json['localizedName'],
      isCountry: json['isCountry'] ?? false,
      countryCode: json['countryCode'],
    );
  }
}

/// 아이콘 URL
class IconUrls {
  final String? medium;
  final String? evolutionMedium;

  IconUrls({
    this.medium,
    this.evolutionMedium,
  });

  factory IconUrls.fromJson(Map<String, dynamic> json) {
    return IconUrls(
      medium: json['medium'],
      evolutionMedium: json['evolutionMedium'],
    );
  }
}

/// 페이징 정보
class Paging {
  final Cursor? cursors;

  Paging({this.cursors});

  factory Paging.fromJson(Map<String, dynamic> json) {
    return Paging(
      cursors: json['cursors'] != null ? Cursor.fromJson(json['cursors']) : null,
    );
  }
}

/// 커서
class Cursor {
  final String? before;
  final String? after;

  Cursor({this.before, this.after});

  factory Cursor.fromJson(Map<String, dynamic> json) {
    return Cursor(
      before: json['before'],
      after: json['after'],
    );
  }
}

/// 페이징된 응답
class PaginatedResponse<T> {
  final List<T> items;
  final Paging? paging;

  PaginatedResponse({
    required this.items,
    this.paging,
  });
}
