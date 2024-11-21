import 'package:flutter/material.dart';

class PracticeTestPart extends StatelessWidget {
  const PracticeTestPart({
    super.key,
    required this.title,
    required this.numberQuestions,
    required this.startNumber,
  });

  final String title;
  final int numberQuestions;
  final int startNumber;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const SizedBox(
          height: 16,
        ),
        GridView.builder(
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5, // 5 items per row
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
            mainAxisExtent: 40,
          ),
          itemCount: numberQuestions, // Numbers 7 to 31
          itemBuilder: (context, index) {
            int number = startNumber + index; // Start from 7
            return InkWell(
              onTap: () {},
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: Text(
                  '$number',
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
