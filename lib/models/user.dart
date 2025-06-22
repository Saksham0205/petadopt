class User {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final String? location;
  final String? profileImageUrl;
  final List<String> favoritePetIds;
  final List<String> myPetIds;
  final DateTime joinDate;
  final bool isEmailVerified;
  final String? bio;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.location,
    this.profileImageUrl,
    this.favoritePetIds = const [],
    this.myPetIds = const [],
    required this.joinDate,
    this.isEmailVerified = false,
    this.bio,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'],
      location: json['location'],
      profileImageUrl: json['profileImageUrl'],
      favoritePetIds: List<String>.from(json['favoritePetIds'] ?? []),
      myPetIds: List<String>.from(json['myPetIds'] ?? []),
      joinDate: DateTime.parse(json['joinDate'] ?? DateTime.now().toIso8601String()),
      isEmailVerified: json['isEmailVerified'] ?? false,
      bio: json['bio'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'location': location,
      'profileImageUrl': profileImageUrl,
      'favoritePetIds': favoritePetIds,
      'myPetIds': myPetIds,
      'joinDate': joinDate.toIso8601String(),
      'isEmailVerified': isEmailVerified,
      'bio': bio,
    };
  }

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? location,
    String? profileImageUrl,
    List<String>? favoritePetIds,
    List<String>? myPetIds,
    DateTime? joinDate,
    bool? isEmailVerified,
    String? bio,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      location: location ?? this.location,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      favoritePetIds: favoritePetIds ?? this.favoritePetIds,
      myPetIds: myPetIds ?? this.myPetIds,
      joinDate: joinDate ?? this.joinDate,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      bio: bio ?? this.bio,
    );
  }
} 