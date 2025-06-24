class FlashCardShowInWidget {
  final String word;
  final String pronunciation;
  final String partOfSpeech;
  final String definition;

  const FlashCardShowInWidget({
    required this.word,
    required this.definition,
    required this.pronunciation,
    required this.partOfSpeech,
  });

  Map<String, dynamic> toJson() {
    return {
      'word': word.capitalize(),
      'pronunciation': pronunciation,
      'definition': definition.capitalize(),
      'partOfSpeech': partOfSpeech,
    };
  }
}

extension StringExtension on String {
  String capitalize() {
    return this[0].toUpperCase() + substring(1);
  }
}

class FlashCardShowInWidgetList {
  final List<FlashCardShowInWidget> flashCardShowInWidgetList;

  const FlashCardShowInWidgetList({
    required this.flashCardShowInWidgetList,
  });

  Map<String, dynamic> toJson() {
    return {
      'flashCardShowInWidgetList':
          flashCardShowInWidgetList.map((e) => e.toJson()).toList(),
    };
  }
}
