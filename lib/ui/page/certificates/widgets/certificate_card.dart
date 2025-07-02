import 'package:flutter/material.dart';
import 'package:toeic_desktop/data/models/ui_models/certificate.dart';
import 'package:toeic_desktop/ui/common/app_colors.dart';
import 'package:toeic_desktop/ui/page/certificates/widgets/certificate_score_item.dart';

class CertificateCard extends StatelessWidget {
  final Certificate certificate;
  const CertificateCard({super.key, required this.certificate});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: certificate.isValid
              ? AppColors.gray1
              : theme.colorScheme.error.withValues(alpha: 0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: certificate.levelColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: certificate.levelColor.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Text(
                    certificate.scoreLevel,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: certificate.levelColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const Spacer(),
                if (!certificate.isValid)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.error.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Expired',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.error,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                const SizedBox(width: 8),
                Text(
                  'ID: ${certificate.tokenId}',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.hintColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              certificate.name,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'National ID: ${certificate.nationalId}',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.hintColor,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: CertificateScoreItem(
                    label: 'Reading',
                    score: certificate.readingScore,
                    icon: Icons.book_outlined,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: CertificateScoreItem(
                    label: 'Listening',
                    score: certificate.listeningScore,
                    icon: Icons.headphones_outlined,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: CertificateScoreItem(
                    label: 'Total',
                    score: certificate.totalScore,
                    icon: Icons.analytics_outlined,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(
                  Icons.date_range,
                  size: 16,
                  color: theme.hintColor,
                ),
                const SizedBox(width: 4),
                Text(
                  'Issued: ${_formatDate(certificate.issueDate)}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.hintColor,
                  ),
                ),
                const Spacer(),
                Icon(
                  Icons.schedule,
                  size: 16,
                  color: theme.hintColor,
                ),
                const SizedBox(width: 4),
                Text(
                  'Expires: ${_formatDate(certificate.expirationDate)}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.hintColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}
