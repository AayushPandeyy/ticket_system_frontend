import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:ticketsystem/features/eventOrganizer/domain/entity/EventEntity.dart';
import 'package:ticketsystem/features/eventOrganizer/presentation/provider/OrganizerProvider.dart';
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
  final TextEditingController _eventLocationController =
      TextEditingController();
  final TextEditingController _eventDateController = TextEditingController();
  DateTime? selectedDate;
  final TextEditingController _eventTimeController = TextEditingController();
  final TextEditingController _eventCapacityController =
      TextEditingController();
  TimeOfDay? selectedTime;
  String? imagePath;
  final List<String> categories = [
    "concert",
    "conference",
    "workshop",
    "festival",
    "other"
  ];
  String? selectedCategory;

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
      setState(() {
        _image = File(pickedFile.path);
        imagePath = pickedFile.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Consumer<OrganizerProvider>(builder: (context, provider, child) {
      return Scaffold(
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
                InputField(
                  label: "Event Location",
                  controller: _eventLocationController,
                  color: Colors.black,
                ),
                SizedBox(
                  height: 16,
                ),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                  ),
                  hint: Text(
                    'Select an option',
                    style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                  ),
                  value: selectedCategory,
                  items: categories
                      .map((item) => DropdownMenuItem(
                            value: item,
                            child: Text(item, style: TextStyle(fontSize: 16)),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedCategory = value;
                    });

                    // setState or use a controller if needed
                    print("Selected: $value");
                  },
                  dropdownColor: Colors.white,
                  icon: Icon(Icons.arrow_drop_down, color: Colors.black),
                ),
                SizedBox(height: 10),
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
                  onPressed: () async {
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
                      EventEntity event = EventEntity(
                        title: _eventTitleController.text,
                        description: _eventDescriptionController.text,
                        date: selectedDate!,
                        startTime: selectedTime!,
                        capacity: int.parse(_eventCapacityController.text),
                        eventImage: _image!,
                        location: _eventLocationController.text,
                        category: selectedCategory!,
                      );
                      try {
                        await provider.createEvent(event);
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Event created successfully!")));
                        setState(() {
                          _image = null;
                          _eventTitleController.clear();
                          _eventDescriptionController.clear();
                          _eventLocationController.clear();
                          _eventDateController.clear();
                          _eventTimeController.clear();
                          _eventCapacityController.clear();
                          selectedDate = null;
                          selectedTime = null;
                          selectedCategory = null;
                        });
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Error: ${e.toString()}")));
                      }
                    }
                  },
                  color: Colors.black,
                  buttonText:
                      provider.isLoading ? "Creating Event" : "Create Event",
                ),
                SizedBox(
                  height: 16,
                ),
              ],
            ),
          ),
        ),
      );
    }));
  }
}
