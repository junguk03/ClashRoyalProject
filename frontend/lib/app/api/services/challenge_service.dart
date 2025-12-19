import 'package:get/get.dart';

import '../../components/logger/logger.dart';
import '../config/api_config.dart';
import '../core/api_client.dart';
import '../core/api_exceptions.dart';
import '../core/api_response.dart';
import '../models/challenge_model.dart';

/// 챌린지 정보 서비스
class ChallengeService extends GetxService {
  final ApiClient _apiClient = Get.find<ApiClient>();

  static ChallengeService get to => Get.find();

  /// 현재 진행 중인 챌린지 목록 조회
  Future<ApiResponse<List<Challenge>>> getChallenges() async {
    try {
      log.i('Fetching current challenges');

      final response = await _apiClient.get<List<Challenge>>(
        ApiConfig.challenges,
        fromJson: (json) {
          if (json['items'] != null) {
            return (json['items'] as List)
                .map((e) => Challenge.fromJson(e as Map<String, dynamic>))
                .toList();
          }
          if (json['data'] is List) {
            return (json['data'] as List)
                .map((e) => Challenge.fromJson(e as Map<String, dynamic>))
                .toList();
          }
          return <Challenge>[];
        },
      );

      if (response.success && response.data != null) {
        log.i('Found ${response.data!.length} challenges');
        return response;
      }

      throw ApiException('Challenges data not received');
    } on ApiException catch (e) {
      log.e('Failed to fetch challenges: ${e.message}');
      rethrow;
    } catch (e) {
      log.e('Unexpected error fetching challenges: $e');
      throw ApiException('Failed to fetch challenges: $e');
    }
  }

  /// 챌린지 ID로 챌린지 찾기
  Challenge? findChallengeById(List<Challenge> challenges, int id) {
    try {
      return challenges.firstWhere((challenge) => challenge.id == id);
    } catch (e) {
      return null;
    }
  }
}
