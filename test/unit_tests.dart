import 'package:flutter_test/flutter_test.dart';
import 'package:petadopt/models/pet.dart';
import 'package:petadopt/services/pet_service.dart';

void main() {
  group('Pet Model Tests', () {
    test('Pet fromJson should create correct Pet instance', () {
      final json = {
        'id': '1',
        'name': 'Buddy',
        'breed': 'Golden Retriever',
        'species': 'Dog',
        'age': 24,
        'gender': 'Male',
        'weight': 30.0,
        'size': 'Large',
        'color': 'Golden',
        'description': 'Friendly dog',
        'imageUrls': ['url1', 'url2'],
        'location': 'San Francisco',
        'ownerName': 'John Doe',
        'ownerContact': '123-456-7890',
        'ownerEmail': 'john@example.com',
        'isVaccinated': true,
        'isNeutered': true,
        'isHouseTrained': true,
        'goodWithKids': true,
        'goodWithPets': true,
        'healthStatus': 'Excellent',
        'datePosted': '2024-01-01T00:00:00.000Z',
        'isAdopted': false,
        'tags': ['friendly', 'energetic'],
        'adoptionFee': 250.0,
      };

      final pet = Pet.fromJson(json);

      expect(pet.id, '1');
      expect(pet.name, 'Buddy');
      expect(pet.breed, 'Golden Retriever');
      expect(pet.species, 'Dog');
      expect(pet.age, 24);
      expect(pet.gender, 'Male');
      expect(pet.weight, 30.0);
      expect(pet.size, 'Large');
      expect(pet.color, 'Golden');
      expect(pet.description, 'Friendly dog');
      expect(pet.imageUrls, ['url1', 'url2']);
      expect(pet.location, 'San Francisco');
      expect(pet.isVaccinated, true);
      expect(pet.adoptionFee, 250.0);
    });

    test('Pet toJson should create correct JSON', () {
      final pet = Pet(
        id: '1',
        name: 'Buddy',
        breed: 'Golden Retriever',
        species: 'Dog',
        age: 24,
        gender: 'Male',
        weight: 30.0,
        size: 'Large',
        color: 'Golden',
        description: 'Friendly dog',
        imageUrls: ['url1', 'url2'],
        location: 'San Francisco',
        ownerName: 'John Doe',
        ownerContact: '123-456-7890',
        ownerEmail: 'john@example.com',
        datePosted: DateTime(2024, 1, 1),
        adoptionFee: 250.0,
      );

      final json = pet.toJson();

      expect(json['id'], '1');
      expect(json['name'], 'Buddy');
      expect(json['breed'], 'Golden Retriever');
      expect(json['adoptionFee'], 250.0);
    });

    test('Pet age string should format correctly', () {
      final youngPet = Pet(
        id: '1',
        name: 'Young Pet',
        breed: 'Test',
        species: 'Dog',
        age: 6,
        gender: 'Male',
        weight: 10.0,
        size: 'Small',
        color: 'Brown',
        description: 'Test',
        imageUrls: [],
        location: 'Test',
        ownerName: 'Test',
        ownerContact: 'Test',
        ownerEmail: 'test@example.com',
        datePosted: DateTime.now(),
      );

      final adultPet = Pet(
        id: '2',
        name: 'Adult Pet',
        breed: 'Test',
        species: 'Dog',
        age: 18,
        gender: 'Male',
        weight: 20.0,
        size: 'Medium',
        color: 'Brown',
        description: 'Test',
        imageUrls: [],
        location: 'Test',
        ownerName: 'Test',
        ownerContact: 'Test',
        ownerEmail: 'test@example.com',
        datePosted: DateTime.now(),
      );

      expect(youngPet.ageString, '6 months old');
      expect(adultPet.ageString, '1 year and 6 months old');
    });

    test('Pet copyWith should update fields correctly', () {
      final pet = Pet(
        id: '1',
        name: 'Original',
        breed: 'Test',
        species: 'Dog',
        age: 12,
        gender: 'Male',
        weight: 15.0,
        size: 'Medium',
        color: 'Brown',
        description: 'Test',
        imageUrls: [],
        location: 'Test',
        ownerName: 'Test',
        ownerContact: 'Test',
        ownerEmail: 'test@example.com',
        datePosted: DateTime.now(),
        isAdopted: false,
      );

      final updatedPet = pet.copyWith(
        name: 'Updated',
        isAdopted: true,
      );

      expect(updatedPet.name, 'Updated');
      expect(updatedPet.isAdopted, true);
      expect(updatedPet.id, '1'); // Should remain unchanged
    });
  });

  group('PetService Tests', () {
    late PetService petService;

    setUp(() {
      petService = PetService();
    });

    test('getAllPets should return list of available pets', () async {
      final pets = await petService.getAllPets();
      expect(pets, isA<List<Pet>>());
      expect(pets.isNotEmpty, true);
      // Should not include adopted pets
      expect(pets.every((pet) => !pet.isAdopted), true);
    });

    test('searchPets should filter pets by query', () async {
      final allPets = await petService.getAllPets();
      final searchResults = await petService.searchPets('Golden');
      
      expect(searchResults, isA<List<Pet>>());
      expect(searchResults.length, lessThanOrEqualTo(allPets.length));
      // All results should contain 'Golden' in some field
      expect(searchResults.every((pet) => 
        pet.name.toLowerCase().contains('golden') ||
        pet.breed.toLowerCase().contains('golden') ||
        pet.species.toLowerCase().contains('golden')
      ), true);
    });

    test('getPetById should return correct pet', () async {
      final pets = await petService.getAllPets();
      if (pets.isNotEmpty) {
        final firstPet = pets.first;
        final foundPet = await petService.getPetById(firstPet.id);
        expect(foundPet, isNotNull);
        expect(foundPet!.id, firstPet.id);
      }
    });

    test('markAsAdopted should update pet adoption status', () async {
      final pets = await petService.getAllPets();
      if (pets.isNotEmpty) {
        final petId = pets.first.id;
        final success = await petService.markAsAdopted(petId);
        expect(success, true);
        
        final adoptedPets = await petService.getAdoptedPets();
        expect(adoptedPets.any((pet) => pet.id == petId), true);
      }
    });

    test('filterPets should filter by species', () async {
      final dogPets = await petService.filterPets(species: 'Dog');
      expect(dogPets.every((pet) => pet.species.toLowerCase() == 'dog'), true);
    });

    test('getPetStatistics should return correct counts', () async {
      final stats = await petService.getPetStatistics();
      expect(stats, isA<Map<String, int>>());
      expect(stats.containsKey('available'), true);
      expect(stats.containsKey('adopted'), true);
      expect(stats.containsKey('dogs'), true);
      expect(stats.containsKey('cats'), true);
    });
  });
} 