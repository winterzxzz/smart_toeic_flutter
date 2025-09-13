import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:toeic_desktop/ui/common/app_context.dart';
import 'package:toeic_desktop/ui/common/widgets/custom_button.dart';

class EnterTitleModel extends StatefulWidget {
  const EnterTitleModel({super.key, required this.onEnterTitle, required this.liveName});
  final Function(String) onEnterTitle;
  final String liveName;

  @override
  State<EnterTitleModel> createState() => _EnterTitleModelState();
}

class _EnterTitleModelState extends State<EnterTitleModel> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.liveName);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    final viewInsets = MediaQuery.viewInsetsOf(context);
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: 16 + viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Enter Title',
            style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _controller,
            autofocus: true,
            decoration: InputDecoration(
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          const SizedBox(height: 16),
          CustomButton(
            width: double.infinity,
            onPressed: () {
              widget.onEnterTitle(_controller.text);
              GoRouter.of(context).pop();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
