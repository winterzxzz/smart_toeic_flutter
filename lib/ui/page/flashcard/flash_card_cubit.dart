import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toastification/toastification.dart';
import 'package:toeic_desktop/data/models/enums/load_status.dart';
import 'package:toeic_desktop/data/network/repositories/flash_card_respository.dart';
import 'package:toeic_desktop/ui/common/widgets/show_toast.dart';
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
        flashCards: List.from(state.flashCards)..add(r),
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
      (r) => emit(state.copyWith(
        loadStatus: LoadStatus.success,
        flashCards: state.flashCards.where((e) => e.id != id).toList(),
      )),
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
