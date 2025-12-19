import 'package:get/get.dart';

import '../../components/logger/logger.dart';
import '../config/api_config.dart';
import '../core/api_client.dart';
import '../core/api_exceptions.dart';
import '../core/api_response.dart';
import '../models/common_model.dart';
import '../models/tournament_model.dart';

/// 토너먼트 정보 서비스
class TournamentService extends GetxService {
  final ApiClient _apiClient = Get.find<ApiClient>();

  static TournamentService get to => Get.find();

  /// 토너먼트 검색
  Future<ApiResponse<PaginatedResponse<TournamentHeader>>> searchTournaments({
    String? name,
    int? limit,
    String? after,
    String? before,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (name != null) queryParams['name'] = name;
      if (limit != null) queryParams['limit'] = limit;
      if (after != null) queryParams['after'] = after;
      if (before != null) queryParams['before'] = before;

      log.i('Searching tournaments with params: $queryParams');

      final response =
          await _apiClient.get<PaginatedResponse<TournamentHeader>>(
        ApiConfig.tournaments,
        queryParams: queryParams.isNotEmpty ? queryParams : null,
        fromJson: (json) {
          final items = json['items'] != null
              ? (json['items'] as List)
                  .map((e) =>
                      TournamentHeader.fromJson(e as Map<String, dynamic>))
                  .toList()
              : <TournamentHeader>[];
          final paging =
              json['paging'] != null ? Paging.fromJson(json['paging']) : null;
          return PaginatedResponse<TournamentHeader>(
            items: items,
            paging: paging,
          );
        },
      );

      if (response.success && response.data != null) {
        log.i('Found ${response.data!.items.length} tournaments');
        return response;
      }

      throw ApiException('Tournament search data not received');
    } on ApiException catch (e) {
      log.e('Failed to search tournaments: ${e.message}');
      rethrow;
    } catch (e) {
      log.e('Unexpected error searching tournaments: $e');
      throw ApiException('Failed to search tournaments: $e');
    }
  }

  /// 토너먼트 상세 정보 조회
  Future<ApiResponse<Tournament>> getTournament(String tournamentTag) async {
    try {
      final endpoint = ApiConfig.tournamentByTag(tournamentTag);

      log.i('Fetching tournament info for tag: $tournamentTag');

      final response = await _apiClient.get<Tournament>(
        endpoint,
        fromJson: (json) => Tournament.fromJson(json),
      );

      if (response.success && response.data != null) {
        final tournament = response.data!;
        log.i('Tournament found: ${tournament.name} (${tournament.tag})');
        return response;
      }

      throw ApiException('Tournament data not received');
    } on ApiException catch (e) {
      log.e('Failed to fetch tournament: ${e.message}');
      rethrow;
    } catch (e) {
      log.e('Unexpected error fetching tournament: $e');
      throw ApiException('Failed to fetch tournament: $e');
    }
  }

  /// 글로벌 토너먼트 목록 조회
  Future<ApiResponse<List<LadderTournament>>> getGlobalTournaments() async {
    try {
      log.i('Fetching global tournaments');

      final response = await _apiClient.get<List<LadderTournament>>(
        ApiConfig.globalTournaments,
        fromJson: (json) {
          if (json['items'] != null) {
            return (json['items'] as List)
                .map((e) =>
                    LadderTournament.fromJson(e as Map<String, dynamic>))
                .toList();
          }
          return <LadderTournament>[];
        },
      );

      if (response.success && response.data != null) {
        log.i('Found ${response.data!.length} global tournaments');
        return response;
      }

      throw ApiException('Global tournaments data not received');
    } on ApiException catch (e) {
      log.e('Failed to fetch global tournaments: ${e.message}');
      rethrow;
    } catch (e) {
      log.e('Unexpected error fetching global tournaments: $e');
      throw ApiException('Failed to fetch global tournaments: $e');
    }
  }

  /// 토너먼트 태그 유효성 검사
  bool isValidTag(String tag) {
    final cleanTag = tag.startsWith('#') ? tag.substring(1) : tag;
    final tagRegex = RegExp(r'^[0-9A-Za-z]+$');

    if (cleanTag.isEmpty) return false;
    if (cleanTag.length < 3 || cleanTag.length > 12) return false;

    return tagRegex.hasMatch(cleanTag);
  }
}
