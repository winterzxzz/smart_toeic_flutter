import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:toeic_desktop/data/models/entities/blog/blog.dart';
import 'package:toeic_desktop/ui/common/app_colors.dart';
import 'package:toeic_desktop/ui/page/blog/blog_cubit.dart';
import 'package:toeic_desktop/ui/page/blog/blog_state.dart';

class BlogItemCard extends StatelessWidget {
  const BlogItemCard({
    super.key,
    required this.blog,
  });

  final Blog blog;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<BlogCubit, BlogState, Blog?>(
      selector: (state) {
        return state.focusBlog;
      },
      builder: (context, focusBlog) {
        final Color color = focusBlog != null
            ? focusBlog.id == blog.id
                ? Theme.of(context).colorScheme.primary.withOpacity(0.12)
                : Colors.transparent
            : Colors.transparent;
        return Card(
          elevation: 2,
          surfaceTintColor: Colors.transparent,
          clipBehavior: Clip.hardEdge,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: InkWell(
            onTap: () {
              context.read<BlogCubit>().setFocusBlog(blog);
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color,
              ),
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
      },
    );
  }
}
