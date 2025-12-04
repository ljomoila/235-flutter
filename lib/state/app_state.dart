import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/game.dart';
import '../models/player.dart';
import '../services/api_client.dart';

class AppState extends ChangeNotifier {
  AppState({required this.apiClient});

  final ApiClient apiClient;

  bool initializing = true;
  bool loadingScores = false;
  bool loadingPlayer = false;
  bool? apiCallFailed = false;
  String? playerStatsError;
  List<Game> games = [];
  String? selectedCountry;
  DateTime selectedDate = DateTime.now();
  Player? activePlayer;
  Map<String, dynamic>? playerStats;

  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    selectedCountry = prefs.getString('selectedCountry');
    initializing = false;
    notifyListeners();

    if (selectedCountry != null) {
      await loadScores(skipIfUnselected: false);
    }
  }

  Future<void> setCountry(String countryCode) async {
    selectedCountry = countryCode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedCountry', countryCode);
    notifyListeners();
    await loadScores(skipIfUnselected: false);
  }

  Future<void> changeDate(DateTime date) async {
    selectedDate = DateTime(date.year, date.month, date.day);
    notifyListeners();
    await loadScores(skipIfUnselected: false);
  }

  Future<void> adjustDate(int offset) async {
    final nextDate = selectedDate.add(Duration(days: offset));
    await changeDate(nextDate);
  }

  Future<void> refreshScores() async {
    await loadScores(skipIfUnselected: false, force: true);
  }

  Future<void> loadScores({
    bool skipIfUnselected = true,
    bool force = false,
  }) async {
    if (skipIfUnselected && selectedCountry == null) {
      games = [];
      apiCallFailed = false;
      notifyListeners();
      return;
    }

    if (loadingScores && !force) return;

    loadingScores = true;
    apiCallFailed = false;
    notifyListeners();

    try {
      games = await apiClient.fetchGames(selectedDate);
    } catch (e) {
      apiCallFailed = true;
    } finally {
      loadingScores = false;
      notifyListeners();
    }
  }

  Future<void> openPlayer(Player player) async {
    activePlayer = player;
    playerStats = null;
    playerStatsError = null;
    loadingPlayer = true;
    notifyListeners();

    final id = player.id ?? player.playerId;
    if (id == null) {
      playerStatsError = 'Player id missing';
      loadingPlayer = false;
      notifyListeners();
      return;
    }

    try {
      playerStats = await apiClient.fetchPlayerStats(id);
    } catch (e) {
      playerStatsError = e.toString();
    } finally {
      loadingPlayer = false;
      notifyListeners();
    }
  }

  void clearPlayer() {
    activePlayer = null;
    playerStats = null;
    playerStatsError = null;
    loadingPlayer = false;
    notifyListeners();
  }

  @override
  void dispose() {
    apiClient.dispose();
    super.dispose();
  }
}
