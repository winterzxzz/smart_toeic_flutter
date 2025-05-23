import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:toeic_desktop/data/models/entities/blog/blog.dart';
import 'package:toeic_desktop/ui/common/app_colors.dart';
import 'package:toeic_desktop/ui/page/blog_detail/blog_detail_page.dart';

class BlogHorizontalCard extends StatelessWidget {
  final Blog blog;
  const BlogHorizontalCard({
    super.key,
    required this.blog,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          showBlogModalBottomSheet(context);
        },
        child: SizedBox(
          height: 110,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: SizedBox(
                  width: 130,
                  child: Image.network(
                    blog.image ?? '',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: getCategoryColor(blog.category ?? ''),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          blog.category ?? '',
                          style: theme.textTheme.labelMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                              color: AppColors.textWhite),
                        ),
                      ),
                      const SizedBox(height: 4),
                      // Title
                      Text(
                        blog.title ?? '',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleSmall,
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          Text(
                            'Read More',
                            style: theme.textTheme.labelMedium?.copyWith(
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const FaIcon(
                            FontAwesomeIcons.chevronRight,
                            size: 14,
                            color: AppColors.textGray,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color getCategoryColor(String category) {
    switch (category) {
      case 'Grammar':
        return AppColors.primary;
      case 'Study Tips':
        return AppColors.secondary;
      case 'Speaking':
        return Colors.orange;
      default:
        return AppColors.primary;
    }
  }

  void showBlogModalBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 1,
          minChildSize: 1,
          maxChildSize: 1,
          builder: (context, scrollController) {
            return BlogDetail(blog: blog);
          },
        );
      },
    );
  }
}
