import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:clash_royale_history/app/feature/player/controllers/player_tab_controller.dart';

class PlayerTabPage extends GetView<PlayerTabController> {
  const PlayerTabPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('플레이어 검색'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: controller.searchController,
              decoration: InputDecoration(
                hintText: '플레이어 태그 입력 (예: #2ABC)',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: Obx(() => controller.isSearching
                    ? const Padding(
                        padding: EdgeInsets.all(12),
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      )
                    : IconButton(
                        icon: const Icon(Icons.send),
                        onPressed: controller.searchPlayer,
                      )),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey.shade100,
              ),
              onSubmitted: (_) => controller.searchPlayer(),
            ),
          ),
          Expanded(
            child: Obx(() => _buildContent()),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (controller.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (controller.errorMessage.isNotEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.red.shade300),
              const SizedBox(height: 16),
              Text(
                controller.errorMessage,
                style: TextStyle(color: Colors.red.shade700),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: controller.searchPlayer,
                child: const Text('다시 시도'),
              ),
            ],
          ),
        ),
      );
    }

    if (controller.player == null) {
      return _buildRecentSearches();
    }

    return _buildPlayerInfo();
  }

  Widget _buildRecentSearches() {
    if (controller.recentSearches.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              '플레이어 태그를 입력하여 검색하세요',
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '최근 검색',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: controller.clearRecentSearches,
                child: const Text('전체 삭제'),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: controller.recentSearches.length,
            itemBuilder: (context, index) {
              final search = controller.recentSearches[index];
              return ListTile(
                leading: const Icon(Icons.history),
                title: Text(search.name),
                subtitle: Text(search.tag),
                trailing: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => controller.removeRecentSearch(index),
                ),
                onTap: () => controller.searchByTag(search.tag),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPlayerInfo() {
    final player = controller.player!;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.blue.shade100,
                        child: Text(
                          player.expLevel.toString(),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              player.name,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              player.tag,
                              style: TextStyle(color: Colors.grey.shade600),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.refresh),
                        onPressed: controller.refreshPlayer,
                      ),
                    ],
                  ),
                  const Divider(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatItem('트로피', player.trophies.toString()),
                      _buildStatItem('최고 트로피', player.bestTrophies.toString()),
                      _buildStatItem('승리', player.wins.toString()),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          _buildSectionTitle('배틀 기록'),
          Obx(() => _buildBattleLogSection()),
          const SizedBox(height: 16),
          _buildSectionTitle('다가오는 상자'),
          Obx(() => _buildUpcomingChestsSection()),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(label, style: TextStyle(color: Colors.grey.shade600)),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildBattleLogSection() {
    if (controller.isBattleLogLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (controller.battleLog.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: Text(
              '배틀 기록이 없습니다',
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ),
        ),
      );
    }

    return Card(
      child: Column(
        children: controller.battleLog.take(5).map((battle) {
          final isWin = battle.team.isNotEmpty &&
              battle.opponent.isNotEmpty &&
              battle.team.first.crowns > battle.opponent.first.crowns;
          return ListTile(
            leading: Icon(
              isWin ? Icons.emoji_events : Icons.close,
              color: isWin ? Colors.amber : Colors.red,
            ),
            title: Text(battle.type),
            subtitle: Text(
              '${battle.team.first.crowns} - ${battle.opponent.first.crowns}',
            ),
            trailing: Text(
              _formatBattleTime(battle.battleTime),
              style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
            ),
          );
        }).toList(),
      ),
    );
  }

  String _formatBattleTime(String battleTime) {
    try {
      final date = DateTime.parse(battleTime);
      final now = DateTime.now();
      final diff = now.difference(date);
      if (diff.inMinutes < 60) {
        return '${diff.inMinutes}분 전';
      } else if (diff.inHours < 24) {
        return '${diff.inHours}시간 전';
      } else {
        return '${diff.inDays}일 전';
      }
    } catch (e) {
      return '';
    }
  }

  Widget _buildUpcomingChestsSection() {
    if (controller.isChestsLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (controller.upcomingChests.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: Text(
              '상자 정보가 없습니다',
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ),
        ),
      );
    }

    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: controller.upcomingChests.length,
        itemBuilder: (context, index) {
          final chest = controller.upcomingChests[index];
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inventory_2, color: Colors.amber.shade700),
                  const SizedBox(height: 4),
                  Text(
                    '+${chest.index}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    chest.name.replaceAll(' Chest', ''),
                    style: const TextStyle(fontSize: 10),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
