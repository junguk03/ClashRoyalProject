import 'common_model.dart' show Location, Paging;

/// 클랜 정보
class Clan {
  final String tag;
  final String name;
  final String? description;
  final String type; // open, inviteOnly, closed
  final int badgeId;
  final Map<String, String>? badgeUrls;
  final int clanScore;
  final int clanWarTrophies;
  final int requiredTrophies;
  final int donationsPerWeek;
  final int members;
  final Location? location;
  final List<ClanMember>? memberList;
  final String? clanChestStatus;
  final int? clanChestLevel;
  final int? clanChestMaxLevel;
  final int? clanChestPoints;

  Clan({
    required this.tag,
    required this.name,
    this.description,
    required this.type,
    required this.badgeId,
    this.badgeUrls,
    required this.clanScore,
    required this.clanWarTrophies,
    required this.requiredTrophies,
    required this.donationsPerWeek,
    required this.members,
    this.location,
    this.memberList,
    this.clanChestStatus,
    this.clanChestLevel,
    this.clanChestMaxLevel,
    this.clanChestPoints,
  });

  factory Clan.fromJson(Map<String, dynamic> json) {
    return Clan(
      tag: json['tag'] ?? '',
      name: json['name'] ?? '',
      description: json['description'],
      type: json['type'] ?? 'open',
      badgeId: json['badgeId'] ?? 0,
      badgeUrls: json['badgeUrls'] != null
          ? Map<String, String>.from(json['badgeUrls'])
          : null,
      clanScore: json['clanScore'] ?? 0,
      clanWarTrophies: json['clanWarTrophies'] ?? 0,
      requiredTrophies: json['requiredTrophies'] ?? 0,
      donationsPerWeek: json['donationsPerWeek'] ?? 0,
      members: json['members'] ?? 0,
      location: json['location'] != null
          ? Location.fromJson(json['location'])
          : null,
      memberList: json['memberList'] != null
          ? (json['memberList'] as List)
              .map((e) => ClanMember.fromJson(e))
              .toList()
          : null,
      clanChestStatus: json['clanChestStatus'],
      clanChestLevel: json['clanChestLevel'],
      clanChestMaxLevel: json['clanChestMaxLevel'],
      clanChestPoints: json['clanChestPoints'],
    );
  }

  /// 클랜 타입 텍스트
  String get typeText {
    switch (type) {
      case 'open':
        return '공개';
      case 'inviteOnly':
        return '초대만';
      case 'closed':
        return '비공개';
      default:
        return type;
    }
  }
}

/// 클랜 멤버
class ClanMember {
  final String tag;
  final String name;
  final String role; // leader, coLeader, elder, member
  final int expLevel;
  final int trophies;
  final int? clanRank;
  final int? previousClanRank;
  final int donations;
  final int donationsReceived;
  final int? clanChestPoints;
  final Arena? arena;
  final int? lastSeen;

  ClanMember({
    required this.tag,
    required this.name,
    required this.role,
    required this.expLevel,
    required this.trophies,
    this.clanRank,
    this.previousClanRank,
    required this.donations,
    required this.donationsReceived,
    this.clanChestPoints,
    this.arena,
    this.lastSeen,
  });

  factory ClanMember.fromJson(Map<String, dynamic> json) {
    return ClanMember(
      tag: json['tag'] ?? '',
      name: json['name'] ?? '',
      role: json['role'] ?? 'member',
      expLevel: json['expLevel'] ?? 0,
      trophies: json['trophies'] ?? 0,
      clanRank: json['clanRank'],
      previousClanRank: json['previousClanRank'],
      donations: json['donations'] ?? 0,
      donationsReceived: json['donationsReceived'] ?? 0,
      clanChestPoints: json['clanChestPoints'],
      arena: json['arena'] != null ? Arena.fromJson(json['arena']) : null,
      lastSeen: json['lastSeen'],
    );
  }

