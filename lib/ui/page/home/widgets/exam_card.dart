import 'package:flutter/material.dart';
import 'package:toeic_desktop/ui/page/home/widgets/info_chip.dart';

class ExamCard extends StatelessWidget {
  final String title;
  final String description;
  final String time;
  final String questions;
  final String comments;
  final String parts;

  const ExamCard({
    super.key,
    required this.title,
    required this.description,
    required this.time,
    required this.questions,
    required this.comments,
    required this.parts,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 4,
      child: Container(
        width: double.infinity,
        height: 210,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                InfoChip(icon: Icons.access_time, label: time),
                InfoChip(icon: Icons.library_books, label: questions),
                InfoChip(icon: Icons.comment, label: comments),
                InfoChip(icon: Icons.layers, label: parts),
              ],
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black, // Button background color
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Take Test',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
