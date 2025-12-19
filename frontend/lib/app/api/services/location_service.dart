import 'package:get/get.dart';

import '../../components/logger/logger.dart';
import '../config/api_config.dart';
import '../core/api_client.dart';
import '../core/api_exceptions.dart';
import '../core/api_response.dart';
import '../models/location_model.dart';

/// 위치/랭킹 정보 서비스
class LocationService extends GetxService {
  final ApiClient _apiClient = Get.find<ApiClient>();

  static LocationService get to => Get.find();

  /// 위치 목록 조회
  Future<ApiResponse<LocationsResponse>> getLocations({
    int? limit,
    String? after,
    String? before,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (limit != null) queryParams['limit'] = limit;
      if (after != null) queryParams['after'] = after;
      if (before != null) queryParams['before'] = before;

      log.i('Fetching locations');

      final response = await _apiClient.get<LocationsResponse>(
        ApiConfig.locations,
        queryParams: queryParams.isNotEmpty ? queryParams : null,
        fromJson: (json) => LocationsResponse.fromJson(json),
      );

      if (response.success && response.data != null) {
        log.i('Found ${response.data!.items.length} locations');
        return response;
      }

      throw ApiException('Locations data not received');
    } on ApiException catch (e) {
      log.e('Failed to fetch locations: ${e.message}');
      rethrow;
    } catch (e) {
      log.e('Unexpected error fetching locations: $e');
      throw ApiException('Failed to fetch locations: $e');
    }
  }

  /// 특정 위치 정보 조회
  Future<ApiResponse<LocationDetail>> getLocation(int locationId) async {
    try {
      final endpoint = ApiConfig.locationById(locationId);

      log.i('Fetching location: $locationId');

      final response = await _apiClient.get<LocationDetail>(
        endpoint,
        fromJson: (json) => LocationDetail.fromJson(json),
      );

      if (response.success && response.data != null) {
        log.i('Location found: ${response.data!.name}');
        return response;
      }

      throw ApiException('Location data not received');
    } on ApiException catch (e) {
      log.e('Failed to fetch location: ${e.message}');
      rethrow;
    } catch (e) {
      log.e('Unexpected error fetching location: $e');
      throw ApiException('Failed to fetch location: $e');
    }
  }

  /// 플레이어 랭킹 조회
  Future<ApiResponse<PlayerRankingsResponse>> getPlayerRankings(
    int locationId, {
    int? limit,
    String? after,
    String? before,
  }) async {
    try {
      final endpoint = ApiConfig.locationPlayerRankings(locationId);
      final queryParams = <String, dynamic>{};
      if (limit != null) queryParams['limit'] = limit;
      if (after != null) queryParams['after'] = after;
      if (before != null) queryParams['before'] = before;

      log.i('Fetching player rankings for location: $locationId');

      final response = await _apiClient.get<PlayerRankingsResponse>(
        endpoint,
        queryParams: queryParams.isNotEmpty ? queryParams : null,
        fromJson: (json) => PlayerRankingsResponse.fromJson(json),
      );

      if (response.success && response.data != null) {
        log.i('Found ${response.data!.items.length} player rankings');
        return response;
      }

      throw ApiException('Player rankings data not received');
    } on ApiException catch (e) {
      log.e('Failed to fetch player rankings: ${e.message}');
      rethrow;
    } catch (e) {
      log.e('Unexpected error fetching player rankings: $e');
      throw ApiException('Failed to fetch player rankings: $e');
    }
  }

