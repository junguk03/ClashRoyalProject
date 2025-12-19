/// 토너먼트 헤더 (검색 결과용)
class TournamentHeader {
  final String tag;
  final String name;
  final String? type;
  final String? status;
  final int? capacity;
  final int? maxCapacity;
  final int? preparationDuration;
  final int? duration;
  final String? createdTime;

  TournamentHeader({
    required this.tag,
    required this.name,
    this.type,
    this.status,
    this.capacity,
    this.maxCapacity,
    this.preparationDuration,
    this.duration,
    this.createdTime,
  });

  factory TournamentHeader.fromJson(Map<String, dynamic> json) {
    return TournamentHeader(
      tag: json['tag'] ?? '',
      name: json['name'] ?? '',
      type: json['type'],
      status: json['status'],
      capacity: json['capacity'],
      maxCapacity: json['maxCapacity'],
      preparationDuration: json['preparationDuration'],
      duration: json['duration'],
      createdTime: json['createdTime'],
    );
  }
}

/// 토너먼트 상세 정보
class Tournament {
  final String tag;
  final String name;
  final String? description;
  final String? creatorTag;
  final String status; // inPreparation, inProgress, ended, cancelled
  final String type; // open, passwordProtected, joinable
  final int capacity;
  final int maxCapacity;
  final int? levelCap;
  final int? preparationDuration;
  final int? duration;
  final String? createdTime;
  final String? startedTime;
  final String? endedTime;
  final int? firstPlaceCardPrize;
  final GameMode? gameMode;
  final List<TournamentMember>? membersList;

  Tournament({
    required this.tag,
    required this.name,
    this.description,
    this.creatorTag,
    required this.status,
    required this.type,
    required this.capacity,
    required this.maxCapacity,
    this.levelCap,
    this.preparationDuration,
    this.duration,
    this.createdTime,
    this.startedTime,
    this.endedTime,
    this.firstPlaceCardPrize,
    this.gameMode,
    this.membersList,
  });

  factory Tournament.fromJson(Map<String, dynamic> json) {
    return Tournament(
      tag: json['tag'] ?? '',
      name: json['name'] ?? '',
      description: json['description'],
      creatorTag: json['creatorTag'],
      status: json['status'] ?? '',
      type: json['type'] ?? '',
      capacity: json['capacity'] ?? 0,
      maxCapacity: json['maxCapacity'] ?? 0,
      levelCap: json['levelCap'],
      preparationDuration: json['preparationDuration'],
      duration: json['duration'],
      createdTime: json['createdTime'],
      startedTime: json['startedTime'],
      endedTime: json['endedTime'],
      firstPlaceCardPrize: json['firstPlaceCardPrize'],
      gameMode: json['gameMode'] != null
          ? GameMode.fromJson(json['gameMode'])
          : null,
      membersList: json['membersList'] != null
          ? (json['membersList'] as List)
              .map((e) => TournamentMember.fromJson(e))
              .toList()
          : null,
    );
  }

  /// 상태 텍스트
  String get statusText {
    switch (status) {
      case 'inPreparation':
        return '준비 중';
      case 'inProgress':
        return '진행 중';
      case 'ended':
        return '종료';
      case 'cancelled':
        return '취소됨';
      default:
        return status;
    }
  }

  /// 타입 텍스트
  String get typeText {
    switch (type) {
      case 'open':
        return '공개';
      case 'passwordProtected':
        return '비밀번호';
      case 'joinable':
        return '참가 가능';
      default:
        return type;
    }
  }
}

/// 토너먼트 참가자
class TournamentMember {
  final String tag;
  final String name;
  final int? score;
  final int? rank;
  final TournamentClan? clan;

  TournamentMember({
    required this.tag,
    required this.name,
    this.score,
    this.rank,
    this.clan,
  });

  factory TournamentMember.fromJson(Map<String, dynamic> json) {
    return TournamentMember(
      tag: json['tag'] ?? '',
      name: json['name'] ?? '',
      score: json['score'],
      rank: json['rank'],
      clan: json['clan'] != null ? TournamentClan.fromJson(json['clan']) : null,
    );
  }
}

/// 토너먼트 클랜 정보
class TournamentClan {
  final String tag;
  final String name;
  final int? badgeId;

  TournamentClan({
    required this.tag,
    required this.name,
    this.badgeId,
  });

