import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:clash_royale_history/app/feature/challenge/controllers/challenge_tab_controller.dart';
import 'package:clash_royale_history/app/api/models/challenge_model.dart';
import 'package:clash_royale_history/app/api/models/tournament_model.dart';

class ChallengeTabPage extends GetView<ChallengeTabController> {
  const ChallengeTabPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('챌린지 / 토너먼트'),
          centerTitle: true,
          bottom: const TabBar(
            tabs: [
              Tab(text: '챌린지'),
              Tab(text: '글로벌'),
              Tab(text: '토너먼트'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildChallengesTab(),
            _buildGlobalTournamentsTab(),
            _buildTournamentSearchTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildChallengesTab() {
    return Obx(() {
      if (controller.isChallengesLoading) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.challenges.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.event_busy, size: 64, color: Colors.grey.shade400),
              const SizedBox(height: 16),
              Text(
                '현재 진행 중인 챌린지가 없습니다',
                style: TextStyle(color: Colors.grey.shade600),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: controller.loadChallenges,
                child: const Text('새로고침'),
              ),
            ],
          ),
        );
      }

      return RefreshIndicator(
        onRefresh: controller.loadChallenges,
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.challenges.length,
          itemBuilder: (context, index) {
            final challenge = controller.challenges[index];
            return _buildChallengeCard(challenge);
          },
        ),
      );
    });
  }

  Widget _buildChallengeCard(Challenge challenge) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (challenge.gameMode != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade100,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      challenge.gameMode!.name,
                      style: TextStyle(
                        color: Colors.blue.shade700,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                const Spacer(),
                if (challenge.maxWins != null)
                  Row(
                    children: [
                      const Icon(Icons.emoji_events, size: 16, color: Colors.amber),
                      const SizedBox(width: 4),
                      Text('${challenge.maxWins}승'),
                    ],
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              challenge.name,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (challenge.description != null) ...[
              const SizedBox(height: 8),
              Text(
                challenge.description!,
                style: TextStyle(color: Colors.grey.shade700),
              ),
            ],
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (challenge.maxLosses != null)
                  _buildInfoChip(
                    Icons.close,
                    '${challenge.maxLosses}패 탈락',
                    Colors.red,
                  ),
                if (challenge.winMode != null)
                  _buildInfoChip(
                    Icons.sports_esports,
                    challenge.winModeText,
                    Colors.purple,
                  ),
                if (challenge.casualWins != null)
                  _buildInfoChip(
                    Icons.sentiment_satisfied,
                    '캐주얼 ${challenge.casualWins}승',
                    Colors.green,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(color: color, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildGlobalTournamentsTab() {
    return Obx(() {
      if (controller.isGlobalTournamentsLoading) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.globalTournaments.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.public_off, size: 64, color: Colors.grey.shade400),
              const SizedBox(height: 16),
              Text(
                '현재 진행 중인 글로벌 토너먼트가 없습니다',
                style: TextStyle(color: Colors.grey.shade600),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: controller.loadGlobalTournaments,
                child: const Text('새로고침'),
              ),
            ],
          ),
        );
      }

      return RefreshIndicator(
        onRefresh: controller.loadGlobalTournaments,
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.globalTournaments.length,
          itemBuilder: (context, index) {
            final tournament = controller.globalTournaments[index];
            return _buildGlobalTournamentCard(tournament);
          },
        ),
      );
    });
  }

  Widget _buildGlobalTournamentCard(LadderTournament tournament) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.public, color: Colors.blue),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    tournament.title ?? 'Global Tournament',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                if (tournament.maxWins != null)
                  _buildTournamentStat(
                    Icons.emoji_events,
                    '${tournament.maxWins}승',
                  ),
                const SizedBox(width: 16),
                if (tournament.maxLosses != null)
                  _buildTournamentStat(
                    Icons.close,
                    '${tournament.maxLosses}패 탈락',
                  ),
              ],
            ),
            if (tournament.startTime != null || tournament.endTime != null) ...[
              const Divider(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (tournament.startTime != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '시작',
                          style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                        ),
                        Text(_formatDateTime(tournament.startTime!)),
                      ],
                    ),
                  if (tournament.endTime != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '종료',
                          style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                        ),
                        Text(_formatDateTime(tournament.endTime!)),
                      ],
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTournamentStat(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.amber),
        const SizedBox(width: 4),
        Text(text),
      ],
    );
  }

  String _formatDateTime(String dateTimeStr) {
    try {
      final dt = DateTime.parse(dateTimeStr);
      return '${dt.month}/${dt.day} ${dt.hour}:${dt.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return dateTimeStr;
    }
  }

  Widget _buildTournamentSearchTab() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            controller: controller.tournamentSearchController,
            decoration: InputDecoration(
              hintText: '토너먼트 이름 검색',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: Obx(() => controller.isTournamentSearching
                  ? const Padding(
                      padding: EdgeInsets.all(12),
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    )
                  : IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: controller.searchTournaments,
                    )),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.grey.shade100,
            ),
            onSubmitted: (_) => controller.searchTournaments(),
          ),
        ),
        Expanded(
          child: Obx(() => _buildTournamentSearchResults()),
        ),
      ],
    );
  }

  Widget _buildTournamentSearchResults() {
    if (controller.isTournamentSearching) {
      return const Center(child: CircularProgressIndicator());
    }

    if (controller.tournamentErrorMessage.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red.shade300),
            const SizedBox(height: 16),
            Text(
              controller.tournamentErrorMessage,
              style: TextStyle(color: Colors.red.shade700),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    if (controller.tournamentSearchResults.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              '토너먼트를 검색하세요',
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: controller.tournamentSearchResults.length,
      itemBuilder: (context, index) {
        final tournament = controller.tournamentSearchResults[index];
        return _buildTournamentResultCard(tournament);
      },
    );
  }

  Widget _buildTournamentResultCard(TournamentHeader tournament) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getStatusColor(tournament.status ?? ''),
          child: Icon(
            _getStatusIcon(tournament.status ?? ''),
            color: Colors.white,
            size: 20,
          ),
        ),
        title: Text(tournament.name),
        subtitle: Text(
          '${tournament.tag} • ${tournament.capacity ?? 0}명',
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              tournament.type ?? '',
              style: const TextStyle(fontSize: 12),
            ),
            Text(
              _getStatusText(tournament.status ?? ''),
              style: TextStyle(
                fontSize: 12,
                color: _getStatusColor(tournament.status ?? ''),
              ),
            ),
          ],
        ),
        onTap: () => controller.viewTournamentDetail(tournament.tag),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'inprogress':
        return Colors.green;
      case 'ended':
        return Colors.grey;
      case 'open':
        return Colors.blue;
      default:
        return Colors.orange;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'inprogress':
        return Icons.play_arrow;
      case 'ended':
        return Icons.stop;
      case 'open':
        return Icons.lock_open;
      default:
        return Icons.schedule;
    }
  }

  String _getStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'inprogress':
        return '진행중';
      case 'ended':
        return '종료됨';
      case 'open':
        return '참가 가능';
      default:
        return status;
    }
  }
}
