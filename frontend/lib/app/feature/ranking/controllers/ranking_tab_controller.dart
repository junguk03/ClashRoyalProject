import 'package:get/get.dart';
import 'package:clash_royale_history/app/api/services/location_service.dart';
import 'package:clash_royale_history/app/api/models/location_model.dart';
import 'package:clash_royale_history/app/components/logger/logger.dart';

class RankingTabController extends GetxController {
  final LocationService _locationService = Get.find<LocationService>();

  final _locations = <LocationDetail>[].obs;
  final _selectedLocation = Rxn<LocationDetail>();
  final _playerRankings = <PlayerRanking>[].obs;
  final _clanRankings = <ClanRanking>[].obs;
  final _polRankings = <PathOfLegendRanking>[].obs;

  final _isLocationsLoading = false.obs;
  final _isPlayerRankingsLoading = false.obs;
  final _isClanRankingsLoading = false.obs;
  final _isPolRankingsLoading = false.obs;

  List<LocationDetail> get locations => _locations;
  LocationDetail? get selectedLocation => _selectedLocation.value;
  List<PlayerRanking> get playerRankings => _playerRankings;
  List<ClanRanking> get clanRankings => _clanRankings;
  List<PathOfLegendRanking> get polRankings => _polRankings;

  bool get isLocationsLoading => _isLocationsLoading.value;
  bool get isPlayerRankingsLoading => _isPlayerRankingsLoading.value;
  bool get isClanRankingsLoading => _isClanRankingsLoading.value;
  bool get isPolRankingsLoading => _isPolRankingsLoading.value;

  @override
  void onInit() {
    super.onInit();
    loadLocations();
  }

  Future<void> loadLocations() async {
    _isLocationsLoading.value = true;
    try {
      final response = await _locationService.getLocations();
      if (response.success && response.data != null) {
        _locations.assignAll(response.data!.items);
        // 기본으로 한국 선택
        final korea = response.data!.items.firstWhereOrNull(
          (loc) => loc.countryCode == 'KR',
        );
        if (korea != null) {
          selectLocation(korea);
        }
      }
    } catch (e) {
      log.e('Locations load error: $e');
    } finally {
      _isLocationsLoading.value = false;
    }
  }

  void selectLocation(LocationDetail location) {
    _selectedLocation.value = location;
    _playerRankings.clear();
    _clanRankings.clear();
    _polRankings.clear();
    loadPlayerRankings();
    loadClanRankings();
    loadPathOfLegendRankings();
  }

  Future<void> loadPlayerRankings() async {
    final location = _selectedLocation.value;
    if (location == null) return;

    _isPlayerRankingsLoading.value = true;
    try {
      final response = await _locationService.getPlayerRankings(location.id);
      if (response.success && response.data != null) {
        _playerRankings.assignAll(response.data!.items);
      }
    } catch (e) {
      log.e('Player rankings load error: $e');
    } finally {
      _isPlayerRankingsLoading.value = false;
    }
  }

  Future<void> loadClanRankings() async {
    final location = _selectedLocation.value;
    if (location == null) return;

    _isClanRankingsLoading.value = true;
    try {
      final response = await _locationService.getClanRankings(location.id);
      if (response.success && response.data != null) {
        _clanRankings.assignAll(response.data!.items);
      }
    } catch (e) {
      log.e('Clan rankings load error: $e');
    } finally {
      _isClanRankingsLoading.value = false;
    }
  }

  Future<void> loadPathOfLegendRankings() async {
    final location = _selectedLocation.value;
    if (location == null) return;

    _isPolRankingsLoading.value = true;
    try {
      final response = await _locationService.getPathOfLegendRankings(location.id);
      if (response.success && response.data != null) {
        _polRankings.assignAll(response.data!.items);
      }
    } catch (e) {
      log.e('Path of Legend rankings load error: $e');
    } finally {
      _isPolRankingsLoading.value = false;
    }
  }
}
