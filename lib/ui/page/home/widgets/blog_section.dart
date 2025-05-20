import 'package:flutter/material.dart';
import 'package:toeic_desktop/data/models/entities/blog/blog.dart';
import 'package:toeic_desktop/ui/page/blogs/widgets/blog_horizontal.dart';

class BlogSection extends StatelessWidget {
  final List<Blog> blogs;
  const BlogSection({super.key, required this.blogs});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Blogs Knowledge",
              style: Theme.of(context).textTheme.titleLarge!.apply(
                    fontWeightDelta: 2,
                  ),
            ),
            TextButton(
              onPressed: () {
                // GoRouter.of(context).pushNamed(AppRouter.blog);
              },
              child: const Text('Xem tất cả'),
            ),
          ],
        ),
        Column(
          children: blogs.take(4).map((blog) {
            return BlogHorizontalCard(
              blog: blog,
            );
          }).toList(),
        )
      ],
    );
  }
}
