import 'package:ticketsystem/features/eventOrganizer/domain/entity/EventEntity.dart';

abstract class OrganizerRepository {
  Future<Map<String,dynamic>> createEvent(EventEntity event);
}