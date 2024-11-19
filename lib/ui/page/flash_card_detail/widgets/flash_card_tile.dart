import 'package:flutter/material.dart';
import 'package:text_to_speech/text_to_speech.dart';

class FlashcardTile extends StatefulWidget {
  final Map<String, dynamic> flashcard;

  const FlashcardTile({super.key, required this.flashcard});

  @override
  State<FlashcardTile> createState() => _FlashcardTileState();
}

class _FlashcardTileState extends State<FlashcardTile> {
  late TextToSpeech flutterTts;
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    flutterTts = TextToSpeech()
      ..setVolume(1.0)
      ..setLanguage('en-US');
  }

  Future _speak(String word) async {
    await flutterTts.speak(word);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width * 0.6,
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    widget.flashcard['word'],
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),

                  // Add a button to play the pronunciation
                  InkWell(
                    onTap: () {
                      _speak(widget.flashcard['word']);
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.volume_up_outlined,
                          color: Colors.blue,
                        )),
                  )
                ],
              ),
              SizedBox(height: 8),
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
                                widget.flashcard['pronunciation']['uk'], 'UK'),
                            SizedBox(width: 16),
                            _buildPronunciation(
                                widget.flashcard['pronunciation']['us'], 'US'),
                          ],
                        ),
                        SizedBox(height: 8),
                        Text(
                          widget.flashcard['definition'],
                          style: TextStyle(fontSize: 16),
                        ),
                        if (widget.flashcard['examples'].isNotEmpty) ...[
                          SizedBox(height: 8),
                          ...widget.flashcard['examples'].map((example) => Text(
                                '- $example',
                                style: TextStyle(color: Colors.grey[700]),
                              )),
                        ],
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 300,
                    height: 200,
                    child: Image.network(widget.flashcard['image']),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPronunciation(String pronunciation, String label) {
    return Row(
      children: [
        Text(
          '$label:',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        SizedBox(width: 4),
        Text(
          pronunciation,
          style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
        ),
      ],
    );
  }
}
