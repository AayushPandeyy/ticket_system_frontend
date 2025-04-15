class UserEntity {
  final String username;
  final String email;
  final String fullName;
  final String password;
  final String phoneNumber;
  final DateTime dateOfBirth;

  UserEntity(
      {required this.username,
      required this.email,
      required this.fullName,
      required this.password,
      required this.phoneNumber,
      required this.dateOfBirth});
}
