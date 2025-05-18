import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:toeic_desktop/common/router/route_config.dart';
import 'package:toeic_desktop/data/models/entities/blog/blog.dart';

class BlogVerticalCard extends StatelessWidget {
  final Blog blog;
  const BlogVerticalCard({
    super.key,
    required this.blog,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          AppRouter.router.pushNamed(AppRouter.blogDetail, extra: {
            'blog': blog,
          });
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image takes up 40% of the card
            AspectRatio(
              aspectRatio: 10 / 4, // Adjust the aspect ratio as needed
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  blog.image ?? '',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    blog.title ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // Author
                  Text(
                    blog.description ?? '',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Content
                  Row(
                    children: [
                      _buildInfoItem(FontAwesomeIcons.eye, blog.view ?? 0),
                      const Spacer(),
                      Row(
                        children: [
                          const FaIcon(
                            FontAwesomeIcons.calendarDays,
                            color: Colors.grey,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            DateFormat('dd/MM/yyyy').format(
                              blog.createdAt ?? DateTime.now(),
                            ),
                            style: const TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, int count) {
    return Row(
      children: [
        FaIcon(
          icon,
          color: Colors.grey,
          size: 16,
        ),
        const SizedBox(width: 4),
        Text(
          count.toString(),
          style: const TextStyle(
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
