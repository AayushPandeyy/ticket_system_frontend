import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AuthDataSource{
  final Dio dio;

  AuthDataSource({Dio? dio}) : dio = dio ?? Dio();


    Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      String url = '${dotenv.env["BASE_URL"]}auth/login';

      // API call
      final response = await dio.post(
        url,
        data: {'email': email, 'password': password},
      );

      if (response.statusCode == 200) {
        final token = response.data['token'];

        

        // Construct a Map with the needed information
        return {
          'accessToken': token
        };
      } else if (response.statusCode == 400) {
        throw Exception('Invalid email or password.');
      } else {
        throw Exception('Failed to log in. ${response.statusMessage}');
      }
    } on DioException catch (e) {
      if (e.response != null && e.response?.statusCode == 400) {
        throw Exception('Invalid email or password.');
      } else {
        throw Exception('Please Connect to the Internet and Try Again.');
      }
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }
}