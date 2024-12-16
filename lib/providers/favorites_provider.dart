import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final favoriteCitiesProvider = StateNotifierProvider<FavoriteCitiesNotifier, List<String>>(
  (ref) => FavoriteCitiesNotifier(),
);

class FavoriteCitiesNotifier extends StateNotifier<List<String>> {
  FavoriteCitiesNotifier() : super([]) {
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final storedFavorites = prefs.getStringList('favoriteCities') ?? [];
    state = storedFavorites;
  }

  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('favoriteCities', state);
  }

  @override
  void addCity(String city) {
    if (!state.contains(city)) {
      state = [...state, city];
      _saveFavorites();
    }
  }

  @override
  void removeCity(String city) {
    state = state.where((c) => c != city).toList();
    _saveFavorites();
  }
}