import 'common_model.dart';
import 'tournament_model.dart';

/// 간단한 위치 정보 (ClanRanking 등에서 사용)
class Location {
  final int id;
  final String name;
  final bool isCountry;
  final String? countryCode;

  Location({
    required this.id,
    required this.name,
    required this.isCountry,
    this.countryCode,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      isCountry: json['isCountry'] ?? false,
      countryCode: json['countryCode'],
    );
  }
}

/// 위치/지역 상세 정보
class LocationDetail {
  final int id;
  final String name;
  final String? localizedName;
  final bool isCountry;
  final String? countryCode;

  LocationDetail({
    required this.id,
    required this.name,
    this.localizedName,
    required this.isCountry,
    this.countryCode,
  });

  factory LocationDetail.fromJson(Map<String, dynamic> json) {
    return LocationDetail(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      localizedName: json['localizedName'],
      isCountry: json['isCountry'] ?? false,
      countryCode: json['countryCode'],
    );
  }
}

/// 위치 목록 응답
class LocationsResponse {
  final List<LocationDetail> items;
  final Paging? paging;

  LocationsResponse({
    required this.items,
    this.paging,
  });

  factory LocationsResponse.fromJson(Map<String, dynamic> json) {
    return LocationsResponse(
      items: json['items'] != null
          ? (json['items'] as List)
              .map((e) => LocationDetail.fromJson(e))
              .toList()
          : [],
      paging: json['paging'] != null ? Paging.fromJson(json['paging']) : null,
    );
  }
}

/// 플레이어 랭킹
class PlayerRanking {
  final String tag;
  final String name;
  final int rank;
  final int? previousRank;
  final int expLevel;
  final int trophies;
  final RankingClan? clan;
  final RankingArena? arena;

  PlayerRanking({
    required this.tag,
    required this.name,
    required this.rank,
    this.previousRank,
    required this.expLevel,
    required this.trophies,
    this.clan,
    this.arena,
  });

  factory PlayerRanking.fromJson(Map<String, dynamic> json) {
    return PlayerRanking(
      tag: json['tag'] ?? '',
      name: json['name'] ?? '',
      rank: json['rank'] ?? 0,
      previousRank: json['previousRank'],
      expLevel: json['expLevel'] ?? 0,
      trophies: json['trophies'] ?? 0,
      clan: json['clan'] != null ? RankingClan.fromJson(json['clan']) : null,
      arena: json['arena'] != null ? RankingArena.fromJson(json['arena']) : null,
    );
  }

  /// 순위 변화
  int? get rankChange {
    if (previousRank == null) return null;
    return previousRank! - rank;
  }

  /// 순위 변화 텍스트
  String get rankChangeText {
    final change = rankChange;
    if (change == null) return '-';
    if (change > 0) return '+$change';
    if (change < 0) return '$change';
    return '=';
  }
}

/// 랭킹용 클랜 정보
class RankingClan {
  final String tag;
  final String name;
  final int? badgeId;

  RankingClan({
    required this.tag,
    required this.name,
    this.badgeId,
  });

  factory RankingClan.fromJson(Map<String, dynamic> json) {
    return RankingClan(
      tag: json['tag'] ?? '',
      name: json['name'] ?? '',
      badgeId: json['badgeId'],
    );
  }
}

/// 랭킹용 아레나 정보
class RankingArena {
  final int id;
  final String name;

  RankingArena({
    required this.id,
    required this.name,
  });

  factory RankingArena.fromJson(Map<String, dynamic> json) {
    return RankingArena(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
    );
  }
}

/// 플레이어 랭킹 응답
class PlayerRankingsResponse {
  final List<PlayerRanking> items;
  final Paging? paging;

  PlayerRankingsResponse({
    required this.items,
    this.paging,
  });

  factory PlayerRankingsResponse.fromJson(Map<String, dynamic> json) {
    return PlayerRankingsResponse(
      items: json['items'] != null
          ? (json['items'] as List)
              .map((e) => PlayerRanking.fromJson(e))
              .toList()
          : [],
      paging: json['paging'] != null ? Paging.fromJson(json['paging']) : null,
    );
  }
}

/// 클랜 랭킹
class ClanRanking {
  final String tag;
  final String name;
  final int rank;
  final int? previousRank;
  final int clanScore;
  final int members;
  final int? badgeId;
  final Location? location;

  ClanRanking({
    required this.tag,
    required this.name,
    required this.rank,
    this.previousRank,
    required this.clanScore,
    required this.members,
    this.badgeId,
    this.location,
  });

  factory ClanRanking.fromJson(Map<String, dynamic> json) {
    return ClanRanking(
      tag: json['tag'] ?? '',
      name: json['name'] ?? '',
      rank: json['rank'] ?? 0,
      previousRank: json['previousRank'],
      clanScore: json['clanScore'] ?? 0,
      members: json['members'] ?? 0,
      badgeId: json['badgeId'],
      location:
          json['location'] != null ? Location.fromJson(json['location']) : null,
    );
  }

  /// 순위 변화
  int? get rankChange {
    if (previousRank == null) return null;
    return previousRank! - rank;
  }
}

