import 'package:equatable/equatable.dart';
import 'package:toeic_desktop/data/models/entities/flash_card_quizz.dart';
import 'package:toeic_desktop/data/models/enums/load_status.dart';

class FlashCardQuizzState extends Equatable {
  final LoadStatus loadStatus;
  final String message;
  final List<FlashCardQuizz> flashCardQuizzs;

  const FlashCardQuizzState(
      {required this.loadStatus,
      required this.flashCardQuizzs,
      required this.message});

  factory FlashCardQuizzState.initial() => FlashCardQuizzState(
      loadStatus: LoadStatus.initial, flashCardQuizzs: [], message: '');

  FlashCardQuizzState copyWith({
    LoadStatus? loadStatus,
    List<FlashCardQuizz>? flashCardQuizzs,
    String? message,
  }) =>
      FlashCardQuizzState(
        loadStatus: loadStatus ?? this.loadStatus,
        flashCardQuizzs: flashCardQuizzs ?? this.flashCardQuizzs,
        message: message ?? this.message,
      );

  @override
  List<Object> get props => [loadStatus, flashCardQuizzs, message];
}
