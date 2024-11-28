import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toeic_desktop/data/models/enums/load_status.dart';
import 'package:toeic_desktop/data/network/repositories/flash_card_respository.dart';
import 'package:toeic_desktop/ui/page/flashcard/flash_card_state.dart';

class FlashCardCubit extends Cubit<FlashCardState> {
  final FlashCardRespository _flashCardRespository;
  FlashCardCubit(this._flashCardRespository) : super(FlashCardState.initial());

  Future<void> fetchFlashCardSets() async {
    emit(state.copyWith(loadStatus: LoadStatus.loading));
    final response = await _flashCardRespository.getSetFlashCards();
    response.fold(
      (l) => emit(state.copyWith(
        loadStatus: LoadStatus.failure,
        message: l.toString(),
      )),
      (r) => emit(state.copyWith(
        loadStatus: LoadStatus.success,
        flashCards: r,
      )),
    );
  }
}
