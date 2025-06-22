import 'package:flutter/foundation.dart';
import '../models/pet.dart';
import '../services/pet_service.dart';

class PetProvider extends ChangeNotifier {
  final PetService _petService = PetService();
  
  List<Pet> _pets = [];
  List<Pet> _filteredPets = [];
  List<Pet> _featuredPets = [];
  List<Pet> _adoptedPets = [];
  bool _isLoading = false;
  String _error = '';
  String _searchQuery = '';
  Map<String, dynamic> _filters = {};

  // Getters
  List<Pet> get pets => _pets;
  List<Pet> get filteredPets => _filteredPets;
  List<Pet> get featuredPets => _featuredPets;
  List<Pet> get adoptedPets => _adoptedPets;
  bool get isLoading => _isLoading;
  String get error => _error;
  String get searchQuery => _searchQuery;
  Map<String, dynamic> get filters => _filters;

  // Load all pets
  Future<void> loadPets() async {
    _setLoading(true);
    try {
      _pets = await _petService.getAllPets();
      _filteredPets = List.from(_pets);
      _error = '';
    } catch (e) {
      _error = 'Failed to load pets: $e';
    }
    _setLoading(false);
  }

  // Load featured pets
  Future<void> loadFeaturedPets() async {
    try {
      _featuredPets = await _petService.getFeaturedPets();
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load featured pets: $e';
    }
  }

  // Search pets
  Future<void> searchPets(String query) async {
    _searchQuery = query;
    _setLoading(true);
    try {
      if (query.isEmpty) {
        _filteredPets = List.from(_pets);
      } else {
        _filteredPets = await _petService.searchPets(query);
      }
      _error = '';
    } catch (e) {
      _error = 'Search failed: $e';
    }
    _setLoading(false);
  }

  // Filter pets
  Future<void> filterPets(Map<String, dynamic> filters) async {
    _filters = filters;
    _setLoading(true);
    try {
      _filteredPets = await _petService.filterPets(
        species: filters['species'],
        size: filters['size'],
        age: filters['age'],
        gender: filters['gender'],
        isVaccinated: filters['isVaccinated'],
        isNeutered: filters['isNeutered'],
        goodWithKids: filters['goodWithKids'],
        goodWithPets: filters['goodWithPets'],
        maxAdoptionFee: filters['maxAdoptionFee'],
      );
      _error = '';
    } catch (e) {
      _error = 'Filter failed: $e';
    }
    _setLoading(false);
  }

  // Get pets by species
  Future<void> loadPetsBySpecies(String species) async {
    _setLoading(true);
    try {
      _filteredPets = await _petService.getPetsBySpecies(species);
      _error = '';
    } catch (e) {
      _error = 'Failed to load pets: $e';
    }
    _setLoading(false);
  }

  // Get pet by ID
  Future<Pet?> getPetById(String id) async {
    try {
      return await _petService.getPetById(id);
    } catch (e) {
      _error = 'Failed to load pet details: $e';
      return null;
    }
  }

  // Add new pet
  Future<bool> addPet(Pet pet) async {
    try {
      final success = await _petService.addPet(pet);
      if (success) {
        _pets.add(pet);
        _filteredPets = List.from(_pets);
        notifyListeners();
      }
      return success;
    } catch (e) {
      _error = 'Failed to add pet: $e';
      return false;
    }
  }

  // Update pet
  Future<bool> updatePet(Pet pet) async {
    try {
      final success = await _petService.updatePet(pet);
      if (success) {
        final index = _pets.indexWhere((p) => p.id == pet.id);
        if (index != -1) {
          _pets[index] = pet;
          _filteredPets = List.from(_pets);
          notifyListeners();
        }
      }
      return success;
    } catch (e) {
      _error = 'Failed to update pet: $e';
      return false;
    }
  }

  // Delete pet
  Future<bool> deletePet(String petId) async {
    try {
      final success = await _petService.deletePet(petId);
      if (success) {
        _pets.removeWhere((pet) => pet.id == petId);
        _filteredPets.removeWhere((pet) => pet.id == petId);
        notifyListeners();
      }
      return success;
    } catch (e) {
      _error = 'Failed to delete pet: $e';
      return false;
    }
  }

  // Mark pet as adopted
  Future<bool> markPetAsAdopted(String petId) async {
    try {
      final success = await _petService.markAsAdopted(petId);
      if (success) {
        final index = _pets.indexWhere((pet) => pet.id == petId);
        if (index != -1) {
          _pets[index] = _pets[index].copyWith(isAdopted: true);
          _filteredPets = _pets.where((pet) => !pet.isAdopted).toList();
          notifyListeners();
        }
      }
      return success;
    } catch (e) {
      _error = 'Failed to mark pet as adopted: $e';
      return false;
    }
  }

  // Clear filters
  void clearFilters() {
    _filters.clear();
    _searchQuery = '';
    _filteredPets = List.from(_pets);
    notifyListeners();
  }

  // Update a single filter (convenience method)
  void updateFilter(String key, dynamic value) {
    _filters[key] = value;
    filterPets(_filters);
  }

  // Apply filters (alias for filterPets for consistency)
  Future<void> applyFilters(Map<String, dynamic> filters) async {
    await filterPets(filters);
  }

  // Get statistics
  Future<Map<String, int>> getStatistics() async {
    try {
      return await _petService.getPetStatistics();
    } catch (e) {
      _error = 'Failed to load statistics: $e';
      return {};
    }
  }

  // Load adopted pets for history
  Future<void> loadAdoptedPets() async {
    _setLoading(true);
    try {
      _adoptedPets = await _petService.getAdoptedPets();
      _adoptedPets.sort((a, b) => b.datePosted.compareTo(a.datePosted)); // Most recent first
      _error = '';
    } catch (e) {
      _error = 'Failed to load adopted pets: $e';
    }
    _setLoading(false);
  }

  // Private helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void clearError() {
    _error = '';
    notifyListeners();
  }
} 