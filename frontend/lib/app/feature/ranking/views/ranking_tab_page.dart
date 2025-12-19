import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:clash_royale_history/app/feature/ranking/controllers/ranking_tab_controller.dart';
import 'package:clash_royale_history/app/api/models/location_model.dart';

class RankingTabPage extends GetView<RankingTabController> {
  const RankingTabPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('랭킹'),
          centerTitle: true,
          bottom: const TabBar(
            tabs: [
              Tab(text: '플레이어'),
              Tab(text: '클랜'),
              Tab(text: 'PoL'),
            ],
          ),
          actions: [
            Obx(() => PopupMenuButton<LocationDetail>(
                  icon: const Icon(Icons.location_on),
                  tooltip: '지역 선택',
                  onSelected: controller.selectLocation,
                  itemBuilder: (context) => controller.locations
                      .map((loc) => PopupMenuItem(
                            value: loc,
                            child: Row(
                              children: [
                                if (loc.id == controller.selectedLocation?.id)
                                  const Icon(Icons.check, size: 18),
                                if (loc.id != controller.selectedLocation?.id)
                                  const SizedBox(width: 18),
                                const SizedBox(width: 8),
                                Expanded(child: Text(loc.name)),
                              ],
                            ),
                          ))
                      .toList(),
                )),
          ],
        ),
        body: Obx(() {
          if (controller.selectedLocation == null) {
            return _buildLocationSelector();
          }

          return TabBarView(
            children: [
              _buildPlayerRankings(),
              _buildClanRankings(),
              _buildPathOfLegendRankings(),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildLocationSelector() {
    if (controller.isLocationsLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.public, size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            '지역을 선택하세요',
            style: TextStyle(color: Colors.grey.shade600),
          ),
          const SizedBox(height: 24),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: controller.locations.take(10).map((loc) {
              return ActionChip(
                label: Text(loc.name),
                onPressed: () => controller.selectLocation(loc),
              );
            }).toList(),
          ),
          if (controller.locations.length > 10) ...[
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => _showLocationPicker(),
              child: const Text('더 많은 지역 보기'),
            ),
          ],
        ],
      ),
    );
  }

  void _showLocationPicker() {
    Get.bottomSheet(
      Container(
        height: Get.height * 0.7,
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            const Text(
              '지역 선택',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: controller.locations.length,
                itemBuilder: (context, index) {
                  final loc = controller.locations[index];
                  return ListTile(
                    leading: loc.isCountry
                        ? const Icon(Icons.flag)
                        : const Icon(Icons.public),
                    title: Text(loc.name),
                    trailing: controller.selectedLocation?.id == loc.id
                        ? const Icon(Icons.check, color: Colors.green)
                        : null,
                    onTap: () {
                      controller.selectLocation(loc);
                      Get.back();
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayerRankings() {
    if (controller.isPlayerRankingsLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (controller.playerRankings.isEmpty) {
      return _buildEmptyState('플레이어 랭킹 정보가 없습니다', controller.loadPlayerRankings);
    }

    return RefreshIndicator(
      onRefresh: controller.loadPlayerRankings,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: controller.playerRankings.length,
        itemBuilder: (context, index) {
          final player = controller.playerRankings[index];
          return _buildPlayerRankingCard(player);
        },
      ),
    );
  }

  Widget _buildPlayerRankingCard(PlayerRanking player) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getRankColor(player.rank),
          child: Text(
            player.rank.toString(),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(player.name),
        subtitle: Text(player.tag),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.emoji_events, size: 16, color: Colors.amber),
            const SizedBox(width: 4),
            Text(
              player.trophies.toString(),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildClanRankings() {
    if (controller.isClanRankingsLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (controller.clanRankings.isEmpty) {
      return _buildEmptyState('클랜 랭킹 정보가 없습니다', controller.loadClanRankings);
    }

    return RefreshIndicator(
      onRefresh: controller.loadClanRankings,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: controller.clanRankings.length,
        itemBuilder: (context, index) {
          final clan = controller.clanRankings[index];
          return _buildClanRankingCard(clan);
        },
      ),
    );
  }

  Widget _buildClanRankingCard(ClanRanking clan) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getRankColor(clan.rank),
          child: Text(
            clan.rank.toString(),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(clan.name),
        subtitle: Text('${clan.tag} • ${clan.members}명'),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.stars, size: 16, color: Colors.amber),
                const SizedBox(width: 4),
                Text(
                  clan.clanScore.toString(),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPathOfLegendRankings() {
    if (controller.isPolRankingsLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (controller.polRankings.isEmpty) {
      return _buildEmptyState(
        'Path of Legend 랭킹 정보가 없습니다',
        controller.loadPathOfLegendRankings,
      );
    }

    return RefreshIndicator(
      onRefresh: controller.loadPathOfLegendRankings,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: controller.polRankings.length,
        itemBuilder: (context, index) {
          final player = controller.polRankings[index];
          return _buildPolRankingCard(player);
        },
      ),
    );
  }

  Widget _buildPolRankingCard(PathOfLegendRanking player) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getRankColor(player.rank),
          child: Text(
            player.rank.toString(),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(player.name),
        subtitle: Text(player.tag),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.military_tech, size: 16, color: Colors.purple),
                const SizedBox(width: 4),
                Text(
                  '${player.eloRating ?? 0}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(String message, VoidCallback onRefresh) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.leaderboard, size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(color: Colors.grey.shade600),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: onRefresh,
            child: const Text('새로고침'),
          ),
        ],
      ),
    );
  }

  Color _getRankColor(int rank) {
    if (rank == 1) return Colors.amber;
    if (rank == 2) return Colors.grey.shade400;
    if (rank == 3) return Colors.brown.shade400;
    if (rank <= 10) return Colors.blue;
    return Colors.grey;
  }
}
