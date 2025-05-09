import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:ticketsystem/core/service/SharedPreferenceService.dart';
import 'package:ticketsystem/features/auth/data/datasource/AuthDataSource.dart';

class AuthProvider with ChangeNotifier {
  bool _isLoading = false;
  String _message = '';
  bool _isLoggedIn = false;

  bool get isLoading => _isLoading;
  String get message => _message;
  bool get isLoggedIn => _isLoggedIn;

  // Handle login
  Future<void> login(String email, String password, String role) async {
    _isLoading = true;
    notifyListeners();

    try {
      Map<String, dynamic> data =
          await AuthDataSource().login(email, password, role);

      // Save tokens to shared preferences
      await SharedPreferencesService.saveToken(data["accessToken"]);
      await SharedPreferencesService.saveUserData(data['role'], data['uid']);

      _isLoggedIn = true;
      _message = 'Login successful!';
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _message = e.toString();
      print(_message);
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> register(String email, String password, String fullname,
      String mobileNumber, DateTime birthdate, String username) async {
    _isLoading = true;
    notifyListeners();

    try {
      Map<String, dynamic> data = await AuthDataSource().register(
          email, password, fullname, mobileNumber, birthdate, username);

      // Save tokens to shared preferences
      await SharedPreferencesService.saveToken(data["accessToken"]);
      await SharedPreferencesService.saveUserData(data['role'], data['uid']);

      _isLoggedIn = true;
      _message = 'Registration successful!';
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _message = e.toString();
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Logout the user
  Future<void> logout() async {
    try {
      await SharedPreferencesService.clearAllTokensAndUserData();
      _isLoggedIn = false;
      _message = 'Logged out successfully!';
    } catch (e) {
      _message = 'Logout failed: ${e.toString()}';
    } finally {
      notifyListeners();
    }
  }
}
