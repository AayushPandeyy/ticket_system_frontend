import 'package:ticketsystem/features/eventOrganizer/domain/entity/EventEntity.dart';
import 'package:ticketsystem/features/eventOrganizer/domain/repository/OrganizerRepository.dart';

class CreateEvent{
  final OrganizerRepository organizerRepository;

  CreateEvent({required this.organizerRepository});

  Future<Map<String, dynamic>> call(EventEntity event) async {
    return await organizerRepository.createEvent(event);
  }
}