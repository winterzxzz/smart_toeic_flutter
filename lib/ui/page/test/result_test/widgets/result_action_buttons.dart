import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:toeic_desktop/common/router/route_config.dart';
import 'package:toeic_desktop/data/models/enums/test_show.dart';
import 'package:toeic_desktop/data/models/ui_models/result_model.dart';
import 'package:toeic_desktop/language/generated/l10n.dart';
import 'package:toeic_desktop/ui/common/app_context.dart';
import 'package:toeic_desktop/ui/common/widgets/custom_button.dart';

class ResultActionButtons extends StatelessWidget {
  const ResultActionButtons({super.key, required this.resultModel});

  final ResultModel resultModel;

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    final colorScheme = context.colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CustomButton(
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const FaIcon(FontAwesomeIcons.eye),
              const SizedBox(width: 8),
              Text(
                S.current.view_answer,
              ),
            ],
          ),
          onPressed: () {
            GoRouter.of(context).pushReplacementNamed(
              AppRouter.practiceTest,
              extra: {
                'title': resultModel.testName,
                'testShow': TestShow.result,
                'resultId': resultModel.resultId,
                'parts': resultModel.parts,
                'testId': resultModel.testId,
                'duration': resultModel.duration,
              },
            );
          },
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 50,
          child: OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: colorScheme.onSurface, width: 1.5),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
            ),
            icon: FaIcon(FontAwesomeIcons.arrowRotateLeft,
                size: 16, color: colorScheme.onSurface),
            label: Text(
              S.current.back_to_test_page,
              style: textTheme.bodyMedium,
            ),
            onPressed: () {
              GoRouter.of(context).pop();
            },
          ),
        ),
      ],
    );
  }
}
