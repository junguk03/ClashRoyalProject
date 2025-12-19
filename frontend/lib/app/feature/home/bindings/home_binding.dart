import 'package:get/get.dart';
import 'package:clash_royale_history/app/feature/home/controllers/home_controller.dart';
import 'package:clash_royale_history/app/feature/player/controllers/player_tab_controller.dart';
import 'package:clash_royale_history/app/feature/clan/controllers/clan_tab_controller.dart';
import 'package:clash_royale_history/app/feature/challenge/controllers/challenge_tab_controller.dart';
import 'package:clash_royale_history/app/feature/ranking/controllers/ranking_tab_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<PlayerTabController>(() => PlayerTabController());
    Get.lazyPut<ClanTabController>(() => ClanTabController());
    Get.lazyPut<ChallengeTabController>(() => ChallengeTabController());
    Get.lazyPut<RankingTabController>(() => RankingTabController());
  }
}
