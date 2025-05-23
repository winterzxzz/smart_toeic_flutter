import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toastification/toastification.dart';
import 'package:toeic_desktop/data/models/enums/load_status.dart';
import 'package:toeic_desktop/data/network/repositories/flash_card_respository.dart';
import 'package:toeic_desktop/ui/common/widgets/show_toast.dart';
import 'package:toeic_desktop/ui/page/flash_card/set_flashcard/set_flash_card_state.dart';

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

  Future<void> fetchFlashCardSetsLearning() async {
    emit(state.copyWith(loadStatusLearning: LoadStatus.loading));
    final response = await _flashCardRespository.getSetFlashCardsLearning();
    response.fold(
      (l) => emit(state.copyWith(
        loadStatusLearning: LoadStatus.failure,
        message: l.toString(),
      )),
      (r) => emit(state.copyWith(
        loadStatusLearning: LoadStatus.success,
        flashCardsLearning: r,
      )),
    );
  }

  Future<void> createFlashCardSet(String title, String description) async {
    final response =
        await _flashCardRespository.createFlashCardSet(title, description);
    response.fold(
      (l) => emit(state.copyWith(
        loadStatus: LoadStatus.failure,
        message: l.toString(),
      )),
      (r) => emit(state.copyWith(
        loadStatus: LoadStatus.success,
        flashCards: [r, ...state.flashCards],
      )),
    );
  }

  Future<void> deleteFlashCardSet(String id) async {
    final response = await _flashCardRespository.deleteFlashCardSet(id);
    response.fold(
      (l) => emit(state.copyWith(
        loadStatus: LoadStatus.failure,
        message: l.toString(),
      )),
      (r) {
        emit(state.copyWith(
          loadStatus: LoadStatus.success,
          flashCards: state.flashCards.where((e) => e.id != id).toList(),
        ));
        showToast(
          title: "Xóa thành công",
          type: ToastificationType.success,
        );
      },
    );
  }

  Future<void> deleteFlashCardLearning(String learningSetId) async {
    final response =
        await _flashCardRespository.deleteFlashCardLearning(learningSetId);
    response.fold(
      (l) => emit(state.copyWith(
        loadStatusLearning: LoadStatus.failure,
        message: l.toString(),
      )),
      (r) {
        emit(state.copyWith(
          loadStatusLearning: LoadStatus.success,
          flashCardsLearning: state.flashCardsLearning
              .where((e) => e.id != learningSetId)
              .toList(),
        ));
        showToast(
          title: "Xóa thành công",
          type: ToastificationType.success,
        );
      },
    );
  }

  Future<void> updateFlashCardSet(
      String id, String title, String description) async {
    final response =
        await _flashCardRespository.updateFlashCardSet(id, title, description);
    response.fold(
      (l) => emit(state.copyWith(
        loadStatus: LoadStatus.failure,
        message: l.toString(),
      )),
      (r) {
        emit(state.copyWith(
          loadStatus: LoadStatus.success,
          flashCards: state.flashCards.map((e) => e.id == id ? r : e).toList(),
        ));
        showToast(
          title: "Cập nhật thành công",
          type: ToastificationType.success,
        );
      },
    );
  }
}
