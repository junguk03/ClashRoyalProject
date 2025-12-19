/// 플레이어 정보 모델
class Player {
  final String tag;
  final String name;
  final int expLevel;
  final int trophies;
  final int bestTrophies;
  final int wins;
  final int losses;
  final int battleCount;
  final int threeCrownWins;
  final int challengeCardsWon;
  final int challengeMaxWins;
  final int tournamentCardsWon;
  final int tournamentBattleCount;
  final int donations;
  final int donationsReceived;
  final int totalDonations;
  final int warDayWins;
  final int clanCardsCollected;
  final int starPoints;
  final int expPoints;
  final int totalExpPoints;
  final int? legacyTrophyRoadHighScore;
  final PlayerClan? clan;
  final Arena? arena;
  final String? role;
  final List<PlayerCard>? currentDeck;
  final List<PlayerCard>? cards;
  final Item? currentFavouriteCard;
  final List<PlayerBadge>? badges;
  final List<PlayerAchievement>? achievements;
  final PlayerLeagueStatistics? leagueStatistics;
  final PathOfLegendSeasonResult? currentPathOfLegendSeasonResult;
  final PathOfLegendSeasonResult? lastPathOfLegendSeasonResult;
  final PathOfLegendSeasonResult? bestPathOfLegendSeasonResult;

  Player({
    required this.tag,
    required this.name,
    required this.expLevel,
    required this.trophies,
    required this.bestTrophies,
    required this.wins,
    required this.losses,
    required this.battleCount,
    required this.threeCrownWins,
    required this.challengeCardsWon,
    required this.challengeMaxWins,
    required this.tournamentCardsWon,
    required this.tournamentBattleCount,
    required this.donations,
    required this.donationsReceived,
    required this.totalDonations,
    required this.warDayWins,
    required this.clanCardsCollected,
    required this.starPoints,
    required this.expPoints,
    required this.totalExpPoints,
    this.legacyTrophyRoadHighScore,
    this.clan,
    this.arena,
    this.role,
    this.currentDeck,
    this.cards,
    this.currentFavouriteCard,
    this.badges,
    this.achievements,
    this.leagueStatistics,
    this.currentPathOfLegendSeasonResult,
    this.lastPathOfLegendSeasonResult,
    this.bestPathOfLegendSeasonResult,
  });

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      tag: json['tag'] ?? '',
      name: json['name'] ?? '',
      expLevel: json['expLevel'] ?? 0,
      trophies: json['trophies'] ?? 0,
      bestTrophies: json['bestTrophies'] ?? 0,
      wins: json['wins'] ?? 0,
      losses: json['losses'] ?? 0,
      battleCount: json['battleCount'] ?? 0,
      threeCrownWins: json['threeCrownWins'] ?? 0,
      challengeCardsWon: json['challengeCardsWon'] ?? 0,
      challengeMaxWins: json['challengeMaxWins'] ?? 0,
      tournamentCardsWon: json['tournamentCardsWon'] ?? 0,
      tournamentBattleCount: json['tournamentBattleCount'] ?? 0,
      donations: json['donations'] ?? 0,
      donationsReceived: json['donationsReceived'] ?? 0,
      totalDonations: json['totalDonations'] ?? 0,
      warDayWins: json['warDayWins'] ?? 0,
      clanCardsCollected: json['clanCardsCollected'] ?? 0,
      starPoints: json['starPoints'] ?? 0,
      expPoints: json['expPoints'] ?? 0,
      totalExpPoints: json['totalExpPoints'] ?? 0,
      legacyTrophyRoadHighScore: json['legacyTrophyRoadHighScore'],
      clan: json['clan'] != null ? PlayerClan.fromJson(json['clan']) : null,
      arena: json['arena'] != null ? Arena.fromJson(json['arena']) : null,
      role: json['role'],
      currentDeck: json['currentDeck'] != null
          ? (json['currentDeck'] as List)
              .map((e) => PlayerCard.fromJson(e))
              .toList()
          : null,
      cards: json['cards'] != null
          ? (json['cards'] as List)
              .map((e) => PlayerCard.fromJson(e))
              .toList()
          : null,
      currentFavouriteCard: json['currentFavouriteCard'] != null
          ? Item.fromJson(json['currentFavouriteCard'])
          : null,
      badges: json['badges'] != null
          ? (json['badges'] as List)
              .map((e) => PlayerBadge.fromJson(e))
              .toList()
          : null,
      achievements: json['achievements'] != null
          ? (json['achievements'] as List)
              .map((e) => PlayerAchievement.fromJson(e))
              .toList()
          : null,
      leagueStatistics: json['leagueStatistics'] != null
          ? PlayerLeagueStatistics.fromJson(json['leagueStatistics'])
          : null,
      currentPathOfLegendSeasonResult:
          json['currentPathOfLegendSeasonResult'] != null
              ? PathOfLegendSeasonResult.fromJson(
                  json['currentPathOfLegendSeasonResult'])
              : null,
      lastPathOfLegendSeasonResult: json['lastPathOfLegendSeasonResult'] != null
          ? PathOfLegendSeasonResult.fromJson(
              json['lastPathOfLegendSeasonResult'])
          : null,
      bestPathOfLegendSeasonResult: json['bestPathOfLegendSeasonResult'] != null
          ? PathOfLegendSeasonResult.fromJson(
              json['bestPathOfLegendSeasonResult'])
          : null,
    );
  }

  /// 승률 계산
  double get winRate {
    if (battleCount == 0) return 0.0;
    return (wins / battleCount) * 100;
  }

  /// 승률 텍스트
  String get winRateText => '${winRate.toStringAsFixed(1)}%';
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

