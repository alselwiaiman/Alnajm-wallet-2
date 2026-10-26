class UserEntity {
  final String id;
  final String email;
  final String fullName;
  final String? phoneNumber;
  final bool isVerified;

  UserEntity({
    required this.id,
    required this.email,
    required this.fullName,
    this.phoneNumber,
    this.isVerified = false,
  });
}
