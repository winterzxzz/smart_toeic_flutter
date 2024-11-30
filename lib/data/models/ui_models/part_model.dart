import 'package:toeic_desktop/data/models/enums/part.dart';

class PartModel {
  final PartEnum partEnum;
  final int numberOfQuestions;
  final List<String> tags;
  final bool isSelected;

  PartModel({
    required this.partEnum,
    required this.numberOfQuestions,
    required this.tags,
    this.isSelected = false,
  });

  // copyWith
  PartModel copyWith({
    PartEnum? partEnum,
    int? numberOfQuestions,
    List<String>? tags,
    bool? isSelected,
  }) {
    return PartModel(
      partEnum: partEnum ?? this.partEnum,
      numberOfQuestions: numberOfQuestions ?? this.numberOfQuestions,
      tags: tags ?? this.tags,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}

extension PartModelExtension on PartModel {
  PartEnum get numValue => partEnum;
}
