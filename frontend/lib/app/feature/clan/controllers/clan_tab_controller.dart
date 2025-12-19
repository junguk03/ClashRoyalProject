import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:clash_royale_history/app/api/services/clan_service.dart';
import 'package:clash_royale_history/app/api/models/clan_model.dart';
import 'package:clash_royale_history/app/components/logger/logger.dart';

class ClanTabController extends GetxController {
  final ClanService _clanService = Get.find<ClanService>();
  final TextEditingController searchController = TextEditingController();

  final _searchResults = <Clan>[].obs;
  final _selectedClan = Rxn<Clan>();
  final _clanMembers = <ClanMember>[].obs;
  final _warLog = <RiverRaceLogEntry>[].obs;

  final _isLoading = false.obs;
  final _isMembersLoading = false.obs;
  final _isWarLogLoading = false.obs;
  final _searchByTag = true.obs;
  final _errorMessage = ''.obs;

  List<Clan> get searchResults => _searchResults;
  Clan? get selectedClan => _selectedClan.value;
  List<ClanMember> get clanMembers => _clanMembers;
  List<RiverRaceLogEntry> get warLog => _warLog;

  bool get isLoading => _isLoading.value;
  bool get isMembersLoading => _isMembersLoading.value;
  bool get isWarLogLoading => _isWarLogLoading.value;
  bool get searchByTag => _searchByTag.value;
  String get errorMessage => _errorMessage.value;

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  void toggleSearchMode(bool byTag) {
    _searchByTag.value = byTag;
  }

  void clearSelection() {
    _selectedClan.value = null;
    _clanMembers.clear();
    _warLog.clear();
  }

  Future<void> searchClan() async {
    final query = searchController.text.trim();
    if (query.isEmpty) {
      _errorMessage.value = '검색어를 입력하세요';
      return;
    }

    _errorMessage.value = '';
    _isLoading.value = true;
    _searchResults.clear();
    clearSelection();

    try {
      if (_searchByTag.value) {
        final response = await _clanService.getClan(query);
        if (response.success && response.data != null) {
          final clan = response.data!;
          _selectedClan.value = clan;
          _loadClanMembers(clan.tag);
          _loadWarLog(clan.tag);
        } else {
          _errorMessage.value = '클랜을 찾을 수 없습니다';
        }
      } else {
        final response = await _clanService.searchClans(name: query, limit: 20);
        if (response.success && response.data != null && response.data!.items.isNotEmpty) {
          _searchResults.assignAll(response.data!.items);
        } else {
          _errorMessage.value = '검색 결과가 없습니다';
        }
      }
    } catch (e) {
      log.e('Clan search error: $e');
      _errorMessage.value = '검색 중 오류가 발생했습니다';
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> selectClan(String tag) async {
    _isLoading.value = true;
    _errorMessage.value = '';

    try {
      final response = await _clanService.getClan(tag);
      if (response.success && response.data != null) {
        final clan = response.data!;
        _selectedClan.value = clan;
        _loadClanMembers(clan.tag);
        _loadWarLog(clan.tag);
      } else {
        _errorMessage.value = '클랜 정보를 불러올 수 없습니다';
      }
    } catch (e) {
      log.e('Clan detail error: $e');
      _errorMessage.value = '클랜 정보를 불러오는 중 오류가 발생했습니다';
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> _loadClanMembers(String tag) async {
    _isMembersLoading.value = true;
    try {
      final response = await _clanService.getClanMembers(tag);
      if (response.success && response.data != null) {
        _clanMembers.assignAll(response.data!.items);
      }
    } catch (e) {
      log.e('Clan members load error: $e');
    } finally {
      _isMembersLoading.value = false;
    }
  }

  Future<void> _loadWarLog(String tag) async {
    _isWarLogLoading.value = true;
    try {
      final response = await _clanService.getRiverRaceLog(tag);
      if (response.success && response.data != null) {
        _warLog.assignAll(response.data!.items);
      }
    } catch (e) {
      log.e('War log load error: $e');
    } finally {
      _isWarLogLoading.value = false;
    }
  }
}
