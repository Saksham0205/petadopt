class Pet {
  final String id;
  final String name;
  final String breed;
  final String species; // Dog, Cat, Bird, etc.
  final int age; // in months
  final String gender;
  final double weight; // in kg
  final String size; // Small, Medium, Large
  final String color;
  final String description;
  final List<String> imageUrls;
  final String location;
  final String ownerName;
  final String ownerContact;
  final String ownerEmail;
  final bool isVaccinated;
  final bool isNeutered;
  final bool isHouseTrained;
  final bool goodWithKids;
  final bool goodWithPets;
  final String healthStatus;
  final DateTime datePosted;
  final bool isAdopted;
  final List<String> tags;
  final double adoptionFee;

  Pet({
    required this.id,
    required this.name,
    required this.breed,
    required this.species,
    required this.age,
    required this.gender,
    required this.weight,
    required this.size,
    required this.color,
    required this.description,
    required this.imageUrls,
    required this.location,
    required this.ownerName,
    required this.ownerContact,
    required this.ownerEmail,
    this.isVaccinated = false,
    this.isNeutered = false,
    this.isHouseTrained = false,
    this.goodWithKids = false,
    this.goodWithPets = false,
    this.healthStatus = 'Good',
    required this.datePosted,
    this.isAdopted = false,
    this.tags = const [],
    this.adoptionFee = 0.0,
  });

  factory Pet.fromJson(Map<String, dynamic> json) {
    return Pet(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      breed: json['breed'] ?? '',
      species: json['species'] ?? '',
      age: json['age'] ?? 0,
      gender: json['gender'] ?? '',
      weight: (json['weight'] ?? 0.0).toDouble(),
      size: json['size'] ?? '',
      color: json['color'] ?? '',
      description: json['description'] ?? '',
      imageUrls: List<String>.from(json['imageUrls'] ?? []),
      location: json['location'] ?? '',
      ownerName: json['ownerName'] ?? '',
      ownerContact: json['ownerContact'] ?? '',
      ownerEmail: json['ownerEmail'] ?? '',
      isVaccinated: json['isVaccinated'] ?? false,
      isNeutered: json['isNeutered'] ?? false,
      isHouseTrained: json['isHouseTrained'] ?? false,
      goodWithKids: json['goodWithKids'] ?? false,
      goodWithPets: json['goodWithPets'] ?? false,
      healthStatus: json['healthStatus'] ?? 'Good',
      datePosted: DateTime.parse(json['datePosted'] ?? DateTime.now().toIso8601String()),
      isAdopted: json['isAdopted'] ?? false,
      tags: List<String>.from(json['tags'] ?? []),
      adoptionFee: (json['adoptionFee'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'breed': breed,
      'species': species,
      'age': age,
      'gender': gender,
      'weight': weight,
      'size': size,
      'color': color,
      'description': description,
      'imageUrls': imageUrls,
      'location': location,
      'ownerName': ownerName,
      'ownerContact': ownerContact,
      'ownerEmail': ownerEmail,
      'isVaccinated': isVaccinated,
      'isNeutered': isNeutered,
      'isHouseTrained': isHouseTrained,
      'goodWithKids': goodWithKids,
      'goodWithPets': goodWithPets,
      'healthStatus': healthStatus,
      'datePosted': datePosted.toIso8601String(),
      'isAdopted': isAdopted,
      'tags': tags,
      'adoptionFee': adoptionFee,
    };
  }

  Pet copyWith({
    String? id,
    String? name,
    String? breed,
    String? species,
    int? age,
    String? gender,
    double? weight,
    String? size,
    String? color,
    String? description,
    List<String>? imageUrls,
    String? location,
    String? ownerName,
    String? ownerContact,
    String? ownerEmail,
    bool? isVaccinated,
    bool? isNeutered,
    bool? isHouseTrained,
    bool? goodWithKids,
    bool? goodWithPets,
    String? healthStatus,
    DateTime? datePosted,
    bool? isAdopted,
    List<String>? tags,
    double? adoptionFee,
  }) {
    return Pet(
      id: id ?? this.id,
      name: name ?? this.name,
      breed: breed ?? this.breed,
      species: species ?? this.species,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      weight: weight ?? this.weight,
      size: size ?? this.size,
      color: color ?? this.color,
      description: description ?? this.description,
      imageUrls: imageUrls ?? this.imageUrls,
      location: location ?? this.location,
      ownerName: ownerName ?? this.ownerName,
      ownerContact: ownerContact ?? this.ownerContact,
      ownerEmail: ownerEmail ?? this.ownerEmail,
      isVaccinated: isVaccinated ?? this.isVaccinated,
      isNeutered: isNeutered ?? this.isNeutered,
      isHouseTrained: isHouseTrained ?? this.isHouseTrained,
      goodWithKids: goodWithKids ?? this.goodWithKids,
      goodWithPets: goodWithPets ?? this.goodWithPets,
      healthStatus: healthStatus ?? this.healthStatus,
      datePosted: datePosted ?? this.datePosted,
      isAdopted: isAdopted ?? this.isAdopted,
      tags: tags ?? this.tags,
      adoptionFee: adoptionFee ?? this.adoptionFee,
    );
  }

  String get ageString {
    if (age < 12) {
      return '$age months old';
    } else {
      final years = age ~/ 12;
      final months = age % 12;
      if (months == 0) {
        return '$years year${years > 1 ? 's' : ''} old';
      } else {
        return '$years year${years > 1 ? 's' : ''} and $months month${months > 1 ? 's' : ''} old';
      }
    }
  }

  String getAgeDisplay() {
    return ageString;
  }

  String get primaryImageUrl {
    return imageUrls.isNotEmpty ? imageUrls.first : '';
  }
} 