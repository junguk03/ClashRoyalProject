import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:clash_royale_history/app/feature/home/controllers/home_controller.dart';
import 'package:clash_royale_history/app/feature/player/views/player_tab_page.dart';
import 'package:clash_royale_history/app/feature/clan/views/clan_tab_page.dart';
import 'package:clash_royale_history/app/feature/challenge/views/challenge_tab_page.dart';
import 'package:clash_royale_history/app/feature/ranking/views/ranking_tab_page.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: controller.pageController,
        onPageChanged: controller.onPageChanged,
        children: const [
          PlayerTabPage(),
          ClanTabPage(),
          ChallengeTabPage(),
          RankingTabPage(),
        ],
      ),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: controller.currentIndex,
          onTap: controller.changePage,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.person_search),
              label: '플레이어',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.groups),
              label: '클랜',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.emoji_events),
              label: '챌린지',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.leaderboard),
              label: '랭킹',
            ),
          ],
        ),
      ),
    );
  }
}