  /// 클랜 랭킹 조회
  Future<ApiResponse<ClanRankingsResponse>> getClanRankings(
    int locationId, {
    int? limit,
    String? after,
    String? before,
  }) async {
    try {
      final endpoint = ApiConfig.locationClanRankings(locationId);
      final queryParams = <String, dynamic>{};
      if (limit != null) queryParams['limit'] = limit;
      if (after != null) queryParams['after'] = after;
      if (before != null) queryParams['before'] = before;

      log.i('Fetching clan rankings for location: $locationId');

      final response = await _apiClient.get<ClanRankingsResponse>(
        endpoint,
        queryParams: queryParams.isNotEmpty ? queryParams : null,
        fromJson: (json) => ClanRankingsResponse.fromJson(json),
      );

      if (response.success && response.data != null) {
        log.i('Found ${response.data!.items.length} clan rankings');
        return response;
      }

      throw ApiException('Clan rankings data not received');
    } on ApiException catch (e) {
      log.e('Failed to fetch clan rankings: ${e.message}');
      rethrow;
    } catch (e) {
      log.e('Unexpected error fetching clan rankings: $e');
      throw ApiException('Failed to fetch clan rankings: $e');
    }
  }

  /// 클랜 전쟁 랭킹 조회
  Future<ApiResponse<ClanWarRankingsResponse>> getClanWarRankings(
    int locationId, {
    int? limit,
    String? after,
    String? before,
  }) async {
    try {
      final endpoint = ApiConfig.locationClanWarRankings(locationId);
      final queryParams = <String, dynamic>{};
      if (limit != null) queryParams['limit'] = limit;
      if (after != null) queryParams['after'] = after;
      if (before != null) queryParams['before'] = before;

      log.i('Fetching clan war rankings for location: $locationId');

      final response = await _apiClient.get<ClanWarRankingsResponse>(
        endpoint,
        queryParams: queryParams.isNotEmpty ? queryParams : null,
        fromJson: (json) => ClanWarRankingsResponse.fromJson(json),
      );

      if (response.success && response.data != null) {
        log.i('Found ${response.data!.items.length} clan war rankings');
        return response;
      }

      throw ApiException('Clan war rankings data not received');
    } on ApiException catch (e) {
      log.e('Failed to fetch clan war rankings: ${e.message}');
      rethrow;
    } catch (e) {
      log.e('Unexpected error fetching clan war rankings: $e');
      throw ApiException('Failed to fetch clan war rankings: $e');
    }
  }

  /// Path of Legend 랭킹 조회
  Future<ApiResponse<PathOfLegendRankingsResponse>> getPathOfLegendRankings(
    int locationId, {
    String? seasonId,
    int? limit,
    String? after,
    String? before,
  }) async {
    try {
      final endpoint = ApiConfig.locationPathOfLegendRankings(locationId);
      final queryParams = <String, dynamic>{};
      if (seasonId != null) queryParams['seasonId'] = seasonId;
      if (limit != null) queryParams['limit'] = limit;
      if (after != null) queryParams['after'] = after;
      if (before != null) queryParams['before'] = before;

      log.i('Fetching path of legend rankings for location: $locationId');

      final response = await _apiClient.get<PathOfLegendRankingsResponse>(
        endpoint,
        queryParams: queryParams.isNotEmpty ? queryParams : null,
        fromJson: (json) => PathOfLegendRankingsResponse.fromJson(json),
      );

      if (response.success && response.data != null) {
        log.i('Found ${response.data!.items.length} path of legend rankings');
        return response;
      }

      throw ApiException('Path of legend rankings data not received');
    } on ApiException catch (e) {
      log.e('Failed to fetch path of legend rankings: ${e.message}');
      rethrow;
    } catch (e) {
      log.e('Unexpected error fetching path of legend rankings: $e');
      throw ApiException('Failed to fetch path of legend rankings: $e');
    }
  }

