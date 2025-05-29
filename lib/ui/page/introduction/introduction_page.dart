import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class IntroductionPage extends StatelessWidget {
  const IntroductionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Card(
          child: Container(
            padding: const EdgeInsets.all(16),
            width: double.infinity,
            child: const Column(
              children: [
                FirstIntroWidget(),
                Divider(),
                SecondIntroWidget(),
                Divider(),
                ThirdIntroWidget(),
                Divider(),
                TourIntroWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TourIntroWidget extends StatelessWidget {
  const TourIntroWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.sizeOf(context);
    return Column(
      children: [
        const SizedBox(height: 100),
        Text(
          'Cam kết của TOEIC Prepp',
          style: theme.textTheme.headlineSmall!.apply(
            fontWeightDelta: 2,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          margin: EdgeInsets.symmetric(
            horizontal: size.width / 4,
          ),
          child: const Text(
              'Chúng tôi tin rằng việc học TOEIC không cần phải phức tạp hay áp lực. Với TOEIC Prep, bạn sẽ trải nghiệm một cách học tập dễ dàng, thông minh và đầy động lực.'),
        ),
        const SizedBox(
          height: 3,
        ),
        SizedBox(
          width: 200,
          height: 45,
          child: ElevatedButton(
              onPressed: () {
                // GoRouter.of(context).go(AppRouter.home);
              },
              child: const Text('Bắt đầu học ngay')),
        ),
        const SizedBox(height: 100),
      ],
    );
  }
}

class ThirdIntroWidget extends StatelessWidget {
  const ThirdIntroWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.sizeOf(context);
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          const SizedBox(height: 100),
          Text(
            'Chúng tôi mang đến cho bạn',
            style: theme.textTheme.headlineSmall!.apply(
              fontWeightDelta: 2,
            ),
          ),
          const SizedBox(height: 3),
          const SizedBox(
            width: double.infinity,
            child: Row(
              children: [
                IntroCard(
                  icon: FontAwesomeIcons.fileLines,
                  title: 'Phân tích kết quả chi tiết',
                  message:
                      'Hiển thị điểm số và phân tích sâu hiệu suất từng phần, giúp bạn hiểu rõ điểm mạnh và điểm cần cải thiện.',
                ),
                SizedBox(width: 16),
                IntroCard(
                  icon: FontAwesomeIcons.chartLine,
                  title: 'Hiện đại và tiện lợi',
                  message:
                      'Mọi tài nguyên học tập đều trong tầm tay bạn, dù ở bất kỳ đâu, trên bất kỳ thiết bị nào.',
                ),
                SizedBox(width: 16),
                IntroCard(
                  icon: FontAwesomeIcons.lightbulb,
                  title: 'Flashcard từ vựng thông minh',
                  message:
                      'Phương pháp học từ vựng hiệu quả với công cụ tự động điền nội dung từ vựng và và dụ minh họa.',
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          SizedBox(
            width: double.infinity,
            child: Row(
              children: [
                const IntroCard(
                  icon: FontAwesomeIcons.brain,
                  title: 'AI giải thích đáp án',
                  message:
                      'Giải đáp thắc mắc chi tiết, giúp bạn hiểu rõ từng câu hỏi và tránh lặp lại sai lầm.',
                ),
                const SizedBox(width: 16),
                const IntroCard(
                  icon: FontAwesomeIcons.calculator,
                  title: 'Thống kê và theo dõi tiến độ',
                  message:
                      'Trang tổng quan hiển thị biểu đồ tiến bộ, lịch sử làm bài, và các chỉ số giúp bạn dễ dàng định hướng học tập.',
                ),
                const SizedBox(width: 16),
                Expanded(child: Container()),
              ],
            ),
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}

class SecondIntroWidget extends StatelessWidget {
  const SecondIntroWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        const SizedBox(height: 100),
        Text(
          'Vì sao nên chọn TOEIC Prep?',
          style: theme.textTheme.headlineSmall!.apply(
            fontWeightDelta: 2,
          ),
        ),
        const SizedBox(height: 16),
        const Row(
          children: [
            IntroCard(
              title: 'Hiện đại và tiện lợi',
              message:
                  'Mọi tài nguyên học tập đều trong tầm tay bạn, dù ở bất kỳ đâu, trên bất kỳ thiết bị nào.',
            ),
            SizedBox(width: 16),
            IntroCard(
              title: 'Cá nhân hóa',
              message:
                  'Lộ trình học và thi được thiết kế phù hợp với năng lực và mục tiêu của từng người học.',
            ),
            SizedBox(width: 16),
            IntroCard(
              title: 'Hỗ trợ bởi công nghệ AI',
              message:
                  'Đưa trải nghiệm học tập của bạn lên một tầm cao mới với các tính năng AI mạnh mẽ.',
            ),
          ],
        ),
        const SizedBox(height: 100),
      ],
    );
  }
}

class FirstIntroWidget extends StatelessWidget {
  const FirstIntroWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        const SizedBox(height: 100),
        Text(
          'Chào mừng đến với TOEIC Prep',
          style: theme.textTheme.headlineSmall!.apply(
            fontWeightDelta: 2,
          ),
        ),
        const SizedBox(height: 16),
        const Text(
            'Nền tảng học TOEIC hiện đại, tiện lợi và hiệu quả, giúp bạn dễ dàng chuẩn bị cho kỳ thi TOEIC một cách toàn diện.'),
        const SizedBox(height: 100),
      ],
    );
  }
}

class IntroCard extends StatelessWidget {
  const IntroCard({
    super.key,
    this.icon,
    required this.title,
    required this.message,
  });

  final IconData? icon;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Expanded(
      child: Card(
        child: LayoutBuilder(builder: (context, constraints) {
          final isMaxWidth = constraints.maxWidth > (1280 / 3 + 16);
          return Container(
            height: isMaxWidth ? 150 : 180,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: theme.brightness == Brightness.light
                    ? Colors.grey.shade200
                    : Colors.grey.shade800,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) FaIcon(icon, size: 32),
                if (icon != null) const SizedBox(height: 8),
                Text(
                  title,
                  style: theme.textTheme.bodyLarge!.apply(fontWeightDelta: 2),
                ),
                const SizedBox(height: 8),
                Text(message),
              ],
            ),
          );
        }),
      ),
    );
  }
}
