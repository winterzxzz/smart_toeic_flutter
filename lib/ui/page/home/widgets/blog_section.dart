import 'package:flutter/material.dart';
import 'package:toeic_desktop/data/models/entities/blog/blog.dart';
import 'package:toeic_desktop/ui/page/blog/widgets/blog_vertical.dart';

class BlogSection extends StatelessWidget {
  final List<Blog> blogs;
  const BlogSection({super.key, required this.blogs});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const SizedBox(width: 16),
            IgnorePointer(
              ignoring: true,
              child: Opacity(
                opacity: 0,
                child: TextButton(
                  onPressed: () {},
                  child: Text('Xem tất cả'),
                ),
              ),
            ),
            const Spacer(),
            Text(
              "Blogs Knowledge",
              style: Theme.of(context).textTheme.headlineMedium!.apply(
                    fontWeightDelta: 2,
                  ),
            ),
            const Spacer(),
            TextButton(
              onPressed: () {
                // GoRouter.of(context).pushNamed(AppRouter.blog);
              },
              child: Text('Xem tất cả'),
            ),
            const SizedBox(width: 16),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: blogs.take(4).map((blog) {
            return Expanded(
              child: SizedBox(
                height: 300,
                child: BlogVerticalCard(
                  blog: blog,
                ),
              ),
            );
          }).toList(),
        )
      ],
    );
  }
}
