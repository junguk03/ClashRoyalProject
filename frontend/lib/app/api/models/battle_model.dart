/// 배틀 기록 모델
class Battle {
  final String type;
  final String battleTime;
  final bool isLadderTournament;
  final Arena? arena;
  final GameMode? gameMode;
  final String? deckSelection;
  final List<BattlePlayer> team;
  final List<BattlePlayer> opponent;
  final int? challengeId;
  final String? challengeTitle;
  final int? challengeWinCountBefore;
  final bool? isHostedMatch;
  final String? leagueNumber;

  Battle({
    required this.type,
    required this.battleTime,
    required this.isLadderTournament,
    this.arena,
    this.gameMode,
    this.deckSelection,
    required this.team,
    required this.opponent,
    this.challengeId,
    this.challengeTitle,
    this.challengeWinCountBefore,
    this.isHostedMatch,
    this.leagueNumber,
  });

  factory Battle.fromJson(Map<String, dynamic> json) {
    return Battle(
      type: json['type'] ?? '',
      battleTime: json['battleTime'] ?? '',
      isLadderTournament: json['isLadderTournament'] ?? false,
      arena: json['arena'] != null ? Arena.fromJson(json['arena']) : null,
      gameMode: json['gameMode'] != null ? GameMode.fromJson(json['gameMode']) : null,
      deckSelection: json['deckSelection'],
      team: json['team'] != null
          ? (json['team'] as List).map((e) => BattlePlayer.fromJson(e)).toList()
          : [],
      opponent: json['opponent'] != null
          ? (json['opponent'] as List).map((e) => BattlePlayer.fromJson(e)).toList()
          : [],
      challengeId: json['challengeId'],
      challengeTitle: json['challengeTitle'],
      challengeWinCountBefore: json['challengeWinCountBefore'],
      isHostedMatch: json['isHostedMatch'],
      leagueNumber: json['leagueNumber']?.toString(),
    );
  }

  /// 승리 여부 (team의 crowns > opponent의 crowns)
  bool get isVictory {
    if (team.isEmpty || opponent.isEmpty) return false;
    return team.first.crowns > opponent.first.crowns;
  }

  /// 무승부 여부
  bool get isDraw {
    if (team.isEmpty || opponent.isEmpty) return false;
    return team.first.crowns == opponent.first.crowns;
  }

  /// 배틀 결과 텍스트
  String get resultText {
    if (isVictory) return '승리';
    if (isDraw) return '무승부';
    return '패배';
  }
}

/// 배틀 참가 플레이어
class BattlePlayer {
  final String tag;
  final String name;
  final int startingTrophies;
  final int trophyChange;
  final int crowns;
  final int kingTowerHitPoints;
  final List<int>? princessTowersHitPoints;
  final PlayerClan? clan;
  final List<BattleCard>? cards;
  final List<BattleCard>? supportCards;
  final int? elixirLeaked;
  final GlobalTournamentRankInfo? globalRank;

  BattlePlayer({
    required this.tag,
    required this.name,
    required this.startingTrophies,
    required this.trophyChange,
    required this.crowns,
    required this.kingTowerHitPoints,
    this.princessTowersHitPoints,
    this.clan,
    this.cards,
    this.supportCards,
    this.elixirLeaked,
    this.globalRank,
  });

  factory BattlePlayer.fromJson(Map<String, dynamic> json) {
    return BattlePlayer(
      tag: json['tag'] ?? '',
      name: json['name'] ?? '',
      startingTrophies: json['startingTrophies'] ?? 0,
      trophyChange: json['trophyChange'] ?? 0,
      crowns: json['crowns'] ?? 0,
      kingTowerHitPoints: json['kingTowerHitPoints'] ?? 0,
      princessTowersHitPoints: json['princessTowersHitPoints'] != null
          ? List<int>.from(json['princessTowersHitPoints'])
          : null,
      clan: json['clan'] != null ? PlayerClan.fromJson(json['clan']) : null,
      cards: json['cards'] != null
          ? (json['cards'] as List).map((e) => BattleCard.fromJson(e)).toList()
          : null,
      supportCards: json['supportCards'] != null
          ? (json['supportCards'] as List).map((e) => BattleCard.fromJson(e)).toList()
          : null,
      elixirLeaked: json['elixirLeaked'],
      globalRank: json['globalRank'] != null
          ? GlobalTournamentRankInfo.fromJson(json['globalRank'])
          : null,
    );
  }
}

/// 배틀에 사용된 카드
class BattleCard {
  final String name;
  final int id;
  final int level;
  final int? starLevel;
  final int maxLevel;
  final IconUrls? iconUrls;

  BattleCard({
    required this.name,
    required this.id,
    required this.level,
    this.starLevel,
    required this.maxLevel,
    this.iconUrls,
  });

  factory BattleCard.fromJson(Map<String, dynamic> json) {
    return BattleCard(
      name: json['name'] ?? '',
      id: json['id'] ?? 0,
      level: json['level'] ?? 0,
      starLevel: json['starLevel'],
      maxLevel: json['maxLevel'] ?? 14,
      iconUrls: json['iconUrls'] != null ? IconUrls.fromJson(json['iconUrls']) : null,
    );
  }
}

/// 아레나 정보
class Arena {
  final int id;
  final String name;

  Arena({
    required this.id,
    required this.name,
  });

  factory Arena.fromJson(Map<String, dynamic> json) {
    return Arena(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
    );
  }
}

/// 게임 모드
class GameMode {
  final int id;
  final String name;

  GameMode({
    required this.id,
    required this.name,
  });

  factory GameMode.fromJson(Map<String, dynamic> json) {
    return GameMode(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
    );
  }
}

/// 플레이어 클랜 정보
class PlayerClan {
  final String tag;
  final String name;
  final int? badgeId;

  PlayerClan({
    required this.tag,
    required this.name,
    this.badgeId,
  });

  factory PlayerClan.fromJson(Map<String, dynamic> json) {
    return PlayerClan(
      tag: json['tag'] ?? '',
      name: json['name'] ?? '',
      badgeId: json['badgeId'],
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

/// 글로벌 토너먼트 랭크 정보
class GlobalTournamentRankInfo {
  final int? rank;
  final int? trophies;

  GlobalTournamentRankInfo({
    this.rank,
    this.trophies,
  });

  factory GlobalTournamentRankInfo.fromJson(Map<String, dynamic> json) {
    return GlobalTournamentRankInfo(
      rank: json['rank'],
      trophies: json['trophies'],
    );
  }
}
