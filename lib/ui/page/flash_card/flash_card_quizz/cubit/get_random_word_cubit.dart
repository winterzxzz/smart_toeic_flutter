

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toeic_desktop/data/models/enums/load_status.dart';
import 'package:toeic_desktop/data/network/repositories/flash_card_respository.dart';
import 'package:toeic_desktop/ui/page/flash_card/flash_card_quizz/cubit/get_random_word_state.dart';

class GetRandomWordCubit extends Cubit<GetRandomWordState> {
  final FlashCardRespository _flashCardRepository;

  GetRandomWordCubit(this._flashCardRepository) : super(GetRandomWordState.initial());

  Future<void> getRandom4Words() async {
    final rs = await _flashCardRepository.getRandom4Words();
    rs.fold((l) => emit(state.copyWith(loadStatus: LoadStatus.failure, message: l.message)), (r) {
      emit(state.copyWith(loadStatus: LoadStatus.success, random4Words: r));
    });
  }
}