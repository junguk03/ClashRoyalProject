import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:clash_royale_history/app/api/services/player_service.dart';
import 'package:clash_royale_history/app/api/models/player_model.dart';
import 'package:clash_royale_history/app/api/models/battle_model.dart';
import 'package:clash_royale_history/app/api/models/chest_model.dart';
import 'package:clash_royale_history/app/components/logger/logger.dart';

class RecentSearch {
  final String tag;
  final String name;
  final DateTime searchedAt;

  RecentSearch({
    required this.tag,
    required this.name,
    required this.searchedAt,
  });

  Map<String, dynamic> toJson() => {
        'tag': tag,
        'name': name,
        'searchedAt': searchedAt.toIso8601String(),
      };

  factory RecentSearch.fromJson(Map<String, dynamic> json) => RecentSearch(
        tag: json['tag'] as String,
        name: json['name'] as String,
        searchedAt: DateTime.parse(json['searchedAt'] as String),
      );
}

class PlayerTabController extends GetxController {
  final PlayerService _playerService = Get.find<PlayerService>();
  final TextEditingController searchController = TextEditingController();

  final _player = Rxn<Player>();
  final _battleLog = <Battle>[].obs;
  final _upcomingChests = <Chest>[].obs;
  final _recentSearches = <RecentSearch>[].obs;

  final _isLoading = false.obs;
  final _isSearching = false.obs;
  final _isBattleLogLoading = false.obs;
  final _isChestsLoading = false.obs;
  final _errorMessage = ''.obs;

  Player? get player => _player.value;
  List<Battle> get battleLog => _battleLog;
  List<Chest> get upcomingChests => _upcomingChests;
  List<RecentSearch> get recentSearches => _recentSearches;

  bool get isLoading => _isLoading.value;
  bool get isSearching => _isSearching.value;
  bool get isBattleLogLoading => _isBattleLogLoading.value;
  bool get isChestsLoading => _isChestsLoading.value;
  String get errorMessage => _errorMessage.value;

  @override
  void onInit() {
    super.onInit();
    _loadRecentSearches();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  void _loadRecentSearches() {
    // TODO: SharedPreferences에서 최근 검색 기록 로드
  }

  void _saveRecentSearches() {
    // TODO: SharedPreferences에 최근 검색 기록 저장
  }

  void _addRecentSearch(Player player) {
    _recentSearches.removeWhere((s) => s.tag == player.tag);
    _recentSearches.insert(
      0,
      RecentSearch(
        tag: player.tag,
        name: player.name,
        searchedAt: DateTime.now(),
      ),
    );
    if (_recentSearches.length > 10) {
      _recentSearches.removeLast();
    }
    _saveRecentSearches();
  }

  void removeRecentSearch(int index) {
    _recentSearches.removeAt(index);
    _saveRecentSearches();
  }

  void clearRecentSearches() {
    _recentSearches.clear();
    _saveRecentSearches();
  }

  Future<void> searchPlayer() async {
    final tag = searchController.text.trim();
    if (tag.isEmpty) {
      _errorMessage.value = '플레이어 태그를 입력하세요';
      return;
    }
    await searchByTag(tag);
  }

  Future<void> searchByTag(String tag) async {
    _errorMessage.value = '';
    _isSearching.value = true;
    _isLoading.value = true;
    _player.value = null;
    _battleLog.clear();
    _upcomingChests.clear();

    try {
      final response = await _playerService.getPlayer(tag);
      if (response.success && response.data != null) {
        final result = response.data!;
        _player.value = result;
        searchController.text = result.tag;
        _addRecentSearch(result);
        _loadBattleLog(result.tag);
        _loadUpcomingChests(result.tag);
      } else {
        _errorMessage.value = '플레이어를 찾을 수 없습니다';
      }
    } catch (e) {
      log.e('Player search error: $e');
      _errorMessage.value = '검색 중 오류가 발생했습니다: ${e.toString()}';
    } finally {
      _isSearching.value = false;
      _isLoading.value = false;
    }
  }

  Future<void> refreshPlayer() async {
    if (_player.value == null) return;
    await searchByTag(_player.value!.tag);
  }

  Future<void> _loadBattleLog(String tag) async {
    _isBattleLogLoading.value = true;
    try {
      final response = await _playerService.getBattleLog(tag);
      if (response.success && response.data != null) {
        _battleLog.assignAll(response.data!);
      }
    } catch (e) {
      log.e('Battle log load error: $e');
    } finally {
      _isBattleLogLoading.value = false;
    }
  }

  Future<void> _loadUpcomingChests(String tag) async {
    _isChestsLoading.value = true;
    try {
      final response = await _playerService.getUpcomingChests(tag);
      if (response.success && response.data != null) {
        _upcomingChests.assignAll(response.data!.items);
      }
    } catch (e) {
      log.e('Upcoming chests load error: $e');
    } finally {
      _isChestsLoading.value = false;
    }
  }
}
