import 'dart:async';

import 'package:flutter/material.dart';
import 'package:toeic_desktop/common/utils/time_utils.dart';
import 'package:toeic_desktop/language/generated/l10n.dart';

class TestLastStudiedAtTimeText extends StatefulWidget {
  const TestLastStudiedAtTimeText({
    super.key,
    required this.updatedAt,
    required this.createdAt,
  });

  final DateTime? updatedAt;
  final DateTime? createdAt;

  @override
  State<TestLastStudiedAtTimeText> createState() =>
      _TestLastStudiedAtTimeTextState();
}

class _TestLastStudiedAtTimeTextState extends State<TestLastStudiedAtTimeText> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text(
      '${S.current.last_time_taken} ${TimeUtils.timeAgo(widget.updatedAt ?? widget.createdAt!)}',
      style: theme.textTheme.bodySmall?.copyWith(
        color: theme.colorScheme.primary,
      ),
    );
  }
}
