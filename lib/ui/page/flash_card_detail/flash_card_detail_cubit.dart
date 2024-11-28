import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toeic_desktop/data/models/enums/load_status.dart';
import 'package:toeic_desktop/data/network/repositories/flash_card_respository.dart';
import 'flash_card_detail_state.dart';

class FlashCardDetailCubit extends Cubit<FlashCardDetailState> {
  final FlashCardRespository _flashCardRespository;
  FlashCardDetailCubit(this._flashCardRespository)
      : super(FlashCardDetailState.initial());

  Future<void> fetchFlashCards(String setId) async {
    emit(state.copyWith(loadStatus: LoadStatus.loading));
    final response = await _flashCardRespository.getFlashCards(setId);
    await Future.delayed(const Duration(seconds: 1));
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
