// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:flutter/material.dart';

class EventEntity {
  String title;
  String description;
  DateTime date;
  File eventImage;
  String location;
  int capacity;
  String category;
  TimeOfDay startTime;
  
  EventEntity({
    required this.title,
    required this.description,
    required this.date,
    required this.eventImage,
    required this.location,
    required this.capacity,
    required this.category,
    required this.startTime,
  });

}