  factory TournamentClan.fromJson(Map<String, dynamic> json) {
    return TournamentClan(
      tag: json['tag'] ?? '',
      name: json['name'] ?? '',
      badgeId: json['badgeId'],
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

/// 글로벌 토너먼트 (래더 토너먼트)
class LadderTournament {
  final String? tag;
  final String? title;
  final String? startTime;
  final String? endTime;
  final int? maxLosses;
  final int? maxWins;
  final GameMode? gameMode;
  final List<LadderTournamentReward>? milestoneRewards;
  final List<LadderTournamentReward>? freeTierRewards;
  final List<LadderTournamentReward>? topRankReward;

  LadderTournament({
    this.tag,
    this.title,
    this.startTime,
    this.endTime,
    this.maxLosses,
    this.maxWins,
    this.gameMode,
    this.milestoneRewards,
    this.freeTierRewards,
    this.topRankReward,
  });

  factory LadderTournament.fromJson(Map<String, dynamic> json) {
    return LadderTournament(
      tag: json['tag'],
      title: json['title'],
      startTime: json['startTime'],
      endTime: json['endTime'],
      maxLosses: json['maxLosses'],
      maxWins: json['maxWins'],
      gameMode: json['gameMode'] != null
          ? GameMode.fromJson(json['gameMode'])
          : null,
      milestoneRewards: json['milestoneRewards'] != null
          ? (json['milestoneRewards'] as List)
              .map((e) => LadderTournamentReward.fromJson(e))
              .toList()
          : null,
      freeTierRewards: json['freeTierRewards'] != null
          ? (json['freeTierRewards'] as List)
              .map((e) => LadderTournamentReward.fromJson(e))
              .toList()
          : null,
      topRankReward: json['topRankReward'] != null
          ? (json['topRankReward'] as List)
              .map((e) => LadderTournamentReward.fromJson(e))
              .toList()
          : null,
    );
  }
}

/// 글로벌 토너먼트 보상
class LadderTournamentReward {
  final int? wins;
  final String? type;
  final int? amount;
  final String? resource;
  final CardReward? card;
  final ChestReward? chest;

  LadderTournamentReward({
    this.wins,
    this.type,
    this.amount,
    this.resource,
    this.card,
    this.chest,
  });

  factory LadderTournamentReward.fromJson(Map<String, dynamic> json) {
    return LadderTournamentReward(
      wins: json['wins'],
      type: json['type'],
      amount: json['amount'],
      resource: json['resource'],
      card: json['card'] != null ? CardReward.fromJson(json['card']) : null,
      chest: json['chest'] != null ? ChestReward.fromJson(json['chest']) : null,
    );
  }
}

/// 카드 보상
class CardReward {
  final String name;
  final int id;
  final int? level;
  final int? maxLevel;

  CardReward({
    required this.name,
    required this.id,
    this.level,
    this.maxLevel,
  });

  factory CardReward.fromJson(Map<String, dynamic> json) {
    return CardReward(
      name: json['name'] ?? '',
      id: json['id'] ?? 0,
      level: json['level'],
      maxLevel: json['maxLevel'],
    );
  }
}

/// 상자 보상
class ChestReward {
  final String name;

  ChestReward({required this.name});

  factory ChestReward.fromJson(Map<String, dynamic> json) {
    return ChestReward(
      name: json['name'] ?? '',
    );
  }
}

/// 글로벌 토너먼트 랭킹
class LadderTournamentRanking {
  final String tag;
  final String name;
  final int rank;
  final int? previousRank;
  final int trophies;
  final int? losses;
  final int? wins;
  final TournamentClan? clan;

  LadderTournamentRanking({
    required this.tag,
    required this.name,
    required this.rank,
    this.previousRank,
    required this.trophies,
    this.losses,
    this.wins,
    this.clan,
  });

  factory LadderTournamentRanking.fromJson(Map<String, dynamic> json) {
    return LadderTournamentRanking(
      tag: json['tag'] ?? '',
      name: json['name'] ?? '',
      rank: json['rank'] ?? 0,
      previousRank: json['previousRank'],
      trophies: json['trophies'] ?? 0,
      losses: json['losses'],
      wins: json['wins'],
      clan: json['clan'] != null ? TournamentClan.fromJson(json['clan']) : null,
    );
  }
}
