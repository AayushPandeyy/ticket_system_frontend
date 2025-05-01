import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ticketsystem/features/eventOrganizer/presentation/widgets/ImagePickerField.dart';
import 'package:ticketsystem/features/eventOrganizer/presentation/widgets/InputField.dart';
import 'package:ticketsystem/features/eventOrganizer/presentation/widgets/SubmitButton.dart';

class CreateEventScreen extends StatefulWidget {
  const CreateEventScreen({super.key});

  @override
  State<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  final _picker = ImagePicker();
  File? _image;
  final TextEditingController _eventTitleController = TextEditingController();
  final TextEditingController _eventDescriptionController =
      TextEditingController();
  final TextEditingController _eventDateController = TextEditingController();
  DateTime? selectedDate;
  final TextEditingController _eventTimeController = TextEditingController();
  final TextEditingController _eventCapacityController =
      TextEditingController();
  TimeOfDay? selectedTime;

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
    );

    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
        _eventTimeController.text = picked.format(context);
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        _eventDateController.text =
            "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => _image = File(pickedFile.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: const Text("Create Event"),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ImagePickerField(
                image: _image,
                onTap: _pickImage,
                onRemove: () => setState(() => _image = null),
                color: Colors.black,
              ),
              SizedBox(
                height: 16,
              ),
              InputField(
                  label: "Event Title",
                  controller: _eventTitleController,
                  color: Colors.black),
              SizedBox(
                height: 16,
              ),
              InputField(
                label: "Event Description",
                controller: _eventDescriptionController,
                color: Colors.black,
              ),
              SizedBox(
                height: 16,
              ),
              Row(
                children: [
                  Expanded(
                    child: InputField(
                        label: "Event Date",
                        trailingIcon: Icons.calendar_today,
                        controller: _eventDateController,
                        onTap: () => _selectDate(context),
                        color: Colors.black),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: InputField(
                      label: "Event Time",
                      controller: _eventTimeController,
                      trailingIcon: Icons.access_time,
                      onTap: () => _selectTime(context),
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 16,
              ),
              InputField(
                label: "Capacity",
                controller: _eventCapacityController,
                color: Colors.black,
                isNumber: true,
              ),
              SizedBox(
                height: 32,
              ),
              SubmitButton(
                onPressed: () {
                  // Handle form submission
                  if (_eventTitleController.text.isEmpty ||
                      _eventDescriptionController.text.isEmpty ||
                      _eventDateController.text.isEmpty ||
                      _eventTimeController.text.isEmpty ||
                      _eventCapacityController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Please fill all the fields")));
                  } else {
                    // Process the data
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Event Created Successfully")));
                  }
                },
                color: Colors.black,
                buttonText: "Create Event",
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
