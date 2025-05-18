import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:toeic_desktop/common/router/route_config.dart';
import 'package:toeic_desktop/common/utils/constants.dart';
import 'package:toeic_desktop/data/models/enums/test_show.dart';
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
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          const ProtipWidget(
            text:
                'Pro tips: Hình thức luyện tập từng phần và chọn mức thời gian phù hợp sẽ giúp bạn tập trung vào giải đúng các câu hỏi thay vì phải chịu áp lực hoàn thành bài thi.',
            backgroundColor: Colors.yellowAccent,
            textColor: Colors.orange,
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: 150,
            child: ElevatedButton(
              onPressed: () {
                GoRouter.of(context)
                    .pushReplacementNamed(AppRouter.practiceTest, extra: {
                  'testShow': TestShow.test,
                  'testId': testId,
                  'parts':
                      Constants.parts.map((part) => part.partEnum).toList(),
                  'duration': const Duration(minutes: 120),
                });
              },
              child: Text(
                'Bắt đầu thi'.toUpperCase(),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
