class FlashCardRequest {
  final String word;
  final String translation;
  final String setFlashcardId;
  final String definition;
  final List<String> exampleSentence;
  final String note;
  final List<String> partOfSpeech;
  final String pronunciation;

  FlashCardRequest({
    required this.word,
    required this.translation,
    required this.setFlashcardId,
    required this.definition,
    required this.exampleSentence,
    required this.note,
    required this.partOfSpeech,
    required this.pronunciation,
  });

  Map<String, dynamic> toJson() {
    return {
      'word': word,
      'translation': translation,
      'setFlashcardId': setFlashcardId,
      'definition': definition,
      'exampleSentence': exampleSentence.map((e) => e.toString()).toList(),
      'note': note,
      'partOfSpeech': partOfSpeech.map((e) => e.toString()).toList(),
      'pronunciation': pronunciation,
    };
  }

  bool isValid() {
    return word.isNotEmpty &&
        translation.isNotEmpty &&
        setFlashcardId.isNotEmpty &&
        definition.isNotEmpty &&
        exampleSentence.isNotEmpty &&
        note.isNotEmpty &&
        partOfSpeech.isNotEmpty &&
        pronunciation.isNotEmpty;
  }

  FlashCardRequest copyWith({
    String? word,
    String? translation,
    String? setFlashcardId,
    String? definition,
    List<String>? exampleSentence,
    String? note,
    List<String>? partOfSpeech,
    String? pronunciation,
  }) {
    return FlashCardRequest(
      word: word ?? this.word,
      translation: translation ?? this.translation,
      setFlashcardId: setFlashcardId ?? this.setFlashcardId,
      definition: definition ?? this.definition,
      exampleSentence: exampleSentence ?? this.exampleSentence,
      note: note ?? this.note,
      partOfSpeech: partOfSpeech ?? this.partOfSpeech,
      pronunciation: pronunciation ?? this.pronunciation,
    );
  }
}
