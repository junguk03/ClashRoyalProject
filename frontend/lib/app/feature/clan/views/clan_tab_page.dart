import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:clash_royale_history/app/feature/clan/controllers/clan_tab_controller.dart';
import 'package:clash_royale_history/app/api/models/clan_model.dart';

class ClanTabPage extends GetView<ClanTabController> {
  const ClanTabPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('클랜 검색'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller.searchController,
                    decoration: InputDecoration(
                      hintText: '클랜 태그 또는 이름 검색',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                    ),
                    onSubmitted: (_) => controller.searchClan(),
                  ),
                ),
                const SizedBox(width: 8),
                Obx(() => ToggleButtons(
                      isSelected: [
                        controller.searchByTag,
                        !controller.searchByTag,
                      ],
                      onPressed: (index) => controller.toggleSearchMode(index == 0),
                      borderRadius: BorderRadius.circular(8),
                      children: const [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: Text('태그'),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: Text('이름'),
                        ),
                      ],
                    )),
              ],
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
          ],
        ),
      );
    }

    if (controller.selectedClan != null) {
      return _buildClanDetail(controller.selectedClan!);
    }

    if (controller.searchResults.isNotEmpty) {
      return _buildSearchResults();
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.groups, size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            '클랜을 검색하세요',
            style: TextStyle(color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: controller.searchResults.length,
      itemBuilder: (context, index) {
        final clan = controller.searchResults[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blue.shade100,
              child: Text(
                clan.clanScore.toString(),
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ),
            title: Text(clan.name),
            subtitle: Text('${clan.tag} • ${clan.members}/50'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => controller.selectClan(clan.tag),
          ),
        );
      },
    );
  }

  Widget _buildClanDetail(Clan clan) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: controller.clearSelection,
              ),
              Expanded(
                child: Text(
                  clan.name,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () => controller.selectClan(clan.tag),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatItem('클랜 점수', clan.clanScore.toString()),
                      _buildStatItem('멤버', '${clan.members}/50'),
                      _buildStatItem('필요 트로피', clan.requiredTrophies.toString()),
                    ],
                  ),
                  const Divider(height: 24),
                  Text(
                    clan.tag,
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                  if (clan.description != null && clan.description!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        clan.description!,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey.shade700),
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          _buildSectionTitle('멤버 목록'),
          Obx(() => _buildMemberList()),
          const SizedBox(height: 16),
          _buildSectionTitle('클랜 전쟁 기록'),
          Obx(() => _buildWarLogSection()),
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

  Widget _buildMemberList() {
    if (controller.isMembersLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (controller.clanMembers.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: Text(
              '멤버 정보가 없습니다',
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ),
        ),
      );
    }

    return Card(
      child: Column(
        children: controller.clanMembers.take(10).map((member) {
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: _getRoleColor(member.role),
              radius: 16,
              child: Text(
                member.expLevel.toString(),
                style: const TextStyle(fontSize: 12, color: Colors.white),
              ),
            ),
            title: Text(member.name),
            subtitle: Text(_getRoleText(member.role)),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.emoji_events, size: 16, color: Colors.amber),
                const SizedBox(width: 4),
                Text(member.trophies.toString()),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  String _getRoleText(String role) {
    switch (role.toLowerCase()) {
      case 'leader':
        return '리더';
      case 'coleader':
        return '공동 리더';
      case 'elder':
        return '장로';
      default:
        return '멤버';
    }
  }

  Color _getRoleColor(String role) {
    switch (role.toLowerCase()) {
      case 'leader':
        return Colors.amber;
      case 'coleader':
        return Colors.purple;
      case 'elder':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  Widget _buildWarLogSection() {
    if (controller.isWarLogLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (controller.warLog.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: Text(
              '전쟁 기록이 없습니다',
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ),
        ),
      );
    }

    return Card(
      child: Column(
        children: controller.warLog.take(5).map((war) {
          final standings = war.standings;
          final standingIndex = standings?.indexWhere(
            (s) => s.tag == controller.selectedClan?.tag,
          );
          final standing = (standingIndex != null && standingIndex >= 0)
              ? standings![standingIndex]
              : null;
          final rank = (standingIndex != null && standingIndex >= 0)
              ? standingIndex + 1
              : null;
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blue.shade100,
              child: Text(
                rank?.toString() ?? '-',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            title: Text('시즌 ${war.seasonId ?? '-'}'),
            subtitle: Text('${(war.sectionIndex ?? 0) + 1}주차'),
            trailing: Text(
              '${standing?.fame ?? 0} 명성',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          );
        }).toList(),
      ),
    );
  }
}
