import 'package:get/get.dart';

import '../core/api_client.dart';
import '../services/card_service.dart';
import '../services/challenge_service.dart';
import '../services/clan_service.dart';
import '../services/location_service.dart';
import '../services/player_service.dart';
import '../services/tournament_service.dart';

class ApiBinding extends Bindings {
  @override
  void dependencies() {
    // Core
    Get.put<ApiClient>(
      ApiClient(),
      permanent: true,
    );

    // Services
    Get.put<PlayerService>(
      PlayerService(),
      permanent: true,
    );

    Get.put<ClanService>(
      ClanService(),
      permanent: true,
    );

    Get.put<TournamentService>(
      TournamentService(),
      permanent: true,
    );

    Get.put<CardService>(
      CardService(),
      permanent: true,
    );

    Get.put<ChallengeService>(
      ChallengeService(),
      permanent: true,
    );

    Get.put<LocationService>(
      LocationService(),
      permanent: true,
    );
  }
}
