import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:clash_royale_history/app/api/services/challenge_service.dart';
import 'package:clash_royale_history/app/api/services/tournament_service.dart';
import 'package:clash_royale_history/app/api/models/challenge_model.dart';
import 'package:clash_royale_history/app/api/models/tournament_model.dart';
import 'package:clash_royale_history/app/components/logger/logger.dart';

class ChallengeTabController extends GetxController {
  final ChallengeService _challengeService = Get.find<ChallengeService>();
  final TournamentService _tournamentService = Get.find<TournamentService>();
  final TextEditingController tournamentSearchController = TextEditingController();

  final _challenges = <Challenge>[].obs;
  final _globalTournaments = <LadderTournament>[].obs;
  final _tournamentSearchResults = <TournamentHeader>[].obs;

  final _isChallengesLoading = false.obs;
  final _isGlobalTournamentsLoading = false.obs;
  final _isTournamentSearching = false.obs;
  final _tournamentErrorMessage = ''.obs;

  List<Challenge> get challenges => _challenges;
  List<LadderTournament> get globalTournaments => _globalTournaments;
  List<TournamentHeader> get tournamentSearchResults => _tournamentSearchResults;

  bool get isChallengesLoading => _isChallengesLoading.value;
  bool get isGlobalTournamentsLoading => _isGlobalTournamentsLoading.value;
  bool get isTournamentSearching => _isTournamentSearching.value;
  String get tournamentErrorMessage => _tournamentErrorMessage.value;

  @override
  void onInit() {
    super.onInit();
    loadChallenges();
    loadGlobalTournaments();
  }

  @override
  void onClose() {
    tournamentSearchController.dispose();
    super.onClose();
  }

  Future<void> loadChallenges() async {
    _isChallengesLoading.value = true;
    try {
      final response = await _challengeService.getChallenges();
      if (response.success && response.data != null) {
        _challenges.assignAll(response.data!);
      }
    } catch (e) {
      log.e('Challenges load error: $e');
    } finally {
      _isChallengesLoading.value = false;
    }
  }

  Future<void> loadGlobalTournaments() async {
    _isGlobalTournamentsLoading.value = true;
    try {
      final response = await _tournamentService.getGlobalTournaments();
      if (response.success && response.data != null) {
        _globalTournaments.assignAll(response.data!);
      }
    } catch (e) {
      log.e('Global tournaments load error: $e');
    } finally {
      _isGlobalTournamentsLoading.value = false;
    }
  }

  Future<void> searchTournaments() async {
    final name = tournamentSearchController.text.trim();
    if (name.isEmpty) {
      _tournamentErrorMessage.value = '토너먼트 이름을 입력하세요';
      return;
    }

    _tournamentErrorMessage.value = '';
    _isTournamentSearching.value = true;
    _tournamentSearchResults.clear();

    try {
      final response = await _tournamentService.searchTournaments(name: name);
      if (response.success && response.data != null && response.data!.items.isNotEmpty) {
        _tournamentSearchResults.assignAll(response.data!.items);
      } else {
        _tournamentErrorMessage.value = '검색 결과가 없습니다';
      }
    } catch (e) {
      log.e('Tournament search error: $e');
      _tournamentErrorMessage.value = '검색 중 오류가 발생했습니다';
    } finally {
      _isTournamentSearching.value = false;
    }
  }

  Future<void> viewTournamentDetail(String tag) async {
    try {
      final response = await _tournamentService.getTournament(tag);
      if (response.success && response.data != null) {
        final tournament = response.data!;
        Get.dialog(
          AlertDialog(
            title: Text(tournament.name),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDetailRow('태그', tournament.tag),
                  _buildDetailRow('타입', tournament.type),
                  _buildDetailRow('상태', tournament.status),
                  _buildDetailRow('참가자', '${tournament.capacity}명'),
                  _buildDetailRow('최대 인원', '${tournament.maxCapacity}명'),
                  if (tournament.preparationDuration != null)
                    _buildDetailRow('준비 시간', '${tournament.preparationDuration}분'),
                  if (tournament.duration != null)
                    _buildDetailRow('진행 시간', '${tournament.duration}분'),
                  if (tournament.description != null && tournament.description!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Text(
                        tournament.description!,
                        style: TextStyle(color: Colors.grey.shade700),
                      ),
                    ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Get.back(),
                child: const Text('닫기'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      log.e('Tournament detail error: $e');
      Get.snackbar('오류', '토너먼트 정보를 불러올 수 없습니다');
    }
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}
