import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final Color color;
  final IconData? trailingIcon;
  final bool isMultiline;
  final VoidCallback? onTap;
  final bool isNumber;

  const InputField({
    required this.label,
    required this.controller,
    required this.color,
    this.isNumber = false,
    this.isMultiline = false,
    super.key,
    this.trailingIcon, this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(label,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.grey)),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: TextFormField(
            keyboardType: isNumber ? TextInputType.number : TextInputType.text,
            controller: controller,
            maxLines: isMultiline ? 5 : 1,
            validator: (value) => (value == null || value.isEmpty)
                ? "This field is required"
                : null,
            decoration: InputDecoration(
              suffixIcon: trailingIcon != null
                  ? IconButton(icon : Icon(trailingIcon,color: color),onPressed: onTap,)
                  : null,
              hintText: " $label",
              hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
              enabledBorder: UnderlineInputBorder(),
              focusedBorder: UnderlineInputBorder(),
              errorBorder: UnderlineInputBorder(),
            ),
          ),
        ),
      ],
    );
  }
}
