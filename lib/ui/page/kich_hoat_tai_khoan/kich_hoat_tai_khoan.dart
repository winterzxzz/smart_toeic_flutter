import 'package:flutter/material.dart';
import 'package:toeic_desktop/ui/common/app_colors.dart';

class PricingPlanScreen extends StatelessWidget {
  const PricingPlanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 32),
            Center(
              child: Text(
                'Chọn gói dịch vụ phù hợp với bạn',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                'Nâng cao kỹ năng TOEIC của bạn với các tính năng độc đáo',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textGray),
              ),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildPlanCard(
                  context,
                  title: 'Gói Miễn phí',
                  price: '0 VND',
                  features: [
                    'Làm bài thi TOEIC',
                    'Chấm điểm và lưu kết quả',
                    'Tạo bộ flashcard',
                    'Truy cập flashcards có sẵn',
                    'Truy cập blog',
                    'Điền tự động bằng AI',
                    'Lời giải AI cho câu hỏi',
                    'Phân tích chỉ số cá nhân',
                    'Trắc nghiệm và nhắc nhở',
                  ],
                  available: [
                    true,
                    true,
                    true,
                    true,
                    true,
                    false,
                    false,
                    false,
                    false
                  ],
                  isCurrentPlan: true,
                  onPressed: null,
                ),
                const SizedBox(width: 16),
                _buildPlanCard(
                  context,
                  title: 'Gói Nâng cấp',
                  price: '5.000 VND',
                  features: [
                    'Làm bài thi TOEIC',
                    'Chấm điểm và lưu kết quả',
                    'Tạo bộ flashcard',
                    'Truy cập flashcards có sẵn',
                    'Truy cập blog',
                    'Điền tự động bằng AI',
                    'Lời giải AI cho câu hỏi',
                    'Phân tích chỉ số cá nhân',
                    'Trắc nghiệm và nhắc nhở',
                  ],
                  available: [
                    true,
                    true,
                    true,
                    true,
                    true,
                    true,
                    true,
                    true,
                    true
                  ],
                  isCurrentPlan: false,
                  onPressed: () {
                    // Handle upgrade action
                  },
                ),
              ],
            ),
            const SizedBox(height: 32),
            Center(
              child: Column(
                children: [
                  Text(
                    'Vẫn còn thắc mắc?',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Liên hệ với chúng tôi để được hỗ trợ',
                    style: TextStyle(color: AppColors.textGray),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      // Handle contact support action
                    },
                    child: Text('Liên hệ hỗ trợ'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildPlanCard(
    BuildContext context, {
    required String title,
    required String price,
    required List<String> features,
    required List<bool> available,
    required bool isCurrentPlan,
    required VoidCallback? onPressed,
  }) {
    final Color backgroundColor =
        isCurrentPlan ? Colors.white : AppColors.primary;
    final Color textColor = isCurrentPlan ? Colors.black : Colors.white;
    final Color borderColor =
        isCurrentPlan ? Colors.grey.shade300 : Colors.black;
    return Container(
      width: MediaQuery.sizeOf(context).width * 0.3,
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Column(
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  price,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: features
                          .where(
                              (element) => available[features.indexOf(element)])
                          .length /
                      features.length,
                  backgroundColor: Colors.grey.shade300,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: List.generate(features.length, (index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    children: [
                      Icon(
                        available[index] ? Icons.check : Icons.close,
                        color: available[index] ? Colors.green : Colors.red,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          features[index],
                          style: TextStyle(
                            color: textColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 8),
          if (isCurrentPlan)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              width: double.infinity,
              child: ElevatedButton(
                onPressed: null,
                style: ElevatedButton.styleFrom(
                    side: BorderSide(color: Colors.grey.shade300),
                    backgroundColor: AppColors.backgroundDark),
                child: Text('Đang sử dụng'),
              ),
            )
          else
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: AppColors.primary,
                ),
                child: Text('Nâng cấp ngay'),
              ),
            ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
