class User {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String campusId;
  final UserType userType;
  final double walletBalance;
  final String profileImage;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.campusId,
    required this.userType,
    this.walletBalance = 0.0,
    this.profileImage = '',
  });

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? campusId,
    UserType? userType,
    double? walletBalance,
    String? profileImage,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      campusId: campusId ?? this.campusId,
      userType: userType ?? this.userType,
      walletBalance: walletBalance ?? this.walletBalance,
      profileImage: profileImage ?? this.profileImage,
    );
  }
}

enum UserType { student, staff, vendor, admin }