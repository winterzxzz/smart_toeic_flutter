import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toastification/toastification.dart';
import 'package:toeic_desktop/data/models/enums/load_status.dart';
import 'package:toeic_desktop/data/models/request/flash_card_request.dart';
import 'package:toeic_desktop/data/network/repositories/flash_card_respository.dart';
import 'package:toeic_desktop/ui/common/widgets/show_toast.dart';
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

  Future<void> createFlashCard(FlashCardRequest flashCardRequest) async {
    final response =
        await _flashCardRespository.createFlashCard(flashCardRequest);
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

  Future<void> deleteFlashCard(String id) async {
    final response = await _flashCardRespository.deleteFlashCard(id);
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

  Future<void> updateFlashCard(
      String id, String word, String translation) async {
    final response =
        await _flashCardRespository.updateFlashCard(id, word, translation);
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
          title: 'Cập nhật từ vựng thành công',
          type: ToastificationType.success,
        );
      },
    );
  }

  Future<void> getFlashCardInforByAI(String prompt) async {
    if (prompt.isEmpty) {
      showToast(
        title: 'Vui lòng nhập từ vựng',
        type: ToastificationType.error,
      );
      return;
    }
    emit(state.copyWith(loadStatusAiGen: LoadStatus.loading));
    final response = await _flashCardRespository.getFlashCardInforByAI(prompt);
    response.fold(
      (l) => emit(state.copyWith(
        loadStatusAiGen: LoadStatus.failure,
        message: l.toString(),
      )),
      (r) {
        emit(state.copyWith(
          loadStatusAiGen: LoadStatus.success,
          flashCardAiGen: r,
        ));
      },
    );
  }
}
