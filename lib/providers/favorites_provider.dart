import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/pet.dart';
import '../services/pet_service.dart';

class FavoritesProvider extends ChangeNotifier {
  final PetService _petService = PetService();
  List<String> _favoritePetIds = [];
  List<Pet> _favoritePets = [];
  bool _isLoading = false;

  static const String _favoritesKey = 'favorite_pets';

  // Getters
  List<String> get favoritePetIds => _favoritePetIds;
  List<Pet> get favoritePets => _favoritePets;
  bool get isLoading => _isLoading;

  // Initialize favorites from local storage
  Future<void> loadFavorites() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      _favoritePetIds = prefs.getStringList(_favoritesKey) ?? [];
      
      // Load full pet objects for favorite IDs
      _favoritePets.clear();
      for (String petId in _favoritePetIds) {
        final pet = await _petService.getPetById(petId);
        if (pet != null) {
          _favoritePets.add(pet);
        }
      }
      
      // Remove any pet IDs that no longer exist
      _favoritePetIds = _favoritePets.map((pet) => pet.id).toList();
      await _saveFavorites();
      
    } catch (e) {
      debugPrint('Error loading favorites: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  // Add pet to favorites
  Future<void> addToFavorites(Pet pet) async {
    if (!_favoritePetIds.contains(pet.id)) {
      _favoritePetIds.add(pet.id);
      _favoritePets.add(pet);
      await _saveFavorites();
      notifyListeners();
    }
  }

  // Remove pet from favorites
  Future<void> removeFromFavorites(String petId) async {
    _favoritePetIds.remove(petId);
    _favoritePets.removeWhere((pet) => pet.id == petId);
    await _saveFavorites();
    notifyListeners();
  }

  // Toggle favorite status
  Future<void> toggleFavorite(String petId) async {
    if (isFavorite(petId)) {
      await removeFromFavorites(petId);
    } else {
      // Find the pet and add it
      final petService = PetService();
      final pet = await petService.getPetById(petId);
      if (pet != null) {
        await addToFavorites(pet);
      }
    }
  }

  // Check if pet is favorite
  bool isFavorite(String petId) {
    return _favoritePetIds.contains(petId);
  }

  // Clear all favorites
  Future<void> clearFavorites() async {
    _favoritePetIds.clear();
    _favoritePets.clear();
    await _saveFavorites();
    notifyListeners();
  }

  // Get number of favorites
  int get favoritesCount => _favoritePetIds.length;

  // Save favorites to local storage
  Future<void> _saveFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(_favoritesKey, _favoritePetIds);
    } catch (e) {
      debugPrint('Error saving favorites: $e');
    }
  }

  // Refresh favorite pets data
  Future<void> refreshFavorites() async {
    _isLoading = true;
    notifyListeners();

    try {
      _favoritePets.clear();
      List<String> validIds = [];
      
      for (String petId in _favoritePetIds) {
        final pet = await _petService.getPetById(petId);
        if (pet != null && !pet.isAdopted) {
          _favoritePets.add(pet);
          validIds.add(petId);
        }
      }
      
      // Update the list to only include valid IDs
      _favoritePetIds = validIds;
      await _saveFavorites();
      
    } catch (e) {
      debugPrint('Error refreshing favorites: $e');
    }

    _isLoading = false;
    notifyListeners();
  }
} 