  /// 시즌 목록 조회
  Future<ApiResponse<SeasonsResponse>> getSeasons(
    int locationId, {
    int? limit,
    String? after,
    String? before,
  }) async {
    try {
      final endpoint = ApiConfig.locationSeasons(locationId);
      final queryParams = <String, dynamic>{};
      if (limit != null) queryParams['limit'] = limit;
      if (after != null) queryParams['after'] = after;
      if (before != null) queryParams['before'] = before;

      log.i('Fetching seasons for location: $locationId');

      final response = await _apiClient.get<SeasonsResponse>(
        endpoint,
        queryParams: queryParams.isNotEmpty ? queryParams : null,
        fromJson: (json) => SeasonsResponse.fromJson(json),
      );

      if (response.success && response.data != null) {
        log.i('Found ${response.data!.items.length} seasons');
        return response;
      }

      throw ApiException('Seasons data not received');
    } on ApiException catch (e) {
      log.e('Failed to fetch seasons: ${e.message}');
      rethrow;
    } catch (e) {
      log.e('Unexpected error fetching seasons: $e');
      throw ApiException('Failed to fetch seasons: $e');
    }
  }

  /// 시즌별 플레이어 랭킹 조회
  Future<ApiResponse<PlayerRankingsResponse>> getSeasonPlayerRankings(
    int locationId,
    String seasonId, {
    int? limit,
    String? after,
    String? before,
  }) async {
    try {
      final endpoint = ApiConfig.locationSeasonPlayerRankings(locationId, seasonId);
      final queryParams = <String, dynamic>{};
      if (limit != null) queryParams['limit'] = limit;
      if (after != null) queryParams['after'] = after;
      if (before != null) queryParams['before'] = before;

      log.i('Fetching season $seasonId player rankings for location: $locationId');

      final response = await _apiClient.get<PlayerRankingsResponse>(
        endpoint,
        queryParams: queryParams.isNotEmpty ? queryParams : null,
        fromJson: (json) => PlayerRankingsResponse.fromJson(json),
      );

      if (response.success && response.data != null) {
        log.i('Found ${response.data!.items.length} season player rankings');
        return response;
      }

      throw ApiException('Season player rankings data not received');
    } on ApiException catch (e) {
      log.e('Failed to fetch season player rankings: ${e.message}');
      rethrow;
    } catch (e) {
      log.e('Unexpected error fetching season player rankings: $e');
      throw ApiException('Failed to fetch season player rankings: $e');
    }
  }

  /// 글로벌 토너먼트 랭킹 조회
  Future<ApiResponse<GlobalTournamentRankingsResponse>>
      getGlobalTournamentRankings(
    String tournamentTag, {
    int? limit,
    String? after,
    String? before,
  }) async {
    try {
      final endpoint = ApiConfig.locationGlobalTournamentRankings(tournamentTag);
      final queryParams = <String, dynamic>{};
      if (limit != null) queryParams['limit'] = limit;
      if (after != null) queryParams['after'] = after;
      if (before != null) queryParams['before'] = before;

      log.i('Fetching global tournament rankings for: $tournamentTag');

      final response = await _apiClient.get<GlobalTournamentRankingsResponse>(
        endpoint,
        queryParams: queryParams.isNotEmpty ? queryParams : null,
        fromJson: (json) => GlobalTournamentRankingsResponse.fromJson(json),
      );

      if (response.success && response.data != null) {
        log.i('Found ${response.data!.items.length} global tournament rankings');
        return response;
      }

      throw ApiException('Global tournament rankings data not received');
    } on ApiException catch (e) {
      log.e('Failed to fetch global tournament rankings: ${e.message}');
      rethrow;
    } catch (e) {
      log.e('Unexpected error fetching global tournament rankings: $e');
      throw ApiException('Failed to fetch global tournament rankings: $e');
    }
  }

