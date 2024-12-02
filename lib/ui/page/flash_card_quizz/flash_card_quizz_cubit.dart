import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toeic_desktop/data/models/entities/flash_card.dart';
import 'package:toeic_desktop/data/models/enums/load_status.dart';
import 'package:toeic_desktop/data/models/request/flash_card_quiz_request.dart';
import 'package:toeic_desktop/data/network/repositories/flash_card_respository.dart';
import 'package:toeic_desktop/ui/page/flash_card_quizz/flash_card_quizz_state.dart';

class FlashCardQuizzCubit extends Cubit<FlashCardQuizzState> {
  final FlashCardRespository _flashCardRepository;
  FlashCardQuizzCubit(this._flashCardRepository)
      : super(FlashCardQuizzState.initial());

  void fetchFlashCardQuizzs(List<FlashCard> flashCards) async {
    emit(state.copyWith(loadStatus: LoadStatus.loading));
    final response = await _flashCardRepository
        .getFlashCardQuizz(FlashCardQuizRequest(prompt: flashCards));
    response.fold(
        (l) => emit(state.copyWith(loadStatus: LoadStatus.failure)),
        (r) => emit(state.copyWith(
            loadStatus: LoadStatus.success, flashCardQuizzs: r)));
  }
}
