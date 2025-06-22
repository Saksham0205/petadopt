import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/pet.dart';
import '../data/sample_pets.dart';

class PetService {
  static const String baseUrl = 'https://api.petadopt.com'; // Mock API endpoint
  static final PetService _instance = PetService._internal();
  factory PetService() => _instance;
  PetService._internal();

  // For demo purposes, we'll use local data
  List<Pet> _pets = [];
  bool _isInitialized = false;

  Future<void> initialize() async {
    if (!_isInitialized) {
      _pets = SamplePets.getSamplePets();
      _isInitialized = true;
    }
  }

  Future<List<Pet>> getAllPets() async {
    await initialize();
    return _pets.where((pet) => !pet.isAdopted).toList();
  }

  Future<List<Pet>> searchPets(String query) async {
    await initialize();
    if (query.isEmpty) return getAllPets();
    
    final lowercaseQuery = query.toLowerCase();
    return _pets.where((pet) {
      return !pet.isAdopted &&
          (pet.name.toLowerCase().contains(lowercaseQuery) ||
           pet.breed.toLowerCase().contains(lowercaseQuery) ||
           pet.species.toLowerCase().contains(lowercaseQuery) ||
           pet.location.toLowerCase().contains(lowercaseQuery));
    }).toList();
  }

  Future<List<Pet>> filterPets({
    String? species,
    String? size,
    String? age,
    String? gender,
    bool? isVaccinated,
    bool? isNeutered,
    bool? goodWithKids,
    bool? goodWithPets,
    double? maxAdoptionFee,
  }) async {
    await initialize();
    List<Pet> filteredPets = _pets.where((pet) => !pet.isAdopted).toList();

    if (species != null && species.isNotEmpty) {
      filteredPets = filteredPets.where((pet) => 
          pet.species.toLowerCase() == species.toLowerCase()).toList();
    }

    if (size != null && size.isNotEmpty) {
      filteredPets = filteredPets.where((pet) => 
          pet.size.toLowerCase() == size.toLowerCase()).toList();
    }

    if (gender != null && gender.isNotEmpty) {
      filteredPets = filteredPets.where((pet) => 
          pet.gender.toLowerCase() == gender.toLowerCase()).toList();
    }

    if (age != null) {
      switch (age.toLowerCase()) {
        case 'young':
          filteredPets = filteredPets.where((pet) => pet.age <= 12).toList();
          break;
        case 'adult':
          filteredPets = filteredPets.where((pet) => pet.age > 12 && pet.age <= 84).toList();
          break;
        case 'senior':
          filteredPets = filteredPets.where((pet) => pet.age > 84).toList();
          break;
      }
    }

    if (isVaccinated == true) {
      filteredPets = filteredPets.where((pet) => pet.isVaccinated).toList();
    }

    if (isNeutered == true) {
      filteredPets = filteredPets.where((pet) => pet.isNeutered).toList();
    }

    if (goodWithKids == true) {
      filteredPets = filteredPets.where((pet) => pet.goodWithKids).toList();
    }

    if (goodWithPets == true) {
      filteredPets = filteredPets.where((pet) => pet.goodWithPets).toList();
    }

    if (maxAdoptionFee != null) {
      filteredPets = filteredPets.where((pet) => pet.adoptionFee <= maxAdoptionFee).toList();
    }

    return filteredPets;
  }

  Future<Pet?> getPetById(String id) async {
    await initialize();
    try {
      return _pets.firstWhere((pet) => pet.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<List<Pet>> getPetsBySpecies(String species) async {
    await initialize();
    return _pets.where((pet) => 
        !pet.isAdopted && 
        pet.species.toLowerCase() == species.toLowerCase()).toList();
  }

  Future<List<Pet>> getRecentPets({int limit = 10}) async {
    await initialize();
    final pets = _pets.where((pet) => !pet.isAdopted).toList();
    pets.sort((a, b) => b.datePosted.compareTo(a.datePosted));
    return pets.take(limit).toList();
  }

  Future<List<Pet>> getFeaturedPets({int limit = 5}) async {
    await initialize();
    // For demo, we'll just return the first few pets
    final pets = _pets.where((pet) => !pet.isAdopted).toList();
    return pets.take(limit).toList();
  }

  Future<bool> addPet(Pet pet) async {
    try {
      _pets.add(pet);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updatePet(Pet pet) async {
    try {
      final index = _pets.indexWhere((p) => p.id == pet.id);
      if (index != -1) {
        _pets[index] = pet;
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deletePet(String petId) async {
    try {
      _pets.removeWhere((pet) => pet.id == petId);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> markAsAdopted(String petId) async {
    try {
      final index = _pets.indexWhere((pet) => pet.id == petId);
      if (index != -1) {
        _pets[index] = _pets[index].copyWith(isAdopted: true);
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  // Get statistics for dashboard
  Future<Map<String, int>> getPetStatistics() async {
    await initialize();
    final available = _pets.where((pet) => !pet.isAdopted).length;
    final adopted = _pets.where((pet) => pet.isAdopted).length;
    final dogs = _pets.where((pet) => !pet.isAdopted && pet.species.toLowerCase() == 'dog').length;
    final cats = _pets.where((pet) => !pet.isAdopted && pet.species.toLowerCase() == 'cat').length;
    final others = available - dogs - cats;

    return {
      'available': available,
      'adopted': adopted,
      'dogs': dogs,
      'cats': cats,
      'others': others,
    };
  }

  // Get adopted pets for history
  Future<List<Pet>> getAdoptedPets() async {
    await initialize();
    return _pets.where((pet) => pet.isAdopted).toList();
  }
} 