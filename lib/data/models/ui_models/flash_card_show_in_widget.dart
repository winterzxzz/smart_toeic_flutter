class FlashCardShowInWidget {
  final String word;
  final String definition;

  const FlashCardShowInWidget({
    required this.word,
    required this.definition,
  });

  Map<String, dynamic> toJson() {
    return {
      'word': word,
      'definition': definition,
    };
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
