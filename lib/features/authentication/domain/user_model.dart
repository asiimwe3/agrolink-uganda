class AppUser {
  final String id;
  final String phoneNumber;
  final String fullName;
  final String role;
  final String? gender;
  final String? district;
  final String? profilePhotoUrl;
  final String language;
  final bool darkMode;
  final bool isVerified;

  const AppUser({
    required this.id,
    required this.phoneNumber,
    required this.fullName,
    required this.role,
    this.gender,
    this.district,
    this.profilePhotoUrl,
    this.language = 'en',
    this.darkMode = false,
    this.isVerified = false,
  });

  factory AppUser.fromJson(Map<String, dynamic> json) => AppUser(
        id: json['id'] as String,
        phoneNumber: json['phone_number'] as String,
        fullName: json['full_name'] as String,
        role: json['role'] as String,
        gender: json['gender'] as String?,
        district: json['district'] as String?,
        profilePhotoUrl: json['profile_photo_url'] as String?,
        language: json['language'] as String? ?? 'en',
        darkMode: json['dark_mode'] as bool? ?? false,
        isVerified: json['is_verified'] as bool? ?? false,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'phone_number': phoneNumber,
        'full_name': fullName,
        'role': role,
        'gender': gender,
        'district': district,
        'profile_photo_url': profilePhotoUrl,
        'language': language,
        'dark_mode': darkMode,
        'is_verified': isVerified,
      };

  AppUser copyWith({
    String? fullName,
    String? role,
    String? gender,
    String? district,
    String? profilePhotoUrl,
    bool? darkMode,
  }) =>
      AppUser(
        id: id,
        phoneNumber: phoneNumber,
        fullName: fullName ?? this.fullName,
        role: role ?? this.role,
        gender: gender ?? this.gender,
        district: district ?? this.district,
        profilePhotoUrl: profilePhotoUrl ?? this.profilePhotoUrl,
        language: language,
        darkMode: darkMode ?? this.darkMode,
        isVerified: isVerified,
      );
}
