import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:toeic_desktop/common/router/route_config.dart';
import 'package:toeic_desktop/common/utils/constants.dart';
import 'package:toeic_desktop/data/models/enums/test_show.dart';
import 'package:toeic_desktop/language/generated/l10n.dart';
import 'package:toeic_desktop/ui/common/widgets/custom_button.dart';
import 'package:toeic_desktop/ui/page/choose_mode_test/widgets/protip_widget.dart';

class FullTestMode extends StatelessWidget {
  const FullTestMode({
    super.key,
    required this.testId,
  });

  final String testId;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          ProtipWidget(
            text: S.current.full_mode_tips,
            backgroundColor: Colors.yellowAccent,
            textColor: Colors.orange,
          ),
          const SizedBox(height: 8),
          CustomButton(
            height: 50,
            onPressed: () {
              GoRouter.of(context)
                  .pushReplacementNamed(AppRouter.practiceTest, extra: {
                'testShow': TestShow.test,
                'testId': testId,
                'parts': Constants.parts.map((part) => part.partEnum).toList(),
                'duration': const Duration(minutes: 120),
              });
            },
            child: Text(
              S.current.start_test,
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
