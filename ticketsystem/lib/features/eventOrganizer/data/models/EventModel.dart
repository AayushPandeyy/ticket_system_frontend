import 'package:flutter/material.dart';
import 'package:ticketsystem/features/eventOrganizer/domain/entity/EventEntity.dart';

class EventModel extends EventEntity{
  EventModel({required super.title, required super.date, required super.location, required super.capacity, required super.category, required super.eventImage, required super.description, required super.startTime});
  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      title: json['title'],
      date: DateTime.parse(json['date']),
      location: json['location'],
      capacity: json['capacity'],
      category: json['category'],
      eventImage: json['eventImage'],
      description: json['description'],
      startTime: TimeOfDay(
        hour: int.parse(json['startTime'].split(':')[0]),
        minute: int.parse(json['startTime'].split(':')[1]),
      ), // Convert startTime to TimeOfDay
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'date': date.toIso8601String(),
      'location': location,
      'capacity': capacity,
      'category': category,
      'eventImage': eventImage,
      'description': description,
      'startTime': '${startTime.hour}:${startTime.minute}', 

    };
  }
}