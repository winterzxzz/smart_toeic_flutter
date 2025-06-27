import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:toeic_desktop/common/utils/time_utils.dart';
import 'package:toeic_desktop/data/models/entities/flash_card/flash_card/flash_card_learning.dart';
import 'package:toeic_desktop/language/generated/l10n.dart';
import 'package:toeic_desktop/ui/common/app_colors.dart';

class FlashCardLearningTile extends StatefulWidget {
  final FlashCardLearning flashcard;

  const FlashCardLearningTile({super.key, required this.flashcard});

  @override
  State<FlashCardLearningTile> createState() => _FlashCardLearningTileState();
}

class _FlashCardLearningTileState extends State<FlashCardLearningTile> {
  late FlutterTts flutterTts;
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    flutterTts = FlutterTts()
      ..setVolume(1.0)
      ..setLanguage('en-US');
  }

  Future _speak(String word) async {
    await flutterTts.speak(word);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border(
              left: BorderSide(
                  color: _getColorFromDecayScore(
                      widget.flashcard.retentionScore ?? 0),
                  width: 5), // Left border
              top: BorderSide(
                  color: _getColorFromDecayScore(
                      widget.flashcard.retentionScore ?? 0),
                  width: 1), // Top border
              right: BorderSide(
                  color: _getColorFromDecayScore(
                      widget.flashcard.retentionScore ?? 0),
                  width: 1), // Right border
              bottom: BorderSide(
                  color: _getColorFromDecayScore(
                      widget.flashcard.retentionScore ?? 0),
                  width: 1), // Bottom border
            )),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Row(
                    children: [
                      Text(widget.flashcard.flashcardId?.word ?? '',
                          style: theme.textTheme.titleSmall),
                      const SizedBox(
                        width: 8,
                      ),
                      // Add a button to play the pronunciation
                      InkWell(
                        onTap: () {
                          _speak(widget.flashcard.flashcardId?.word ?? '');
                        },
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary
                                  .withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.volume_up_outlined,
                              color: theme.colorScheme.primary,
                            )),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withValues(alpha: 0.7),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      widget.flashcard.flashcardId?.partOfSpeech.join(', ') ??
                          '',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.textWhite,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          _buildPronunciation(
                              widget.flashcard.flashcardId?.pronunciation ?? '',
                              'UK'),
                        ],
                      ),
                      const SizedBox(height: 4),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '${S.current.translate}: ',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: widget.flashcard.flashcardId?.translation ??
                                  '',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '${S.current.definition}:',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(widget.flashcard.flashcardId?.definition ?? '',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontStyle: FontStyle.italic,
                          )),
                      Text(
                        '${S.current.example_sentences}:',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (widget.flashcard.flashcardId?.exampleSentence
                              .isNotEmpty ??
                          false) ...[
                        const SizedBox(height: 4),
                        ...widget.flashcard.flashcardId!.exampleSentence
                            .map((example) => Text(
                                  '- $example',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    fontStyle: FontStyle.italic,
                                  ),
                                )),
                      ],
                      const SizedBox(height: 4),
                      Text(
                        '${S.current.note}:',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(widget.flashcard.flashcardId?.note ?? '',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontStyle: FontStyle.italic,
                          )),
                      if (widget.flashcard.optimalTime != null)
                        Column(
                          children: [
                            const SizedBox(height: 4),
                            const Divider(),
                            const SizedBox(height: 4),
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                          color: theme.colorScheme.primary,
                                          width: 1),
                                    ),
                                    child: Text(
                                        'Review in: ${TimeUtils.getDiffDays(widget.flashcard.optimalTime!)} days (Initial interval: ${widget.flashcard.interval} days)',
                                        style: theme.textTheme.bodyMedium
                                            ?.copyWith(
                                          fontStyle: FontStyle.italic,
                                        )),
                                  ),
                                  const SizedBox(height: 4),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: _getColorFromRetentionScore(
                                          widget.flashcard.retentionScore ?? 0),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Text(
                                      'Retention: ${widget.flashcard.retentionScore?.toStringAsFixed(2) ?? ''}',
                                      style:
                                          theme.textTheme.bodyMedium?.copyWith(
                                        color: AppColors.textWhite,
                                        fontWeight: FontWeight.w500,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ),
                                ])
                          ],
                        )
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPronunciation(String pronunciation, String label) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Text(
          '$label:',
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          pronunciation,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }

  Color _getColorFromRetentionScore(double retentionScore) {
    if (retentionScore >= 4) {
      return Colors.green;
    } else if (retentionScore >= 3 && retentionScore < 4) {
      return Colors.yellow;
    } else if (retentionScore >= 2 && retentionScore < 3) {
      return Colors.orange;
    } else if (retentionScore >= 1 && retentionScore < 2) {
      return Colors.red;
    }
    return AppColors.primary;
  }

  Color _getColorFromDecayScore(double decayScore) {
    if (decayScore >= 0.7 && decayScore < 1) {
      return Colors.green;
    } else if (decayScore >= 0.5 && decayScore < 0.7) {
      return Colors.yellow;
    } else if (decayScore >= 0 && decayScore < 0.5) {
      return Colors.red;
    }
    return AppColors.primary;
  }
}
