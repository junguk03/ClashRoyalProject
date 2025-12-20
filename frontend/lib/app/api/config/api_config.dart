import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConfig {
  ApiConfig._();

  // Backend API Base URL (from .env)
  static String get baseUrl => dotenv.env['API_BASE_URL'] ?? 'http://localhost:3000/api/v1';

  // No API Key needed - backend handles it
  // Frontend doesn't need to send API key anymore
  static String _apiKey = '';

  static String get apiKey => _apiKey;

  static void setApiKey(String key) {
    _apiKey = key;
  }

  static bool get hasApiKey => true; // Always true since backend handles authentication

  // =====================
  // Endpoints
  // =====================

  // Players
  static const String players = '/players';
  static String playerByTag(String tag) => '/players/${encodeTag(tag)}';
  static String playerUpcomingChests(String tag) => '/players/${encodeTag(tag)}/upcomingchests';
  static String playerBattleLog(String tag) => '/players/${encodeTag(tag)}/battlelog';

  // Clans
  static const String clans = '/clans';
  static String clanByTag(String tag) => '/clans/${encodeTag(tag)}';
  static String clanMembers(String tag) => '/clans/${encodeTag(tag)}/members';
  static String clanWarLog(String tag) => '/clans/${encodeTag(tag)}/warlog';
  static String clanCurrentWar(String tag) => '/clans/${encodeTag(tag)}/currentwar';
  static String clanCurrentRiverRace(String tag) => '/clans/${encodeTag(tag)}/currentriverrace';
  static String clanRiverRaceLog(String tag) => '/clans/${encodeTag(tag)}/riverracelog';

  // Cards
  static const String cards = '/cards';

  // Tournaments
  static const String tournaments = '/tournaments';
  static String tournamentByTag(String tag) => '/tournaments/${encodeTag(tag)}';

  // Challenges
  static const String challenges = '/challenges';

  // Global Tournaments
  static const String globalTournaments = '/globaltournaments';

  // Locations
  static const String locations = '/locations';
  static String locationById(int id) => '/locations/$id';
  static String locationPlayerRankings(int id) => '/locations/$id/rankings/players';
  static String locationClanRankings(int id) => '/locations/$id/rankings/clans';
  static String locationClanWarRankings(int id) => '/locations/$id/rankings/clanwars';
  static String locationPathOfLegendRankings(int id) => '/locations/$id/pathoflegend/players';
  static String locationSeasons(int id) => '/locations/$id/seasons';
  static String locationSeasonPlayerRankings(int id, String seasonId) =>
      '/locations/$id/seasons/$seasonId/rankings/players';
  static String locationPathOfLegendSeasons(int id) => '/locations/$id/pathoflegend/seasons';
  static String locationPathOfLegendSeasonRankings(int id, String seasonId) =>
      '/locations/$id/pathoflegend/$seasonId/rankings/players';
  static String locationGlobalTournamentRankings(String tag) =>
      '/locations/global/rankings/tournaments/${encodeTag(tag)}';

  // Global Seasons
  static const String globalSeasons = '/locations/global/seasons';
  static const String globalSeasonsV2 = '/locations/global/seasonsV2';
  static String globalSeasonById(String id) => '/locations/global/seasons/$id';
  static String globalSeasonPlayerRankings(String id) => '/locations/global/seasons/$id/rankings/players';
  static String globalPathOfLegendRankings(String seasonId) => '/locations/global/pathoflegend/$seasonId/rankings/players';
  static String globalTournamentRankings(String tag) => '/locations/global/rankings/tournaments/${encodeTag(tag)}';

  // Timeout 설정
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // Retry 설정
  static const int maxRetryAttempts = 3;
  static const List<Duration> retryDelays = [
    Duration(seconds: 1),
    Duration(seconds: 3),
    Duration(seconds: 5),
  ];

  // 기본 헤더
  static Map<String, String> get defaultHeaders => {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        if (_apiKey.isNotEmpty) 'Authorization': 'Bearer $_apiKey',
      };

  /// Tag를 URL 인코딩 (Player, Clan, Tournament 공통)
  /// '#2ABC' -> '%232ABC'
  static String encodeTag(String tag) {
    if (tag.startsWith('#')) {
      return '%23${tag.substring(1)}';
    }
    if (tag.startsWith('%23')) {
      return tag; // 이미 인코딩됨
    }
    return '%23$tag';
  }

  /// URL 인코딩된 태그를 원래 형태로 디코딩
  /// '%232ABC' -> '#2ABC'
  static String decodeTag(String encodedTag) {
    if (encodedTag.startsWith('%23')) {
      return '#${encodedTag.substring(3)}';
    }
    return encodedTag;
  }
}