  /// 역할 텍스트
  String get roleText {
    switch (role) {
      case 'leader':
        return '리더';
      case 'coLeader':
        return '공동리더';
      case 'elder':
        return '장로';
      case 'member':
        return '멤버';
      default:
        return role;
    }
  }
}

/// 아레나
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

/// 현재 클랜전 정보
class CurrentClanWar {
  final String state;
  final ClanWarClan? clan;
  final List<ClanWarParticipant>? participants;
  final List<ClanWarClan>? clans;
  final String? collectionEndTime;
  final String? warEndTime;

  CurrentClanWar({
    required this.state,
    this.clan,
    this.participants,
    this.clans,
    this.collectionEndTime,
    this.warEndTime,
  });

  factory CurrentClanWar.fromJson(Map<String, dynamic> json) {
    return CurrentClanWar(
      state: json['state'] ?? '',
      clan: json['clan'] != null ? ClanWarClan.fromJson(json['clan']) : null,
      participants: json['participants'] != null
          ? (json['participants'] as List)
              .map((e) => ClanWarParticipant.fromJson(e))
              .toList()
          : null,
      clans: json['clans'] != null
          ? (json['clans'] as List)
              .map((e) => ClanWarClan.fromJson(e))
              .toList()
          : null,
      collectionEndTime: json['collectionEndTime'],
      warEndTime: json['warEndTime'],
    );
  }
}

/// 클랜전 클랜
class ClanWarClan {
  final String tag;
  final String name;
  final int? badgeId;
  final int? clanScore;
  final int? participants;
  final int? battlesPlayed;
  final int? wins;
  final int? crowns;

  ClanWarClan({
    required this.tag,
    required this.name,
    this.badgeId,
    this.clanScore,
    this.participants,
    this.battlesPlayed,
    this.wins,
    this.crowns,
  });

  factory ClanWarClan.fromJson(Map<String, dynamic> json) {
    return ClanWarClan(
      tag: json['tag'] ?? '',
      name: json['name'] ?? '',
      badgeId: json['badgeId'],
      clanScore: json['clanScore'],
      participants: json['participants'],
      battlesPlayed: json['battlesPlayed'],
      wins: json['wins'],
      crowns: json['crowns'],
    );
  }
}

/// 클랜전 참가자
class ClanWarParticipant {
  final String tag;
  final String name;
  final int? cardsEarned;
  final int? battlesPlayed;
  final int? wins;
  final int? collectionDayBattlesPlayed;
  final int? numberOfBattles;

  ClanWarParticipant({
    required this.tag,
    required this.name,
    this.cardsEarned,
    this.battlesPlayed,
    this.wins,
    this.collectionDayBattlesPlayed,
    this.numberOfBattles,
  });

  factory ClanWarParticipant.fromJson(Map<String, dynamic> json) {
    return ClanWarParticipant(
      tag: json['tag'] ?? '',
      name: json['name'] ?? '',
      cardsEarned: json['cardsEarned'],
      battlesPlayed: json['battlesPlayed'],
      wins: json['wins'],
      collectionDayBattlesPlayed: json['collectionDayBattlesPlayed'],
      numberOfBattles: json['numberOfBattles'],
    );
  }
}

/// 현재 리버레이스 정보
class CurrentRiverRace {
  final String state;
  final RiverRaceClan? clan;
  final List<RiverRaceClan>? clans;
  final String? collectionEndTime;
  final String? warEndTime;
  final int? sectionIndex;
  final int? periodIndex;
  final String? periodType;
  final List<PeriodLog>? periodLogs;

  CurrentRiverRace({
    required this.state,
    this.clan,
    this.clans,
    this.collectionEndTime,
    this.warEndTime,
    this.sectionIndex,
    this.periodIndex,
    this.periodType,
    this.periodLogs,
  });

