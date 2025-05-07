import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:toeic_desktop/data/models/entities/blog/blog.dart';

class BlogHorizontalCard extends StatelessWidget {
  final Blog blog;
  const BlogHorizontalCard({
    super.key,
    required this.blog,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          // GoRouter.of(context).pushNamed(AppRouter.blog, extra: {
          //   'blogId': blog.id,
          // });
        },
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
                child: SizedBox(
                  width: 200,
                  child: Image.network(
                    blog.image ?? '',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text(
                        blog.title ?? '',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Description
                      Text(
                        blog.description ?? '',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Footer with views and date
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
              ),
            ],
          ),
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
