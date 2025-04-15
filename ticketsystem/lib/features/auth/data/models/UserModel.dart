import 'package:ticketsystem/features/auth/domain/entity/UserEntity.dart';

class UserModel extends UserEntity{
  UserModel({required super.username, required super.email, required super.fullName, required super.password, required super.phoneNumber, required super.dateOfBirth});
    factory UserModel.fromJson(Map<String, dynamic> json) {
      return UserModel(
        username: json['username'],
        email: json['email'],
        fullName: json['fullName'],
        password: json['password'],
        phoneNumber: json['phoneNumber'],
        dateOfBirth: DateTime.parse(json['dateOfBirth']),
      );
    }

    Map<String, dynamic> toJson() {
      return {
        'username': username,
        'email': email,
        'fullName': fullName,
        'password': password,
        'phoneNumber': phoneNumber,
        'dateOfBirth': dateOfBirth.toIso8601String(),
      };
    }
}