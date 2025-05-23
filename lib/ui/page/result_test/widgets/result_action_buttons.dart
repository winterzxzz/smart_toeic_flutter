
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:toeic_desktop/common/router/route_config.dart';
import 'package:toeic_desktop/data/models/enums/test_show.dart';
import 'package:toeic_desktop/data/models/ui_models/result_model.dart';
import 'package:toeic_desktop/ui/common/app_colors.dart';

class ResultActionButtons extends StatelessWidget {
  const ResultActionButtons({super.key, required this.resultModel});

  final ResultModel resultModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 18),
            backgroundColor: AppColors.primary,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 2,
          ),
          icon: const FaIcon(FontAwesomeIcons.eye, color: Colors.white),
          label: const Text(
            'View Answer',
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
          onPressed: () {
            GoRouter.of(context).pushReplacementNamed(
              AppRouter.practiceTest,
              extra: {
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
        OutlinedButton.icon(
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 18),
            side: const BorderSide(color: AppColors.textBlack, width: 1.5),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
          icon: const FaIcon(FontAwesomeIcons.arrowRotateLeft,
              color: AppColors.textBlack),
          label: const Text(
            'Back to test page',
            style: TextStyle(fontSize: 16, color: AppColors.textBlack),
          ),
          onPressed: () {
            GoRouter.of(context).pop();
          },
        ),
      ],
    );
  }
}
