import 'package:flutter/material.dart';
import 'package:toeic_desktop/ui/page/flashcard/widgets/flash_card_grid.dart';

class FlashCardPage extends StatefulWidget {
  const FlashCardPage({super.key});

  @override
  State<FlashCardPage> createState() => _FlashCardPageState();
}

class _FlashCardPageState extends State<FlashCardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 32),
            Center(
                child: SizedBox(
              width: MediaQuery.sizeOf(context).width * 0.5,
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                        onPressed: _showCreateFlashcardDialog,
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
            )),
            SizedBox(height: 32),
            FlashcardGrid(),
          ],
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