  /// Path of Legend 시즌 목록 조회
  Future<ApiResponse<SeasonsResponse>> getPathOfLegendSeasons(
    int locationId, {
    int? limit,
    String? after,
    String? before,
  }) async {
    try {
      final endpoint = ApiConfig.locationPathOfLegendSeasons(locationId);
      final queryParams = <String, dynamic>{};
      if (limit != null) queryParams['limit'] = limit;
      if (after != null) queryParams['after'] = after;
      if (before != null) queryParams['before'] = before;

      log.i('Fetching path of legend seasons for location: $locationId');

      final response = await _apiClient.get<SeasonsResponse>(
        endpoint,
        queryParams: queryParams.isNotEmpty ? queryParams : null,
        fromJson: (json) => SeasonsResponse.fromJson(json),
      );

      if (response.success && response.data != null) {
        log.i('Found ${response.data!.items.length} path of legend seasons');
        return response;
      }

      throw ApiException('Path of legend seasons data not received');
    } on ApiException catch (e) {
      log.e('Failed to fetch path of legend seasons: ${e.message}');
      rethrow;
    } catch (e) {
      log.e('Unexpected error fetching path of legend seasons: $e');
      throw ApiException('Failed to fetch path of legend seasons: $e');
    }
  }

  /// Path of Legend 시즌별 랭킹 조회
  Future<ApiResponse<PathOfLegendRankingsResponse>>
      getPathOfLegendSeasonRankings(
    int locationId,
    String seasonId, {
    int? limit,
    String? after,
    String? before,
  }) async {
    try {
      final endpoint =
          ApiConfig.locationPathOfLegendSeasonRankings(locationId, seasonId);
      final queryParams = <String, dynamic>{};
      if (limit != null) queryParams['limit'] = limit;
      if (after != null) queryParams['after'] = after;
      if (before != null) queryParams['before'] = before;

      log.i(
          'Fetching path of legend season $seasonId rankings for location: $locationId');

      final response = await _apiClient.get<PathOfLegendRankingsResponse>(
        endpoint,
        queryParams: queryParams.isNotEmpty ? queryParams : null,
        fromJson: (json) => PathOfLegendRankingsResponse.fromJson(json),
      );

      if (response.success && response.data != null) {
        log.i(
            'Found ${response.data!.items.length} path of legend season rankings');
        return response;
      }

      throw ApiException('Path of legend season rankings data not received');
    } on ApiException catch (e) {
      log.e('Failed to fetch path of legend season rankings: ${e.message}');
      rethrow;
    } catch (e) {
      log.e('Unexpected error fetching path of legend season rankings: $e');
      throw ApiException('Failed to fetch path of legend season rankings: $e');
    }
  }

  // =====================
  // Global Seasons
  // =====================

  /// 글로벌 시즌 목록 조회
  Future<ApiResponse<SeasonsResponse>> getGlobalSeasons({
    int? limit,
    String? after,
    String? before,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (limit != null) queryParams['limit'] = limit;
      if (after != null) queryParams['after'] = after;
      if (before != null) queryParams['before'] = before;

      log.i('Fetching global seasons');

      final response = await _apiClient.get<SeasonsResponse>(
        ApiConfig.globalSeasons,
        queryParams: queryParams.isNotEmpty ? queryParams : null,
        fromJson: (json) => SeasonsResponse.fromJson(json),
      );

      if (response.success && response.data != null) {
        log.i('Found ${response.data!.items.length} global seasons');
        return response;
      }

      throw ApiException('Global seasons data not received');
    } on ApiException catch (e) {
      log.e('Failed to fetch global seasons: ${e.message}');
      rethrow;
    } catch (e) {
      log.e('Unexpected error fetching global seasons: $e');
      throw ApiException('Failed to fetch global seasons: $e');
    }
  }

  /// 글로벌 시즌 V2 목록 조회
  Future<ApiResponse<SeasonsResponse>> getGlobalSeasonsV2({
    int? limit,
    String? after,
    String? before,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (limit != null) queryParams['limit'] = limit;
      if (after != null) queryParams['after'] = after;
      if (before != null) queryParams['before'] = before;

      log.i('Fetching global seasons V2');

      final response = await _apiClient.get<SeasonsResponse>(
        ApiConfig.globalSeasonsV2,
        queryParams: queryParams.isNotEmpty ? queryParams : null,
        fromJson: (json) => SeasonsResponse.fromJson(json),
      );

      if (response.success && response.data != null) {
        log.i('Found ${response.data!.items.length} global seasons V2');
        return response;
      }

      throw ApiException('Global seasons V2 data not received');
    } on ApiException catch (e) {
      log.e('Failed to fetch global seasons V2: ${e.message}');
      rethrow;
    } catch (e) {
      log.e('Unexpected error fetching global seasons V2: $e');
      throw ApiException('Failed to fetch global seasons V2: $e');
    }
  }

