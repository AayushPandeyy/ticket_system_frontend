import 'package:ticketsystem/features/eventOrganizer/data/datasource/OrganizerDataSoruce.dart';
import 'package:ticketsystem/features/eventOrganizer/domain/entity/EventEntity.dart';
import 'package:ticketsystem/features/eventOrganizer/domain/repository/OrganizerRepository.dart';

class OrganizerRepositoryImpl implements OrganizerRepository{
  final OrganizerDataSource organizerDataSource;
  OrganizerRepositoryImpl(this.organizerDataSource);
  @override
  Future<Map<String, dynamic>> createEvent(EventEntity event) {
    
    return organizerDataSource.createEvent(event);
  }
  
}