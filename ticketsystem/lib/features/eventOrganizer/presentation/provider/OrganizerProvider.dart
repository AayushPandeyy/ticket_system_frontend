import 'package:flutter/material.dart';
import 'package:ticketsystem/features/eventOrganizer/data/datasource/OrganizerDataSoruce.dart';
import 'package:ticketsystem/features/eventOrganizer/data/repository_impl/OrganizerRepositoryImpl.dart';
import 'package:ticketsystem/features/eventOrganizer/domain/entity/EventEntity.dart';
import 'package:ticketsystem/features/eventOrganizer/domain/repository/OrganizerRepository.dart';
import 'package:ticketsystem/features/eventOrganizer/domain/usecase/CreateEventUseCase.dart';

class OrganizerProvider with ChangeNotifier {
  final CreateEvent createEventUseCase;
  Map<String, dynamic> _data = {};
  bool _isLoading = false;
  String _message = '';

  OrganizerProvider({required this.createEventUseCase});

  Map<String, dynamic> get data => _data;
  bool get isLoading => _isLoading;
  String get message => _message;

  // Handle login
  Future<void> createEvent(EventEntity event) async {
    _isLoading = true;
    notifyListeners();

    try {
      Map<String, dynamic> data =
          await createEventUseCase(event);
      _data = data;
      _message = 'Event Creation successful!';
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
}
