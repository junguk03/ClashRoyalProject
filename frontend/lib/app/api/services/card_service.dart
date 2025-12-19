import 'package:get/get.dart';

import '../../components/logger/logger.dart';
import '../config/api_config.dart';
import '../core/api_client.dart';
import '../core/api_exceptions.dart';
import '../core/api_response.dart';
import '../models/card_model.dart';

/// 카드 정보 서비스
class CardService extends GetxService {
  final ApiClient _apiClient = Get.find<ApiClient>();

  static CardService get to => Get.find();

  /// 전체 카드 목록 조회
  Future<ApiResponse<CardsResponse>> getCards() async {
    try {
      log.i('Fetching all cards');

      final response = await _apiClient.get<CardsResponse>(
        ApiConfig.cards,
        fromJson: (json) => CardsResponse.fromJson(json),
      );

      if (response.success && response.data != null) {
        log.i('Found ${response.data!.items.length} cards');
        return response;
      }

      throw ApiException('Cards data not received');
    } on ApiException catch (e) {
      log.e('Failed to fetch cards: ${e.message}');
      rethrow;
    } catch (e) {
      log.e('Unexpected error fetching cards: $e');
      throw ApiException('Failed to fetch cards: $e');
    }
  }

  /// 카드 ID로 카드 찾기 (로컬 캐시에서)
  Card? findCardById(List<Card> cards, int id) {
    try {
      return cards.firstWhere((card) => card.id == id);
    } catch (e) {
      return null;
    }
  }

  /// 카드 이름으로 카드 찾기 (로컬 캐시에서)
  Card? findCardByName(List<Card> cards, String name) {
    try {
      return cards.firstWhere(
        (card) => card.name.toLowerCase() == name.toLowerCase(),
      );
    } catch (e) {
      return null;
    }
  }

  /// 희귀도별 카드 필터링
  List<Card> filterByRarity(List<Card> cards, String rarity) {
    return cards
        .where((card) =>
            card.rarity?.toLowerCase() == rarity.toLowerCase())
        .toList();
  }

  /// 엘릭서 비용별 카드 필터링
  List<Card> filterByElixirCost(List<Card> cards, int cost) {
    return cards.where((card) => card.elixirCost == cost).toList();
  }
}