  factory CurrentRiverRace.fromJson(Map<String, dynamic> json) {
    return CurrentRiverRace(
      state: json['state'] ?? '',
      clan: json['clan'] != null ? RiverRaceClan.fromJson(json['clan']) : null,
      clans: json['clans'] != null
          ? (json['clans'] as List)
              .map((e) => RiverRaceClan.fromJson(e))
              .toList()
          : null,
      collectionEndTime: json['collectionEndTime'],
      warEndTime: json['warEndTime'],
      sectionIndex: json['sectionIndex'],
      periodIndex: json['periodIndex'],
      periodType: json['periodType'],
      periodLogs: json['periodLogs'] != null
          ? (json['periodLogs'] as List)
              .map((e) => PeriodLog.fromJson(e))
              .toList()
          : null,
    );
  }
}

/// 리버레이스 클랜
class RiverRaceClan {
  final String tag;
  final String name;
  final int? badgeId;
  final int? fame;
  final int? repairPoints;
  final int? finishTime;
  final List<RiverRaceParticipant>? participants;

  RiverRaceClan({
    required this.tag,
    required this.name,
    this.badgeId,
    this.fame,
    this.repairPoints,
    this.finishTime,
    this.participants,
  });

  factory RiverRaceClan.fromJson(Map<String, dynamic> json) {
    return RiverRaceClan(
      tag: json['tag'] ?? '',
      name: json['name'] ?? '',
      badgeId: json['badgeId'],
      fame: json['fame'],
      repairPoints: json['repairPoints'],
      finishTime: json['finishTime'],
      participants: json['participants'] != null
          ? (json['participants'] as List)
              .map((e) => RiverRaceParticipant.fromJson(e))
              .toList()
          : null,
    );
  }
}

/// 리버레이스 참가자
class RiverRaceParticipant {
  final String tag;
  final String name;
  final int? fame;
  final int? repairPoints;
  final int? boatAttacks;
  final int? decksUsed;
  final int? decksUsedToday;

  RiverRaceParticipant({
    required this.tag,
    required this.name,
    this.fame,
    this.repairPoints,
    this.boatAttacks,
    this.decksUsed,
    this.decksUsedToday,
  });

  factory RiverRaceParticipant.fromJson(Map<String, dynamic> json) {
    return RiverRaceParticipant(
      tag: json['tag'] ?? '',
      name: json['name'] ?? '',
      fame: json['fame'],
      repairPoints: json['repairPoints'],
      boatAttacks: json['boatAttacks'],
      decksUsed: json['decksUsed'],
      decksUsedToday: json['decksUsedToday'],
    );
  }
}

/// 기간 로그
class PeriodLog {
  final int? periodIndex;
  final List<PeriodLogItem>? items;

  PeriodLog({
    this.periodIndex,
    this.items,
  });

  factory PeriodLog.fromJson(Map<String, dynamic> json) {
    return PeriodLog(
      periodIndex: json['periodIndex'],
      items: json['items'] != null
          ? (json['items'] as List)
              .map((e) => PeriodLogItem.fromJson(e))
              .toList()
          : null,
    );
  }
}

/// 기간 로그 항목
class PeriodLogItem {
  final String? clan;
  final int? pointsEarned;
  final int? progressStartOfDay;
  final int? progressEndOfDay;
  final int? endOfDayRank;
  final int? progressEarned;
  final int? numOfDefensesRemaining;
  final int? progressEarnedFromDefenses;

  PeriodLogItem({
    this.clan,
    this.pointsEarned,
    this.progressStartOfDay,
    this.progressEndOfDay,
    this.endOfDayRank,
    this.progressEarned,
    this.numOfDefensesRemaining,
    this.progressEarnedFromDefenses,
  });

  factory PeriodLogItem.fromJson(Map<String, dynamic> json) {
    return PeriodLogItem(
      clan: json['clan'],
      pointsEarned: json['pointsEarned'],
      progressStartOfDay: json['progressStartOfDay'],
      progressEndOfDay: json['progressEndOfDay'],
      endOfDayRank: json['endOfDayRank'],
      progressEarned: json['progressEarned'],
      numOfDefensesRemaining: json['numOfDefensesRemaining'],
      progressEarnedFromDefenses: json['progressEarnedFromDefenses'],
    );
  }
}

