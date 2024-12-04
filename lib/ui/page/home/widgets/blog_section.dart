import 'package:flutter/material.dart';
import 'package:toeic_desktop/common/utils/constants.dart';
import 'package:toeic_desktop/ui/common/app_colors.dart';
import 'package:toeic_desktop/ui/page/blog/widgets/blog_vertical.dart';

class BlogSection extends StatelessWidget {
  const BlogSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 32, 16, 0),
      child: Column(
        children: [
          Text(
            "Blog Knowledge",
            style: Theme.of(context).textTheme.headlineMedium!.apply(
                  color: AppColors.textBlack,
                  fontWeightDelta: 2,
                ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: Constants.blogs.take(4).map((blog) {
              return Expanded(
                child: BlogVerticalCard(blogItem: blog),
              );
            }).toList(),
          )
        ],
      ),
    );
  }
}
