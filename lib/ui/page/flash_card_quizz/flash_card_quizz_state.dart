import 'package:equatable/equatable.dart';
import 'package:toeic_desktop/data/models/entities/flash_card/flash_card/flash_card_quizz.dart';
import 'package:toeic_desktop/data/models/enums/load_status.dart';

class FlashCardQuizzState extends Equatable {
  final LoadStatus loadStatus;
  final String message;
  final List<FlashCardQuizz> flashCardQuizzs;
  final int currentIndex;
  final Map<String, String> selectedOption;

  const FlashCardQuizzState(
      {required this.loadStatus,
      required this.flashCardQuizzs,
      required this.message,
      required this.currentIndex,
      required this.selectedOption});

  factory FlashCardQuizzState.initial() => FlashCardQuizzState(
      loadStatus: LoadStatus.initial,
      flashCardQuizzs: [],
      message: '',
      currentIndex: 0,
      selectedOption: {});

  FlashCardQuizzState copyWith({
    LoadStatus? loadStatus,
    List<FlashCardQuizz>? flashCardQuizzs,
    String? message,
    int? currentIndex,
    Map<String, String>? selectedOption,
  }) =>
      FlashCardQuizzState(
        loadStatus: loadStatus ?? this.loadStatus,
        flashCardQuizzs: flashCardQuizzs ?? this.flashCardQuizzs,
        message: message ?? this.message,
        currentIndex: currentIndex ?? this.currentIndex,
        selectedOption: selectedOption ?? this.selectedOption,
      );

  @override
  List<Object> get props =>
      [loadStatus, flashCardQuizzs, message, currentIndex, selectedOption];
}
