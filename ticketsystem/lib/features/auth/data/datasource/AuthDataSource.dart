import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:ticketsystem/core/exceptions/AuthException.dart';

class AuthDataSource {
  final Dio dio;

  AuthDataSource({Dio? dio}) : dio = dio ?? Dio();

  Future<Map<String, dynamic>> login(
      String email, String password, String role) async {
    try {
      String url = '${dotenv.env["BASE_URL"]}auth/login';
      final response = await dio.post(
        url,
        data: {'email': email, 'password': password, 'role': role},
      );

      if (response.statusCode == 200) {
        final token = response.data['data']['token'];
        Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
        final String role = decodedToken['user']['role'];
        final String uid = decodedToken['user']['id'];
        return {'accessToken': token, 'role': role, 'uid': uid};
      } else {
        // Handle unexpected success status codes (201, 202, etc.)
        throw AuthException(
            response.statusCode ?? -1,
            response.data["message"] ??
                'Unexpected success status code: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        final statusCode = e.response?.statusCode;
        final message = e.response?.data['message'] ?? e.message;

        switch (statusCode) {
          case 400:
            throw AuthException(400, 'Invalid email, password, or role!');
          case 401:
            throw AuthException(
                401, 'Unauthorized access. Please login again.');
          case 403:
            throw AuthException(
                403, 'Access forbidden. You don\'t have permission.');
          case 404:
            throw AuthException(
                404, 'Login endpoint not found. Please contact support.');
          case 422:
            throw AuthException(422, 'Validation failed: $message');
          case 429:
            throw AuthException(
                429, 'Too many login attempts. Please try again later.');
          case 500:
            throw AuthException(500, 'Server error. Please try again later.');
          case 502:
            throw AuthException(502, 'Bad gateway. Please try again later.');
          case 503:
            throw AuthException(
                503, 'Service unavailable. Please try again later.');
          case 504:
            throw AuthException(
                504, 'Gateway timeout. Please try again later.');
          default:
            throw AuthException(statusCode ?? -1, 'Login failed: $message');
        }
      } else if (e.type == DioExceptionType.connectionTimeout) {
        throw AuthException(-2,
            'Connection timed out. Please check your internet and try again.');
      } else if (e.type == DioExceptionType.receiveTimeout) {
        throw AuthException(
            -3, 'Server response timeout. Please try again later.');
      } else if (e.type == DioExceptionType.connectionError) {
        throw AuthException(
            -4, 'Please check your internet connection and try again.');
      } else {
        throw AuthException(-5, 'Network error: ${e.message}');
      }
    } catch (e) {
      throw AuthException(-6, 'Unexpected error during login: $e');
    }
  }

  Future<Map<String, dynamic>> register(
    String email,
    String password,
    String fullname,
    String mobileNumber,
    DateTime birthdate,
    String username,
  ) async {
    try {
      String url = '${dotenv.env["BASE_URL"]}auth/register';
      final response = await dio.post(
        url,
        data: {
          'email': email,
          'password': password,
          'username': username,
          'fullname': fullname,
          'phoneNumber': mobileNumber,
          'dateOfBirth': birthdate.toIso8601String(),
        },
      );

      if (response.statusCode == 200) {
        final token = response.data['data']['token'];
        return {'accessToken': token};
      } else if (response.statusCode == 201) {
        // Some APIs return 201 for successful creation
        final token = response.data['data']?['token'];
        if (token != null) {
          return {'accessToken': token};
        } else {
          throw AuthException(201,
              'Account created but token missing. Please login separately.');
        }
      } else {
        // Handle unexpected success status codes
        throw AuthException(
            response.statusCode ?? -1,
            response.data["message"] ??
                'Unexpected success status code: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        final statusCode = e.response?.statusCode;
        final message = e.response?.data['message'] ?? e.message;

        switch (statusCode) {
          case 400:
            throw AuthException(400, 'Invalid registration data: $message');
          case 401:
            throw AuthException(401, 'Unauthorized access.');
          case 403:
            throw AuthException(
                403, 'Registration forbidden. Please contact support.');
          case 404:
            throw AuthException(404,
                'Registration endpoint not found. Please contact support.');
          case 409:
            throw AuthException(
                409, 'Account already exists with this email or username.');
          case 422:
            throw AuthException(422, 'Validation failed: $message');
          case 429:
            throw AuthException(
                429, 'Too many registration attempts. Please try again later.');
          case 500:
            throw AuthException(500, 'Server error. Please try again later.');
          case 502:
            throw AuthException(502, 'Bad gateway. Please try again later.');
          case 503:
            throw AuthException(
                503, 'Service unavailable. Please try again later.');
          case 504:
            throw AuthException(
                504, 'Gateway timeout. Please try again later.');
          default:
            throw AuthException(
                statusCode ?? -1, 'Registration failed: $message');
        }
      } else if (e.type == DioExceptionType.connectionTimeout) {
        throw AuthException(-2,
            'Connection timed out. Please check your internet and try again.');
      } else if (e.type == DioExceptionType.receiveTimeout) {
        throw AuthException(
            -3, 'Server response timeout. Please try again later.');
      } else if (e.type == DioExceptionType.connectionError) {
        throw AuthException(
            -4, 'Please check your internet connection and try again.');
      } else {
        throw AuthException(-5, 'Network error: ${e.message}');
      }
    } catch (e) {
      throw AuthException(-6, 'Unexpected error during registration: $e');
    }
  }
}
