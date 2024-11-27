import 'package:flutter/material.dart';

class QuizzPage extends StatefulWidget {
  const QuizzPage({super.key});

  @override
  State<QuizzPage> createState() => _QuizzPageState();
}

class _QuizzPageState extends State<QuizzPage> {
  final List<Map<String, dynamic>> _questions = [
    {
      'question': 'What is the Vietnamese word for "apple"?',
      'options': ['Cam', 'Táo', 'Dưa hấu', 'Chanh'],
      'correct': 1,
    },
    {
      'question': 'What is the Vietnamese word for "book"?',
      'options': ['Sách', 'Vở', 'Thư', 'Giấy'],
      'correct': 0,
    },
    {
      'question': 'What is the Vietnamese word for "dog"?',
      'options': ['Mèo', 'Cá', 'Chó', 'Lợn'],
      'correct': 2,
    },
    {
      'question': 'What is the Vietnamese word for "rice"?',
      'options': ['Cơm', 'Bánh', 'Thịt', 'Cá'],
      'correct': 0,
    },
    {
      'question': 'What is the Vietnamese word for "water"?',
      'options': ['Nước', 'Đất', 'Không khí', 'Lửa'],
      'correct': 0,
    },
  ];

  final Map<int, int> _answers = {};
  bool _showResults = false;
  bool _showAnswer = false;

  void _submitAnswers() {
    setState(() {
      _showResults = true;
      _showAnswer = false;
    });
  }

  void _restartQuiz() {
    setState(() {
      _answers.clear();
      _showResults = false;
      _showAnswer = false;
    });
  }

  void _handleShowAnswer() {
    setState(() {
      _showAnswer = true;
      _showResults = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('English - Vietnamese Quiz'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Builder(builder: (context) {
          if (_showResults) {
            return _buildResultsView();
          } else if (_showAnswer) {
            return _buildAnswerView();
          } else {
            return _buildQuizView();
          }
        }),
      ),
    );
  }

  Widget _buildQuizView() {
    return ListView(
      children: [
        for (int i = 0; i < _questions.length; i++) _buildQuestionCard(i),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed:
              _answers.length == _questions.length ? _submitAnswers : null,
          child: const Text('Submit'),
        ),
      ],
    );
  }

  Widget _buildQuestionCard(int index) {
    final question = _questions[index];
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Q${index + 1}: ${question['question']}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            for (int i = 0; i < question['options'].length; i++)
              RadioListTile<int>(
                title: Text(question['options'][i]),
                value: i,
                groupValue: _answers[index],
                onChanged: (value) {
                  setState(() {
                    _answers[index] = value!;
                  });
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultsView() {
    int correctAnswers = 0;

    for (int i = 0; i < _questions.length; i++) {
      if (_answers[i] == _questions[i]['correct']) {
        correctAnswers++;
      }
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            correctAnswers == _questions.length
                ? Icons.emoji_events
                : Icons.sentiment_satisfied,
            color: correctAnswers == _questions.length
                ? Colors.amber
                : Colors.blue,
            size: 100,
          ),
          const SizedBox(height: 20),
          Text(
            'You got $correctAnswers out of ${_questions.length} correct!',
            style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: MediaQuery.sizeOf(context).width * 0.1,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                textStyle: const TextStyle(fontSize: 18),
              ),
              onPressed: _restartQuiz,
              child: const Text('Restart Quiz'),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: MediaQuery.sizeOf(context).width * 0.1,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                textStyle: const TextStyle(fontSize: 18),
              ),
              onPressed: _handleShowAnswer,
              child: const Text('Show answer'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnswerView() {
    return ListView(
      children: [
        for (int i = 0; i < _questions.length; i++)
          Card(
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Q${i + 1}: ${_questions[i]['question']}',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Correct Answer: ${_questions[i]['options'][_questions[i]['correct']]}',
                    style: const TextStyle(fontSize: 16, color: Colors.green),
                  ),
                ],
              ),
            ),
          ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: _restartQuiz,
          child: const Text('Restart Quiz'),
        ),
      ],
    );
  }
}