  /// 글로벌 시즌 상세 조회
  Future<ApiResponse<Season>> getGlobalSeason(String seasonId) async {
    try {
      final endpoint = ApiConfig.globalSeasonById(seasonId);

      log.i('Fetching global season: $seasonId');

      final response = await _apiClient.get<Season>(
        endpoint,
        fromJson: (json) => Season.fromJson(json),
      );

      if (response.success && response.data != null) {
        log.i('Global season found: ${response.data!.id}');
        return response;
      }

      throw ApiException('Global season data not received');
    } on ApiException catch (e) {
      log.e('Failed to fetch global season: ${e.message}');
      rethrow;
    } catch (e) {
      log.e('Unexpected error fetching global season: $e');
      throw ApiException('Failed to fetch global season: $e');
    }
  }

  /// 글로벌 시즌별 플레이어 랭킹 조회
  Future<ApiResponse<PlayerRankingsResponse>> getGlobalSeasonPlayerRankings(
    String seasonId, {
    int? limit,
    String? after,
    String? before,
  }) async {
    try {
      final endpoint = ApiConfig.globalSeasonPlayerRankings(seasonId);
      final queryParams = <String, dynamic>{};
      if (limit != null) queryParams['limit'] = limit;
      if (after != null) queryParams['after'] = after;
      if (before != null) queryParams['before'] = before;

      log.i('Fetching global season $seasonId player rankings');

      final response = await _apiClient.get<PlayerRankingsResponse>(
        endpoint,
        queryParams: queryParams.isNotEmpty ? queryParams : null,
        fromJson: (json) => PlayerRankingsResponse.fromJson(json),
      );

      if (response.success && response.data != null) {
        log.i('Found ${response.data!.items.length} global season player rankings');
        return response;
      }

      throw ApiException('Global season player rankings data not received');
    } on ApiException catch (e) {
      log.e('Failed to fetch global season player rankings: ${e.message}');
      rethrow;
    } catch (e) {
      log.e('Unexpected error fetching global season player rankings: $e');
      throw ApiException('Failed to fetch global season player rankings: $e');
    }
  }

  /// 글로벌 Path of Legend 랭킹 조회
  Future<ApiResponse<PathOfLegendRankingsResponse>> getGlobalPathOfLegendRankings(
    String seasonId, {
    int? limit,
    String? after,
    String? before,
  }) async {
    try {
      final endpoint = ApiConfig.globalPathOfLegendRankings(seasonId);
      final queryParams = <String, dynamic>{};
      if (limit != null) queryParams['limit'] = limit;
      if (after != null) queryParams['after'] = after;
      if (before != null) queryParams['before'] = before;

      log.i('Fetching global path of legend rankings for season: $seasonId');

      final response = await _apiClient.get<PathOfLegendRankingsResponse>(
        endpoint,
        queryParams: queryParams.isNotEmpty ? queryParams : null,
        fromJson: (json) => PathOfLegendRankingsResponse.fromJson(json),
      );

      if (response.success && response.data != null) {
        log.i('Found ${response.data!.items.length} global path of legend rankings');
        return response;
      }

      throw ApiException('Global path of legend rankings data not received');
    } on ApiException catch (e) {
      log.e('Failed to fetch global path of legend rankings: ${e.message}');
      rethrow;
    } catch (e) {
      log.e('Unexpected error fetching global path of legend rankings: $e');
      throw ApiException('Failed to fetch global path of legend rankings: $e');
    }
  }
}
