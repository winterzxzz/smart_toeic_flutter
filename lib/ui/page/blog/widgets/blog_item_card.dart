import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:toeic_desktop/common/router/route_config.dart';
import 'package:toeic_desktop/data/models/entities/blog/blog.dart';
import 'package:toeic_desktop/ui/common/app_colors.dart';

class BlogItemCard extends StatelessWidget {
  const BlogItemCard({
    super.key,
    required this.blog,
  });

  final Blog blog;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      surfaceTintColor: Colors.transparent,
      clipBehavior: Clip.hardEdge,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          AppRouter.router.pushNamed(AppRouter.blogDetail, extra: {
            'blog': blog,
          });
        },
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // image
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    image: NetworkImage(blog.image ?? ''),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // title
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(blog.title ?? '',
                        style: Theme.of(context).textTheme.titleSmall),
                    const SizedBox(height: 8),
                    Text(
                      blog.description ?? '',
                      style: Theme.of(context).textTheme.bodySmall,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Row(
                          children: [
                            Icon(Icons.person,
                                size: 12, color: AppColors.textGray),
                            const SizedBox(width: 4),
                            Text(blog.author ?? '',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textGray,
                                )),
                          ],
                        ),
                        const SizedBox(width: 16),
                        // views
                        Row(
                          children: [
                            Icon(Icons.remove_red_eye,
                                size: 12, color: AppColors.textGray),
                            const SizedBox(width: 4),
                            Text(
                              (blog.view ?? 0).toString(),
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.textGray,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(width: 16),
                        Row(
                          children: [
                            Icon(Icons.calendar_month,
                                size: 12, color: AppColors.textGray),
                            const SizedBox(width: 4),
                            Text(
                              DateFormat('dd/MM/yyyy').format(
                                blog.createdAt ?? DateTime.now(),
                              ),
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.textGray,
                              ),
                            ),
                          ],
                        )
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
