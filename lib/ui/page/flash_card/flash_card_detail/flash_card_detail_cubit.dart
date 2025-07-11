import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toastification/toastification.dart';
import 'package:toeic_desktop/app.dart';
import 'package:toeic_desktop/common/global_blocs/setting/app_setting_cubit.dart';
import 'package:toeic_desktop/data/models/enums/load_status.dart';
import 'package:toeic_desktop/data/models/request/flash_card_request.dart';
import 'package:toeic_desktop/data/models/ui_models/flash_card_show_in_widget.dart';
import 'package:toeic_desktop/data/network/repositories/flash_card_respository.dart';
import 'package:toeic_desktop/data/services/widget_service.dart';
import 'package:toeic_desktop/language/generated/l10n.dart';
import 'package:toeic_desktop/ui/common/widgets/show_toast.dart';
import 'package:toeic_desktop/ui/page/flash_card/set_flashcard/set_flash_card_cubit.dart';
import 'flash_card_detail_state.dart';

class FlashCardDetailCubit extends Cubit<FlashCardDetailState> {
  final FlashCardRespository _flashCardRespository;
  final WidgetService _widgetService;
  FlashCardDetailCubit({
    required FlashCardRespository flashCardRespository,
    required WidgetService widgetService,
  })  : _flashCardRespository = flashCardRespository,
        _widgetService = widgetService,
        super(FlashCardDetailState.initial());

  Future<void> fetchFlashCards(String setId) async {
    emit(state.copyWith(loadStatus: LoadStatus.loading, setFlashCardId: setId));
    final response = await _flashCardRespository.getFlashCards(setId);
    await Future.delayed(const Duration(seconds: 1));
    response.fold((l) {
      emit(state.copyWith(
        loadStatus: LoadStatus.failure,
        message: l.message,
      ));
      showToast(
        title: l.message,
        type: ToastificationType.error,
      );
    }, (r) {
      emit(state.copyWith(
        loadStatus: LoadStatus.success,
        flashCards: r,
      ));
      final List<FlashCardShowInWidget> listOfFlashCardShowInWidget = r
          .map((e) => FlashCardShowInWidget(
                word: e.word,
                definition: e.definition,
                pronunciation: e.pronunciation,
                partOfSpeech: e.partOfSpeech.join(', '),
              ))
          .toList();
      final flashCardShowInWidgetList = FlashCardShowInWidgetList(
        flashCardShowInWidgetList: listOfFlashCardShowInWidget,
      );
      final isReminderWordAfterTime =
          injector<AppSettingCubit>().state.isReminderWordAfterTime;
      if (isReminderWordAfterTime) {
        _widgetService.schedulePeriodicWidgetUpdate(
            flashCardShowInWidgetList: flashCardShowInWidgetList);
      }
    });
  }

  Future<void> createFlashCard(FlashCardRequest flashCardRequest) async {
    if (!flashCardRequest.isValid()) {
      showToast(
        title: S.current.please_enter_all_information,
        type: ToastificationType.error,
      );
      return;
    }
    final response =
        await _flashCardRespository.createFlashCard(flashCardRequest);
    response.fold((l) {
      emit(state.copyWith(
        loadStatus: LoadStatus.failure,
        message: l.message,
      ));
      showToast(
        title: l.message,
        type: ToastificationType.error,
      );
    }, (r) {
      emit(state.copyWith(
        loadStatus: LoadStatus.success,
        loadStatusAiGen: LoadStatus.success,
        flashCards: [r, ...state.flashCards],
      ));
      injector<FlashCardCubit>()
          .updateSetFlashCardAfterAddedd(setFlashCardId: state.setFlashCardId);
    });
  }

  Future<void> deleteFlashCard(String id) async {
    final response = await _flashCardRespository.deleteFlashCard(id);
    response.fold((l) {
      emit(state.copyWith(
        loadStatus: LoadStatus.failure,
        message: l.message,
      ));
      showToast(
        title: l.message,
        type: ToastificationType.error,
      );
    }, (r) {
      emit(state.copyWith(
        loadStatus: LoadStatus.success,
        loadStatusAiGen: LoadStatus.success,
        flashCards: state.flashCards.where((e) => e.id != id).toList(),
      ));
      injector<FlashCardCubit>()
          .updateSetFlashCardAfterRemoved(setFlashCardId: state.setFlashCardId);
    });
  }

  Future<void> updateFlashCard(
      String id, String word, String translation) async {
    final response =
        await _flashCardRespository.updateFlashCard(id, word, translation);
    response.fold(
      (l) {
        emit(state.copyWith(
          loadStatus: LoadStatus.failure,
          message: l.message,
        ));
        showToast(
          title: l.message,
          type: ToastificationType.error,
        );
      },
      (r) {
        emit(state.copyWith(
          loadStatus: LoadStatus.success,
          loadStatusAiGen: LoadStatus.success,
          flashCards: state.flashCards.map((e) => e.id == id ? r : e).toList(),
        ));
        showToast(
          title: S.current.update_word_successfully,
          type: ToastificationType.success,
        );
      },
    );
  }

  Future<void> getFlashCardInforByAI(String prompt) async {
    if (prompt.isEmpty) {
      showToast(
        title: S.current.please_enter_word,
        type: ToastificationType.error,
      );
      return;
    }
    emit(state.copyWith(loadStatusAiGen: LoadStatus.loading));
    final response = await _flashCardRespository.getFlashCardInforByAI(prompt);
    response.fold(
      (l) {
        emit(state.copyWith(
          loadStatusAiGen: LoadStatus.failure,
          message: l.message,
        ));
        showToast(
          title: l.message,
          type: ToastificationType.error,
        );
      },
      (r) {
        emit(state.copyWith(
          loadStatus: LoadStatus.success,
          loadStatusAiGen: LoadStatus.success,
          flashCardAiGen: r,
        ));
      },
    );
  }
}
