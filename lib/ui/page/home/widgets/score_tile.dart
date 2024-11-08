import 'package:flutter/material.dart';

class ScoreTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final int score;
  final Color color;

  const ScoreTile({
    super.key,
    required this.icon,
    required this.label,
    required this.score,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, size: 28, color: color),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(color: Colors.black54, fontSize: 12),
            ),
            Text(
              score.toString(),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
