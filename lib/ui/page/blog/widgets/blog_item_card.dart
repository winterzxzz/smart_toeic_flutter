
import 'package:flutter/material.dart';
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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell( 
        onTap: () {
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // image
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
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
                  Text(blog.title ?? '', style: Theme.of(context).textTheme.titleSmall),
                  Text(blog.description ?? '', style: Theme.of(context).textTheme.bodyMedium, maxLines: 2, overflow: TextOverflow.ellipsis,),
                  Row(
                    children: [
                      Row(
                        children: [
                          Icon(Icons.person),
                          const SizedBox(width: 4),
                          Text(blog.author ?? '')
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
    );
  }
}
