import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField(
      {super.key, required this.icon, required this.tag, required this.hintText});

  final IconData icon;
  final String tag;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Fixed part
        ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: 48.0, // Match the height of the TextField
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              border: Border.all(color: Colors.grey.shade400),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                bottomLeft: Radius.circular(8),
              ),
            ),
            child: Center(
              child: Row(
                children: [
                  Icon(
                    Icons.tag,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    tag,
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Editable part
        Expanded(
          child: TextField(
            decoration: InputDecoration(
              hintText: hintText,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade400),
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
