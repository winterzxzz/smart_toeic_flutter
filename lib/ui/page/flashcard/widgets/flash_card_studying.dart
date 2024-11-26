
import 'package:flutter/material.dart';
import 'package:toeic_desktop/ui/page/flashcard/widgets/flash_card_grid.dart';

class StudyingFlashCardPage extends StatefulWidget {
  const StudyingFlashCardPage({
    super.key,
  });

  @override
  State<StudyingFlashCardPage> createState() => _StudyingFlashCardPageState();
}

class _StudyingFlashCardPageState extends State<StudyingFlashCardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              const SizedBox(height: 32),
              SizedBox(
                width: MediaQuery.sizeOf(context).width * 0.5,
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                          onPressed: () {
                            _showCreateFlashcardDialog();
                          },
                          child: Text('Tạo flashcard')),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                            child: ElevatedButton(
                                onPressed: () {},
                                child: Text(
                                  'Đang học',
                                ))),
                        const SizedBox(width: 16),
                        Expanded(
                            child: ElevatedButton(
                                onPressed: () {}, child: Text('Khám phá'))),
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(height: 32),
              FlashcardGrid(),
            ],
          ),
        ),
      ),
    );
  }

  void _showCreateFlashcardDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tạo Flashcard'),
        content: SizedBox(
          width: MediaQuery.sizeOf(context).width * 0.5,
          height: MediaQuery.sizeOf(context).width * 0.5,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              TextField(
                decoration: InputDecoration(
                  labelText: 'Từ vựng',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Nghĩa',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Tạo'),
          ),
        ],
      ),
    );
  }
}
