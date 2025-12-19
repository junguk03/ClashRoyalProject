import 'package:get/get.dart';

import '../../components/logger/logger.dart';
import '../config/api_config.dart';
import '../core/api_client.dart';
import '../core/api_exceptions.dart';
import '../core/api_response.dart';
import '../models/battle_model.dart';
import '../models/chest_model.dart';
import '../models/player_model.dart';

/// 플레이어 정보 서비스
class PlayerService extends GetxService {
  final ApiClient _apiClient = Get.find<ApiClient>();

  static PlayerService get to => Get.find();

  /// 플레이어 태그로 플레이어 정보 조회
  /// [playerTag] - 플레이어 태그 (예: '#2ABC' 또는 '2ABC')
  Future<ApiResponse<Player>> getPlayer(String playerTag) async {
    try {
      final endpoint = ApiConfig.playerByTag(playerTag);

      log.i('Fetching player info for tag: $playerTag');
      log.d('Endpoint: $endpoint');

      final response = await _apiClient.get<Player>(
        endpoint,
        fromJson: (json) => Player.fromJson(json),
      );

      if (response.success && response.data != null) {
        final player = response.data!;
        log.i('Player found: ${player.name} (${player.tag})');
        log.d('Trophies: ${player.trophies}, Level: ${player.expLevel}');
        return response;
      }

      throw ApiException('Player data not received');
    } on ApiException catch (e) {
      log.e('Failed to fetch player: ${e.message}');
      rethrow;
    } catch (e) {
      log.e('Unexpected error fetching player: $e');
      throw ApiException('Failed to fetch player: $e');
    }
  }

  /// 플레이어 다가오는 상자 조회
  Future<ApiResponse<UpcomingChests>> getUpcomingChests(String playerTag) async {
    try {
      final endpoint = ApiConfig.playerUpcomingChests(playerTag);

      log.i('Fetching upcoming chests for tag: $playerTag');

      final response = await _apiClient.get<UpcomingChests>(
        endpoint,
        fromJson: (json) => UpcomingChests.fromJson(json),
      );

      if (response.success && response.data != null) {
        log.i('Upcoming chests fetched: ${response.data!.items.length} items');
        return response;
      }

      throw ApiException('Upcoming chests data not received');
    } on ApiException catch (e) {
      log.e('Failed to fetch upcoming chests: ${e.message}');
      rethrow;
    } catch (e) {
      log.e('Unexpected error fetching upcoming chests: $e');
      throw ApiException('Failed to fetch upcoming chests: $e');
    }
  }

  /// 플레이어 전투 기록 조회
  Future<ApiResponse<List<Battle>>> getBattleLog(String playerTag) async {
    try {
      final endpoint = ApiConfig.playerBattleLog(playerTag);

      log.i('Fetching battle log for tag: $playerTag');

      final response = await _apiClient.get<List<Battle>>(
        endpoint,
        fromJson: (json) {
          if (json['data'] is List) {
            return (json['data'] as List)
                .map((e) => Battle.fromJson(e as Map<String, dynamic>))
                .toList();
          }
          if (json['items'] != null) {
            return (json['items'] as List)
                .map((e) => Battle.fromJson(e as Map<String, dynamic>))
                .toList();
          }
          return <Battle>[];
        },
      );

      if (response.success && response.data != null) {
        log.i('Battle log fetched: ${response.data!.length} battles');
        return response;
      }

      throw ApiException('Battle log data not received');
    } on ApiException catch (e) {
      log.e('Failed to fetch battle log: ${e.message}');
      rethrow;
    } catch (e) {
      log.e('Unexpected error fetching battle log: $e');
      throw ApiException('Failed to fetch battle log: $e');
    }
  }

  /// 플레이어 태그 유효성 검사
  bool isValidTag(String tag) {
    final cleanTag = tag.startsWith('#') ? tag.substring(1) : tag;
    final tagRegex = RegExp(r'^[0-9A-Za-z]+$');

    if (cleanTag.isEmpty) return false;
    if (cleanTag.length < 3 || cleanTag.length > 12) return false;

    return tagRegex.hasMatch(cleanTag);
  }
}
