import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:toeic_desktop/data/models/entities/blog/blog.dart';
import 'package:toeic_desktop/language/generated/l10n.dart';
import 'package:toeic_desktop/ui/common/app_colors.dart';
import 'package:toeic_desktop/ui/common/app_context.dart';
import 'package:toeic_desktop/ui/common/app_images.dart';
import 'package:toeic_desktop/ui/common/widgets/loading_circle.dart';
import 'package:toeic_desktop/ui/page/blog_detail/blog_detail_page.dart';

class BlogHorizontalCard extends StatelessWidget {
  final Blog blog;
  const BlogHorizontalCard({
    super.key,
    required this.blog,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    final colorScheme = context.colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16.r),
        onTap: () {
          showBlogModalBottomSheet(context);
        },
        child: SizedBox(
          height: 120.w,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                ),
                child: SizedBox(
                  width: 120.w,
                  child: CachedNetworkImage(
                    imageUrl: blog.image ?? '',
                    fit: BoxFit.cover,
                    placeholder: (context, url) => const Center(
                      child: LoadingCircle(size: 24),
                    ),
                    errorWidget: (context, url, error) => Image.asset(
                      AppImages.bgImagePlaceholder,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(12.r),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.w,
                              vertical: 4.w,
                            ),
                            decoration: BoxDecoration(
                              color: getCategoryColor(blog.category ?? '')
                                  .withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Text(
                              blog.category ?? '',
                              style: textTheme.labelSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: getCategoryColor(blog.category ?? ''),
                              ),
                            ),
                          ),
                          8.verticalSpace,
                          Text(
                            blog.title ?? '',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              height: 1.2,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            S.current.read_more,
                            style: textTheme.labelMedium?.copyWith(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          4.horizontalSpace,
                          FaIcon(
                            FontAwesomeIcons.arrowRight,
                            size: 12.spMin,
                            color: colorScheme.primary,
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