/// 플레이어 카드 정보
class PlayerCard {
  final String name;
  final int id;
  final int level;
  final int? starLevel;
  final int? count;
  final int maxLevel;
  final String? rarity;
  final IconUrls? iconUrls;

  PlayerCard({
    required this.name,
    required this.id,
    required this.level,
    this.starLevel,
    this.count,
    required this.maxLevel,
    this.rarity,
    this.iconUrls,
  });

  factory PlayerCard.fromJson(Map<String, dynamic> json) {
    return PlayerCard(
      name: json['name'] ?? '',
      id: json['id'] ?? 0,
      level: json['level'] ?? 0,
      starLevel: json['starLevel'],
      count: json['count'],
      maxLevel: json['maxLevel'] ?? 14,
      rarity: json['rarity'],
      iconUrls:
          json['iconUrls'] != null ? IconUrls.fromJson(json['iconUrls']) : null,
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

/// 아이템 정보
class Item {
  final String name;
  final int id;
  final int? maxLevel;
  final IconUrls? iconUrls;

  Item({
    required this.name,
    required this.id,
    this.maxLevel,
    this.iconUrls,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      name: json['name'] ?? '',
      id: json['id'] ?? 0,
      maxLevel: json['maxLevel'],
      iconUrls:
          json['iconUrls'] != null ? IconUrls.fromJson(json['iconUrls']) : null,
    );
  }
}

/// 플레이어 배지
class PlayerBadge {
  final String name;
  final int? level;
  final int? maxLevel;
  final int? progress;
  final int? target;
  final String? iconUrls;

  PlayerBadge({
    required this.name,
    this.level,
    this.maxLevel,
    this.progress,
    this.target,
    this.iconUrls,
  });

  factory PlayerBadge.fromJson(Map<String, dynamic> json) {
    return PlayerBadge(
      name: json['name'] ?? '',
      level: json['level'],
      maxLevel: json['maxLevel'],
      progress: json['progress'],
      target: json['target'],
      iconUrls: json['iconUrls'],
    );
  }
}

/// 플레이어 업적
class PlayerAchievement {
  final String name;
  final int stars;
  final int value;
  final int target;
  final String? info;
  final String? completionInfo;

  PlayerAchievement({
    required this.name,
    required this.stars,
    required this.value,
    required this.target,
    this.info,
    this.completionInfo,
  });

  factory PlayerAchievement.fromJson(Map<String, dynamic> json) {
    return PlayerAchievement(
      name: json['name'] ?? '',
      stars: json['stars'] ?? 0,
      value: json['value'] ?? 0,
      target: json['target'] ?? 0,
      info: json['info'],
      completionInfo: json['completionInfo'],
    );
  }
}

/// 리그 통계
class PlayerLeagueStatistics {
  final LeagueSeason? currentSeason;
  final LeagueSeason? previousSeason;
  final LeagueSeason? bestSeason;

  PlayerLeagueStatistics({
    this.currentSeason,
    this.previousSeason,
    this.bestSeason,
  });

  factory PlayerLeagueStatistics.fromJson(Map<String, dynamic> json) {
    return PlayerLeagueStatistics(
      currentSeason: json['currentSeason'] != null
          ? LeagueSeason.fromJson(json['currentSeason'])
          : null,
      previousSeason: json['previousSeason'] != null
          ? LeagueSeason.fromJson(json['previousSeason'])
          : null,
      bestSeason: json['bestSeason'] != null
          ? LeagueSeason.fromJson(json['bestSeason'])
          : null,
    );
  }
}

/// 리그 시즌 정보
class LeagueSeason {
  final String? id;
  final int? trophies;
  final int? bestTrophies;

  LeagueSeason({
    this.id,
    this.trophies,
    this.bestTrophies,
  });

  factory LeagueSeason.fromJson(Map<String, dynamic> json) {
    return LeagueSeason(
      id: json['id'],
      trophies: json['trophies'],
      bestTrophies: json['bestTrophies'],
    );
  }
}

/// Path of Legend 시즌 결과
class PathOfLegendSeasonResult {
  final int? leagueNumber;
  final int? trophies;
  final int? rank;

  PathOfLegendSeasonResult({
    this.leagueNumber,
    this.trophies,
    this.rank,
  });

  factory PathOfLegendSeasonResult.fromJson(Map<String, dynamic> json) {
    return PathOfLegendSeasonResult(
      leagueNumber: json['leagueNumber'],
      trophies: json['trophies'],
      rank: json['rank'],
    );
  }
}
