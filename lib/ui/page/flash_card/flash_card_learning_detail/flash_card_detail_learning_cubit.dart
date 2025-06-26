import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toastification/toastification.dart';
import 'package:toeic_desktop/data/models/enums/load_status.dart';
import 'package:toeic_desktop/data/network/repositories/flash_card_respository.dart';
import 'package:toeic_desktop/ui/common/widgets/show_toast.dart';
import 'flash_card_detail_learning_state.dart';

class FlashCardDetailLearningCubit extends Cubit<FlashCardDetailLearningState> {
  final FlashCardRespository _flashCardRespository;
  FlashCardDetailLearningCubit(this._flashCardRespository)
      : super(FlashCardDetailLearningState.initial());

  Future<void> fetchFlashCards(String setId) async {
    emit(state.copyWith(loadStatus: LoadStatus.loading));
    final response = await _flashCardRespository.getFlashCardsLearning(setId);
    await Future.delayed(const Duration(seconds: 1));
    response.fold(
      (l) {
        emit(state.copyWith(
          loadStatus: LoadStatus.failure,
          message: l.message,
        ));
        showToast(title: l.message, type: ToastificationType.error);
      },
      (r) => emit(state.copyWith(
        loadStatus: LoadStatus.success,
        flashCards: r,
      )),
    );
  }
}
