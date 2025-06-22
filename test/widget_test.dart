// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:petadopt/main.dart';
import 'package:petadopt/models/pet.dart';
import 'package:petadopt/providers/favorites_provider.dart';

void main() {
  group('Widget Tests', () {
    testWidgets('Pet adopt app loads', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(const PetAdoptApp());

      // Verify that the app starts at splash screen
      expect(find.text('PetAdopt'), findsOneWidget);
    });

    testWidgets('FavoritesProvider initializes correctly', (WidgetTester tester) async {
      final favoritesProvider = FavoritesProvider();
      
      expect(favoritesProvider.favoritePets, isEmpty);
      expect(favoritesProvider.favoritesCount, 0);
      expect(favoritesProvider.isLoading, false);
    });

    testWidgets('Basic pet model functionality', (WidgetTester tester) async {
      final testPet = Pet(
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
        imageUrls: ['https://example.com/image.jpg'],
        location: 'San Francisco',
        ownerName: 'John Doe',
        ownerContact: '123-456-7890',
        ownerEmail: 'john@example.com',
        datePosted: DateTime.now(),
        adoptionFee: 250.0,
      );

      expect(testPet.name, 'Buddy');
      expect(testPet.species, 'Dog');
      expect(testPet.adoptionFee, 250.0);
      expect(testPet.isAdopted, false);
      expect(testPet.ageString, '2 years old');
    });

    testWidgets('Pet copyWith method works correctly', (WidgetTester tester) async {
      final originalPet = Pet(
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

      final updatedPet = originalPet.copyWith(
        name: 'Updated',
        isAdopted: true,
      );

      expect(updatedPet.name, 'Updated');
      expect(updatedPet.isAdopted, true);
      expect(updatedPet.id, '1'); // Should remain unchanged
    });

    testWidgets('App theme contains required elements', (WidgetTester tester) async {
      await tester.pumpWidget(const PetAdoptApp());
      
      final MaterialApp app = tester.widget(find.byType(MaterialApp));
      expect(app.theme, isNotNull);
      expect(app.darkTheme, isNotNull);
      expect(app.themeMode, ThemeMode.system);
    });
  });
}
