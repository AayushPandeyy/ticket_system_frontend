import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:ticketsystem/core/exceptions/EventException.dart';
import 'package:ticketsystem/core/service/SharedPreferenceService.dart';
import 'package:ticketsystem/features/eventOrganizer/domain/entity/EventEntity.dart';

class OrganizerDataSource {
  final Dio dio;
  OrganizerDataSource({Dio? dio}) : dio = dio ?? Dio();
  Future<Map<String, dynamic>> createEvent(EventEntity event) async {
    String url = '${dotenv.env["BASE_URL"]}events/createEvent';
    String? token = await SharedPreferencesService.getAccessToken();
    try {
      FormData formData = FormData.fromMap({
        'title': event.title,
        'date': event.date.toIso8601String(),
        'location': event.location,
        'capacity': event.capacity,
        'category': event.category,
        'description': event.description,
        'startTime': event.startTime,
        'eventImage': await MultipartFile.fromFile(
          event.eventImage.path,
          filename: event.eventImage.path.split('/').last,
        ),
      });

      final response = await dio.post(
        url,
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'multipart/form-data',
          },
        ),
      );
      if (response.statusCode == 201) {
        return response.data;
      } else {
        throw EventException(response.statusCode!, 'Failed to create event.');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        final statusCode = e.response?.statusCode;
        final message = e.response?.data['message'] ?? e.message;

        switch (statusCode) {
          case 400:
            throw EventException(
                400, 'Invalid data sent! Please recheck your input');
          case 401:
            throw EventException(
                401, 'Unauthorized access. Please login again.');
          case 403:
            throw EventException(
                403, 'Access forbidden. You don\'t have permission.');
          case 404:
            throw EventException(
                404, 'Login endpoint not found. Please contact support.');
          case 422:
            throw EventException(422, 'Validation failed: $message');
          case 429:
            throw EventException(429,
                'Too many event creation attempts. Please try again later.');
          case 500:
            throw EventException(500, 'Server error. Please try again later.');
          case 502:
            throw EventException(502, 'Bad gateway. Please try again later.');
          case 503:
            throw EventException(
                503, 'Service unavailable. Please try again later.');
          case 504:
            throw EventException(
                504, 'Gateway timeout. Please try again later.');
          default:
            throw EventException(
                statusCode ?? -1, 'Event creation failed: $message');
        }
      } else if (e.type == DioExceptionType.connectionTimeout) {
        throw EventException(-2,
            'Connection timed out. Please check your internet and try again.');
      } else if (e.type == DioExceptionType.receiveTimeout) {
        throw EventException(
            -3, 'Server response timeout. Please try again later.');
      } else if (e.type == DioExceptionType.connectionError) {
        throw EventException(
            -4, 'Please check your internet connection and try again.');
      } else {
        throw EventException(-5, 'Network error: ${e.message}');
      }
    } catch (e) {
      throw EventException(-6, 'Unexpected error during login: $e');
    }
  }
}
