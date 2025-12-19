import 'package:get/get.dart';

import '../../components/logger/logger.dart';
import '../config/api_config.dart';
import '../core/api_client.dart';
import '../core/api_exceptions.dart';
import '../core/api_response.dart';
import '../models/clan_model.dart';

/// 클랜 정보 서비스
class ClanService extends GetxService {
  final ApiClient _apiClient = Get.find<ApiClient>();

  static ClanService get to => Get.find();

  /// 클랜 검색
  Future<ApiResponse<ClanSearchResponse>> searchClans({
    String? name,
    int? locationId,
    int? minMembers,
    int? maxMembers,
    int? minScore,
    int? limit,
    String? after,
    String? before,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (name != null) queryParams['name'] = name;
      if (locationId != null) queryParams['locationId'] = locationId;
      if (minMembers != null) queryParams['minMembers'] = minMembers;
      if (maxMembers != null) queryParams['maxMembers'] = maxMembers;
      if (minScore != null) queryParams['minScore'] = minScore;
      if (limit != null) queryParams['limit'] = limit;
      if (after != null) queryParams['after'] = after;
      if (before != null) queryParams['before'] = before;

      log.i('Searching clans with params: $queryParams');

      final response = await _apiClient.get<ClanSearchResponse>(
        ApiConfig.clans,
        queryParams: queryParams,
        fromJson: (json) => ClanSearchResponse.fromJson(json),
      );

      if (response.success && response.data != null) {
        log.i('Found ${response.data!.items.length} clans');
        return response;
      }

      throw ApiException('Clan search data not received');
    } on ApiException catch (e) {
      log.e('Failed to search clans: ${e.message}');
      rethrow;
    } catch (e) {
      log.e('Unexpected error searching clans: $e');
      throw ApiException('Failed to search clans: $e');
    }
  }

  /// 클랜 상세 정보 조회
  Future<ApiResponse<Clan>> getClan(String clanTag) async {
    try {
      final endpoint = ApiConfig.clanByTag(clanTag);

      log.i('Fetching clan info for tag: $clanTag');

      final response = await _apiClient.get<Clan>(
        endpoint,
        fromJson: (json) => Clan.fromJson(json),
      );

      if (response.success && response.data != null) {
        final clan = response.data!;
        log.i('Clan found: ${clan.name} (${clan.tag})');
        return response;
      }

      throw ApiException('Clan data not received');
    } on ApiException catch (e) {
      log.e('Failed to fetch clan: ${e.message}');
      rethrow;
    } catch (e) {
      log.e('Unexpected error fetching clan: $e');
      throw ApiException('Failed to fetch clan: $e');
    }
  }

  /// 클랜 멤버 목록 조회
  Future<ApiResponse<ClanMembersResponse>> getClanMembers(
    String clanTag, {
    int? limit,
    String? after,
    String? before,
  }) async {
    try {
      final endpoint = ApiConfig.clanMembers(clanTag);
      final queryParams = <String, dynamic>{};
      if (limit != null) queryParams['limit'] = limit;
      if (after != null) queryParams['after'] = after;
      if (before != null) queryParams['before'] = before;

      log.i('Fetching clan members for tag: $clanTag');

      final response = await _apiClient.get<ClanMembersResponse>(
        endpoint,
        queryParams: queryParams.isNotEmpty ? queryParams : null,
        fromJson: (json) => ClanMembersResponse.fromJson(json),
      );

      if (response.success && response.data != null) {
        log.i('Found ${response.data!.items.length} members');
        return response;
      }

      throw ApiException('Clan members data not received');
    } on ApiException catch (e) {
      log.e('Failed to fetch clan members: ${e.message}');
      rethrow;
    } catch (e) {
      log.e('Unexpected error fetching clan members: $e');
      throw ApiException('Failed to fetch clan members: $e');
    }
  }

