import 'dart:io';
import 'package:flutter/material.dart';

class ImagePickerField extends StatelessWidget {
  final File? image;
  final VoidCallback onTap;
  final VoidCallback onRemove;
  final Color color;

  const ImagePickerField({
    required this.image,
    required this.onTap,
    required this.onRemove,
    required this.color,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 250,
        width: MediaQuery.sizeOf(context).width * 0.8,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: image == null ? Colors.grey[300]! : Colors.transparent,
            width: 1,
          ),
        ),
        child: image == null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_photo_alternate_rounded,
                      size: 50, color: color.withOpacity(0.7)),
                  const SizedBox(height: 10),
                  Text("Add a Photo",
                      style:
                          TextStyle(fontWeight: FontWeight.w500, color: color)),
                  const SizedBox(height: 4),
                  const Text("Tap to browse gallery",
                      style: TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              )
            : Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.file(image!,
                        fit: BoxFit.cover, width: double.infinity, height: 250),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: onRemove,
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.6),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.close,
                            color: Colors.white, size: 18),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
