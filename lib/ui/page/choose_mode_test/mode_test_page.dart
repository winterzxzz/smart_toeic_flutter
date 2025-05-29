import 'package:flutter/material.dart';
import 'package:toeic_desktop/data/models/entities/test/test.dart';
import 'package:toeic_desktop/data/models/enums/mode_test.dart';
import 'package:toeic_desktop/language/generated/l10n.dart';
import 'package:toeic_desktop/ui/common/widgets/leading_back_button.dart';
import 'package:toeic_desktop/ui/page/choose_mode_test/widgets/custom_drop_down.dart';
import 'package:toeic_desktop/ui/page/choose_mode_test/widgets/full_mode_test.dart';
import 'package:toeic_desktop/ui/page/choose_mode_test/widgets/practive_test_mode.dart';



class ModeTestpage extends StatefulWidget {
  const ModeTestpage({super.key, required this.test});

  final Test test;

  @override
  State<ModeTestpage> createState() => _ModeTestpageState();
}

class _ModeTestpageState extends State<ModeTestpage> {
  bool isPracticeMode = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: Text(widget.test.title!),
            floating: true,
            leading: const LeadingBackButton(),
            actions: [
              Container(
                margin: const EdgeInsets.only(right: 16),
                height: 40,
                width: 150,
                child: CustomDropdownExample<String>(
                  data: [ModeTest.practice.name, ModeTest.full.name],
                  dataString: [ModeTest.practice.name, ModeTest.full.name],
                  onChanged: (value) {
                    setState(() {
                      isPracticeMode = value == ModeTest.practice.name;
                    });
                  },
                ),
              ),
            ],
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.test.attemptCount != null &&
                      widget.test.attemptCount! > 0) ...[
                    Text(
                      '${widget.test.attemptCount} ${S.current.attempt_count}',
                      style: theme.textTheme.bodySmall,
                    ),
                    const SizedBox(height: 16),
                  ],
                  isPracticeMode
                      ? PracticeMode(testId: widget.test.id!)
                      : FullTestMode(testId: widget.test.id!),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
