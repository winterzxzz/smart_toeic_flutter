import 'package:flutter/material.dart';
import 'package:toeic_desktop/data/models/entities/test/test.dart';
import 'package:toeic_desktop/data/models/enums/mode_test.dart';
import 'package:toeic_desktop/language/generated/l10n.dart';
import 'package:toeic_desktop/ui/common/app_context.dart';
import 'package:toeic_desktop/ui/common/widgets/leading_back_button.dart';
import 'package:toeic_desktop/ui/page/test/choose_mode_test/widgets/full_mode_test.dart';
import 'package:toeic_desktop/ui/page/test/choose_mode_test/widgets/mode_switcher.dart';
import 'package:toeic_desktop/ui/page/test/choose_mode_test/widgets/practive_test_mode.dart';

class ModeTestpage extends StatefulWidget {
  const ModeTestpage({super.key, required this.test});

  final Test test;

  @override
  State<ModeTestpage> createState() => _ModeTestpageState();
}

class _ModeTestpageState extends State<ModeTestpage> {
  ModeTest _currentMode = ModeTest.practice;

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: Text(
              widget.test.title!,
              style: textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            pinned: true,
            floating: false,
            toolbarHeight: 60,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            surfaceTintColor: Colors.transparent,
            leading: const LeadingBackButton(),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ModeSwitcher(
                    currentMode: _currentMode,
                    onModeChanged: (mode) {
                      setState(() {
                        _currentMode = mode;
                      });
                    },
                  ),
                  const SizedBox(height: 24),
                  if (widget.test.attemptCount != null &&
                      widget.test.attemptCount! > 0) ...[
                    Text(
                      '${widget.test.attemptCount} ${S.current.attempt_count}',
                      style: textTheme.bodySmall,
                    ),
                    const SizedBox(height: 8),
                  ],
                  _currentMode == ModeTest.practice
                      ? PracticeMode(
                          testId: widget.test.id!,
                          title: widget.test.title!,
                        )
                      : FullTestMode(
                          testId: widget.test.id!,
                          title: widget.test.title!,
                        ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
