import 'package:flutter/material.dart';
import 'package:toeic_desktop/ui/common/app_colors.dart';

class FlashCardMyListItem extends StatelessWidget {
  const FlashCardMyListItem({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Card(
      child: InkWell(
        customBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        onTap: () {},
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.gray2),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Word learned'),
                  Icon(Icons.check_circle_outline_outlined,
                      color: Colors.green),
                ],
              ),
              Text(
                '1,234',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              Text(
                'You\'ve learned 1,234 words so far',
                style: TextStyle(color: AppColors.textGray),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
