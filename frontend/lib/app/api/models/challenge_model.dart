import 'tournament_model.dart';

/// 챌린지 정보
class Challenge {
  final int id;
  final String name;
  final String? description;
  final int? winMode; // 0: no reset, 1: reset on loss
  final int? casualWins;
  final int? maxWins;
  final int? maxLosses;
  final String? iconUrl;
  final GameMode? gameMode;

  Challenge({
    required this.id,
    required this.name,
    this.description,
    this.winMode,
    this.casualWins,
    this.maxWins,
    this.maxLosses,
    this.iconUrl,
    this.gameMode,
  });

  factory Challenge.fromJson(Map<String, dynamic> json) {
    return Challenge(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'],
      winMode: json['winMode'],
      casualWins: json['casualWins'],
      maxWins: json['maxWins'],
      maxLosses: json['maxLosses'],
      iconUrl: json['iconUrl'],
      gameMode: json['gameMode'] != null
          ? GameMode.fromJson(json['gameMode'])
          : null,
    );
  }

  /// winMode 텍스트
  String get winModeText {
    switch (winMode) {
      case 0:
        return '패배해도 리셋 안됨';
      case 1:
        return '패배시 리셋';
      default:
        return '';
    }
  }
}

/// 챌린지 목록 응답
class ChallengesResponse {
  final List<Challenge> items;

  ChallengesResponse({required this.items});

  factory ChallengesResponse.fromJson(List<dynamic> json) {
    return ChallengesResponse(
      items: json.map((e) => Challenge.fromJson(e)).toList(),
    );
  }
}
