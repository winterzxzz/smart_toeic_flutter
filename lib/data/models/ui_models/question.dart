class Question {
  final int id;
  final String? image;
  final String? audio;
  final String? paragraph;
  final String? question;
  final String option1;
  final String option2;
  final String option3;
  final String? option4;
  final String correctAnswer;
  final int part;
  final List<String> categories;
  final String? userAnswer;

  Question({
    required this.id,
    this.image,
    this.audio,
    this.paragraph,
    required this.question,
    required this.option1,
    required this.option2,
    required this.option3,
    this.option4,
    required this.correctAnswer,
    required this.part,
    required this.categories,
    this.userAnswer,
  });

  // copy with
  Question copyWith({
    int? id,
    String? image,
    String? audio,
    String? paragraph,
    String? question,
    String? option1,
    String? option2,
    String? option3,
    String? option4,
    String? correctAnswer,
    int? part,
    List<String>? categories,
    String? userAnswer,
  }) {
    return Question(
      id: id ?? this.id,
      image: image ?? this.image,
      audio: audio ?? this.audio,
      paragraph: paragraph ?? this.paragraph,
      question: question ?? this.question,
      option1: option1 ?? this.option1,
      option2: option2 ?? this.option2,
      option3: option3 ?? this.option3,
      option4: option4 ?? this.option4,
      correctAnswer: correctAnswer ?? this.correctAnswer,
      part: part ?? this.part,
      categories: categories ?? this.categories,
      userAnswer: userAnswer ?? this.userAnswer,
    );
  }

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'],
      image: json['image'],
      audio: json['audio'],
      paragraph: json['paragraph'],
      question: json['question'],
      option1: json['option1'],
      option2: json['option2'],
      option3: json['option3'],
      option4: json['option4'],
      correctAnswer: json['correctAnswer'],
      part: json['part'],
      categories: List<String>.from(json['categories'] ?? []),
      userAnswer: json['userAnswer'],
    );
  }
}