/// 클랜 랭킹 응답
class ClanRankingsResponse {
  final List<ClanRanking> items;
  final Paging? paging;

  ClanRankingsResponse({
    required this.items,
    this.paging,
  });

  factory ClanRankingsResponse.fromJson(Map<String, dynamic> json) {
    return ClanRankingsResponse(
      items: json['items'] != null
          ? (json['items'] as List)
              .map((e) => ClanRanking.fromJson(e))
              .toList()
          : [],
      paging: json['paging'] != null ? Paging.fromJson(json['paging']) : null,
    );
  }
}

/// 클랜 전쟁 랭킹
class ClanWarRanking {
  final String tag;
  final String name;
  final int rank;
  final int? previousRank;
  final int clanScore;
  final int members;
  final int? badgeId;
  final Location? location;

  ClanWarRanking({
    required this.tag,
    required this.name,
    required this.rank,
    this.previousRank,
    required this.clanScore,
    required this.members,
    this.badgeId,
    this.location,
  });

  factory ClanWarRanking.fromJson(Map<String, dynamic> json) {
    return ClanWarRanking(
      tag: json['tag'] ?? '',
      name: json['name'] ?? '',
      rank: json['rank'] ?? 0,
      previousRank: json['previousRank'],
      clanScore: json['clanScore'] ?? 0,
      members: json['members'] ?? 0,
      badgeId: json['badgeId'],
      location:
          json['location'] != null ? Location.fromJson(json['location']) : null,
    );
  }
}

/// 클랜 전쟁 랭킹 응답
class ClanWarRankingsResponse {
  final List<ClanWarRanking> items;
  final Paging? paging;

  ClanWarRankingsResponse({
    required this.items,
    this.paging,
  });

  factory ClanWarRankingsResponse.fromJson(Map<String, dynamic> json) {
    return ClanWarRankingsResponse(
      items: json['items'] != null
          ? (json['items'] as List)
              .map((e) => ClanWarRanking.fromJson(e))
              .toList()
          : [],
      paging: json['paging'] != null ? Paging.fromJson(json['paging']) : null,
    );
  }
}

/// 시즌 정보
class Season {
  final String id;

  Season({required this.id});

  factory Season.fromJson(Map<String, dynamic> json) {
    return Season(
      id: json['id'] ?? '',
    );
  }
}

/// 시즌 목록 응답
class SeasonsResponse {
  final List<Season> items;
  final Paging? paging;

  SeasonsResponse({
    required this.items,
    this.paging,
  });

  factory SeasonsResponse.fromJson(Map<String, dynamic> json) {
    return SeasonsResponse(
      items: json['items'] != null
          ? (json['items'] as List).map((e) => Season.fromJson(e)).toList()
          : [],
      paging: json['paging'] != null ? Paging.fromJson(json['paging']) : null,
    );
  }
}

/// Path of Legend 랭킹
class PathOfLegendRanking {
  final String tag;
  final String name;
  final int rank;
  final int? previousRank;
  final int expLevel;
  final int trophies;
  final int? eloRating;
  final RankingClan? clan;

  PathOfLegendRanking({
    required this.tag,
    required this.name,
    required this.rank,
    this.previousRank,
    required this.expLevel,
    required this.trophies,
    this.eloRating,
    this.clan,
  });

  factory PathOfLegendRanking.fromJson(Map<String, dynamic> json) {
    return PathOfLegendRanking(
      tag: json['tag'] ?? '',
      name: json['name'] ?? '',
      rank: json['rank'] ?? 0,
      previousRank: json['previousRank'],
      expLevel: json['expLevel'] ?? 0,
      trophies: json['trophies'] ?? 0,
      eloRating: json['eloRating'],
      clan: json['clan'] != null ? RankingClan.fromJson(json['clan']) : null,
    );
  }
}

/// Path of Legend 랭킹 응답
class PathOfLegendRankingsResponse {
  final List<PathOfLegendRanking> items;
  final Paging? paging;

  PathOfLegendRankingsResponse({
    required this.items,
    this.paging,
  });

  factory PathOfLegendRankingsResponse.fromJson(Map<String, dynamic> json) {
    return PathOfLegendRankingsResponse(
      items: json['items'] != null
          ? (json['items'] as List)
              .map((e) => PathOfLegendRanking.fromJson(e))
              .toList()
          : [],
      paging: json['paging'] != null ? Paging.fromJson(json['paging']) : null,
    );
  }
}

/// 글로벌 토너먼트 랭킹 응답
class GlobalTournamentRankingsResponse {
  final List<LadderTournamentRanking> items;
  final Paging? paging;

  GlobalTournamentRankingsResponse({
    required this.items,
    this.paging,
  });

  factory GlobalTournamentRankingsResponse.fromJson(Map<String, dynamic> json) {
    return GlobalTournamentRankingsResponse(
      items: json['items'] != null
          ? (json['items'] as List)
              .map((e) => LadderTournamentRanking.fromJson(e))
              .toList()
          : [],
      paging: json['paging'] != null ? Paging.fromJson(json['paging']) : null,
    );
  }
}
