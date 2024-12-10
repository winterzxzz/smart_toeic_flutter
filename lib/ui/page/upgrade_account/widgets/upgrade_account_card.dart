import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toeic_desktop/common/global_blocs/user/user_cubit.dart';
import 'package:toeic_desktop/ui/common/app_colors.dart';

class UpgradeAccountCard extends StatelessWidget {
  const UpgradeAccountCard({
    super.key,
    required this.title,
    required this.price,
    required this.features,
    required this.available,
    required this.isCurrentPlan,
    this.onPressed,
  });

  final String title;
  final String price;
  final List<String> features;
  final List<bool> available;
  final bool isCurrentPlan;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
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
                child: Text('Free'),
              ),
            )
          else
            BlocBuilder<UserCubit, UserState>(
              builder: (context, state) {
                final isPremium = state.user?.accountType != 'basic';
                if (isPremium) return const SizedBox.shrink();
                return Container(
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
                );
              },
            ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