  /// 클랜 전쟁 기록 조회
  Future<ApiResponse<ClanWarLogResponse>> getClanWarLog(
    String clanTag, {
    int? limit,
    String? after,
    String? before,
  }) async {
    try {
      final endpoint = ApiConfig.clanWarLog(clanTag);
      final queryParams = <String, dynamic>{};
      if (limit != null) queryParams['limit'] = limit;
      if (after != null) queryParams['after'] = after;
      if (before != null) queryParams['before'] = before;

      log.i('Fetching clan war log for tag: $clanTag');

      final response = await _apiClient.get<ClanWarLogResponse>(
        endpoint,
        queryParams: queryParams.isNotEmpty ? queryParams : null,
        fromJson: (json) => ClanWarLogResponse.fromJson(json),
      );

      if (response.success && response.data != null) {
        log.i('Found ${response.data!.items.length} war logs');
        return response;
      }

      throw ApiException('Clan war log data not received');
    } on ApiException catch (e) {
      log.e('Failed to fetch clan war log: ${e.message}');
      rethrow;
    } catch (e) {
      log.e('Unexpected error fetching clan war log: $e');
      throw ApiException('Failed to fetch clan war log: $e');
    }
  }

  /// 현재 클랜 전쟁 조회
  Future<ApiResponse<CurrentClanWar>> getCurrentWar(String clanTag) async {
    try {
      final endpoint = ApiConfig.clanCurrentWar(clanTag);

      log.i('Fetching current war for clan: $clanTag');

      final response = await _apiClient.get<CurrentClanWar>(
        endpoint,
        fromJson: (json) => CurrentClanWar.fromJson(json),
      );

      if (response.success && response.data != null) {
        log.i('Current war state: ${response.data!.state}');
        return response;
      }

      throw ApiException('Current war data not received');
    } on ApiException catch (e) {
      log.e('Failed to fetch current war: ${e.message}');
      rethrow;
    } catch (e) {
      log.e('Unexpected error fetching current war: $e');
      throw ApiException('Failed to fetch current war: $e');
    }
  }

  /// 현재 리버 레이스 조회
  Future<ApiResponse<CurrentRiverRace>> getCurrentRiverRace(
      String clanTag) async {
    try {
      final endpoint = ApiConfig.clanCurrentRiverRace(clanTag);

      log.i('Fetching current river race for clan: $clanTag');

      final response = await _apiClient.get<CurrentRiverRace>(
        endpoint,
        fromJson: (json) => CurrentRiverRace.fromJson(json),
      );

      if (response.success && response.data != null) {
        log.i('Current river race state: ${response.data!.state}');
        return response;
      }

      throw ApiException('Current river race data not received');
    } on ApiException catch (e) {
      log.e('Failed to fetch current river race: ${e.message}');
      rethrow;
    } catch (e) {
      log.e('Unexpected error fetching current river race: $e');
      throw ApiException('Failed to fetch current river race: $e');
    }
  }

  /// 리버 레이스 기록 조회
  Future<ApiResponse<RiverRaceLogResponse>> getRiverRaceLog(
    String clanTag, {
    int? limit,
    String? after,
    String? before,
  }) async {
    try {
      final endpoint = ApiConfig.clanRiverRaceLog(clanTag);
      final queryParams = <String, dynamic>{};
      if (limit != null) queryParams['limit'] = limit;
      if (after != null) queryParams['after'] = after;
      if (before != null) queryParams['before'] = before;

      log.i('Fetching river race log for clan: $clanTag');

      final response = await _apiClient.get<RiverRaceLogResponse>(
        endpoint,
        queryParams: queryParams.isNotEmpty ? queryParams : null,
        fromJson: (json) => RiverRaceLogResponse.fromJson(json),
      );

      if (response.success && response.data != null) {
        log.i('Found ${response.data!.items.length} river race logs');
        return response;
      }

      throw ApiException('River race log data not received');
    } on ApiException catch (e) {
      log.e('Failed to fetch river race log: ${e.message}');
      rethrow;
    } catch (e) {
      log.e('Unexpected error fetching river race log: $e');
      throw ApiException('Failed to fetch river race log: $e');
    }
  }

  /// 클랜 태그 유효성 검사
  bool isValidTag(String tag) {
    final cleanTag = tag.startsWith('#') ? tag.substring(1) : tag;
    final tagRegex = RegExp(r'^[0-9A-Za-z]+$');

    if (cleanTag.isEmpty) return false;
    if (cleanTag.length < 3 || cleanTag.length > 12) return false;

    return tagRegex.hasMatch(cleanTag);
  }
}