/// 클랜전 로그 항목
class ClanWarLogEntry {
  final int? seasonId;
  final String? createdDate;
  final List<ClanWarClan>? participants;
  final List<ClanWarClan>? standings;

  ClanWarLogEntry({
    this.seasonId,
    this.createdDate,
    this.participants,
    this.standings,
  });

  factory ClanWarLogEntry.fromJson(Map<String, dynamic> json) {
    return ClanWarLogEntry(
      seasonId: json['seasonId'],
      createdDate: json['createdDate'],
      participants: json['participants'] != null
          ? (json['participants'] as List)
              .map((e) => ClanWarClan.fromJson(e))
              .toList()
          : null,
      standings: json['standings'] != null
          ? (json['standings'] as List)
              .map((e) => ClanWarClan.fromJson(e))
              .toList()
          : null,
    );
  }
}

/// 리버레이스 로그 항목
class RiverRaceLogEntry {
  final int? seasonId;
  final int? sectionIndex;
  final String? createdDate;
  final List<RiverRaceClan>? standings;

  RiverRaceLogEntry({
    this.seasonId,
    this.sectionIndex,
    this.createdDate,
    this.standings,
  });

  factory RiverRaceLogEntry.fromJson(Map<String, dynamic> json) {
    return RiverRaceLogEntry(
      seasonId: json['seasonId'],
      sectionIndex: json['sectionIndex'],
      createdDate: json['createdDate'],
      standings: json['standings'] != null
          ? (json['standings'] as List)
              .map((e) => RiverRaceClan.fromJson(e))
              .toList()
          : null,
    );
  }
}

/// 클랜 검색 응답
class ClanSearchResponse {
  final List<Clan> items;
  final Paging? paging;

  ClanSearchResponse({
    required this.items,
    this.paging,
  });

  factory ClanSearchResponse.fromJson(Map<String, dynamic> json) {
    return ClanSearchResponse(
      items: json['items'] != null
          ? (json['items'] as List).map((e) => Clan.fromJson(e)).toList()
          : [],
      paging: json['paging'] != null ? Paging.fromJson(json['paging']) : null,
    );
  }
}

/// 클랜 멤버 목록 응답
class ClanMembersResponse {
  final List<ClanMember> items;
  final Paging? paging;

  ClanMembersResponse({
    required this.items,
    this.paging,
  });

  factory ClanMembersResponse.fromJson(Map<String, dynamic> json) {
    return ClanMembersResponse(
      items: json['items'] != null
          ? (json['items'] as List).map((e) => ClanMember.fromJson(e)).toList()
          : [],
      paging: json['paging'] != null ? Paging.fromJson(json['paging']) : null,
    );
  }
}

/// 클랜전 로그 응답
class ClanWarLogResponse {
  final List<ClanWarLogEntry> items;
  final Paging? paging;

  ClanWarLogResponse({
    required this.items,
    this.paging,
  });

  factory ClanWarLogResponse.fromJson(Map<String, dynamic> json) {
    return ClanWarLogResponse(
      items: json['items'] != null
          ? (json['items'] as List)
              .map((e) => ClanWarLogEntry.fromJson(e))
              .toList()
          : [],
      paging: json['paging'] != null ? Paging.fromJson(json['paging']) : null,
    );
  }
}

/// 리버레이스 로그 응답
class RiverRaceLogResponse {
  final List<RiverRaceLogEntry> items;
  final Paging? paging;

  RiverRaceLogResponse({
    required this.items,
    this.paging,
  });

  factory RiverRaceLogResponse.fromJson(Map<String, dynamic> json) {
    return RiverRaceLogResponse(
      items: json['items'] != null
          ? (json['items'] as List)
              .map((e) => RiverRaceLogEntry.fromJson(e))
              .toList()
          : [],
      paging: json['paging'] != null ? Paging.fromJson(json['paging']) : null,
    );
  }
}
