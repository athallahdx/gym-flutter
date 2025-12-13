class User {
  final int id;
  final String name;
  final String email;
  final String? phone;
  final String role;
  final String membershipRegistered;
  final String membershipStatus;
  final DateTime? membershipEndDate;
  final String? profileBio;
  final String? profileImage;
  final DateTime? emailVerifiedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    required this.role,
    required this.membershipRegistered,
    required this.membershipStatus,
    this.membershipEndDate,
    this.profileBio,
    this.profileImage,
    this.emailVerifiedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String?,
      role: json['role'] as String,
      membershipRegistered:
          json['membership_registered'] as String? ?? 'unregistered',
      membershipStatus: json['membership_status'] as String? ?? 'inactive',
      membershipEndDate: json['membership_end_date'] != null
          ? DateTime.parse(json['membership_end_date'] as String)
          : null,
      profileBio: json['profile_bio'] as String?,
      profileImage: json['profile_image'] as String?,
      emailVerifiedAt: json['email_verified_at'] != null
          ? DateTime.parse(json['email_verified_at'] as String)
          : null,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'role': role,
      'membership_registered': membershipRegistered,
      'membership_status': membershipStatus,
      'membership_end_date': membershipEndDate?.toIso8601String(),
      'profile_bio': profileBio,
      'profile_image': profileImage,
      'email_verified_at': emailVerifiedAt?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  String get fullProfileImageUrl {
    if (profileImage == null || profileImage!.isEmpty) {
      return 'https://via.placeholder.com/150';
    }
    // Adjust base URL according to your Laravel storage setup
    if (profileImage!.startsWith('http')) {
      return profileImage!;
    }
    return 'https://gym.sulthon.blue/storage/$profileImage';
  }

  bool get isEmailVerified => emailVerifiedAt != null;
  bool get hasMembership => membershipRegistered == 'registered';
  bool get isMembershipActive => membershipStatus == 'active';
  bool get isMember => role == 'member';
  bool get isTrainer => role == 'trainer';
  bool get isAdmin => role == 'admin';
}
