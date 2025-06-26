import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toastification/toastification.dart';
import 'package:toeic_desktop/data/models/enums/load_status.dart';
import 'package:toeic_desktop/data/network/repositories/proflie_respository.dart';
import 'package:toeic_desktop/language/generated/l10n.dart';
import 'package:toeic_desktop/ui/common/widgets/show_toast.dart';
import 'package:toeic_desktop/ui/page/personal_analysis/analysis_state.dart';

class AnalysisCubit extends Cubit<AnalysisState> {
  final ProfileRepository profileRepository;

  late ScrollController scrollController;
  AnalysisCubit(this.profileRepository) : super(AnalysisState.initial()) {
    scrollController = ScrollController();
  }

  Future<void> fetchProfileAnalysis() async {
    emit(state.copyWith(loadStatus: LoadStatus.loading));
    final result = await profileRepository.getProfileAnalysis();
    result.fold((l) {
      emit(state.copyWith(loadStatus: LoadStatus.failure, message: l.message));
      showToast(title: l.message, type: ToastificationType.error);
    },
        (r) => emit(state.copyWith(
            loadStatus: LoadStatus.success, profileAnalysis: r)));
  }

  Future<void> fetchSuggestForStudy() async {
    emit(state.copyWith(suggestForStudyStatus: LoadStatus.loading));
    final result = await profileRepository.getSuggestForStudy();
    result.fold((l) {
      emit(state.copyWith(
          suggestForStudyStatus: LoadStatus.failure, message: l.message));
      showToast(title: l.message, type: ToastificationType.error);
    }, (r) {
      emit(state.copyWith(
          suggestForStudyStatus: LoadStatus.success, suggestForStudy: r));
      showToast(
          title: S.current.success,
          description: S.current.analysis_your_score_success,
          type: ToastificationType.success);
      Future.delayed(const Duration(milliseconds: 500), () {
        _scrollToTheEnd();
      });
    });
  }

  void _scrollToTheEnd() {
    scrollController.animateTo(scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
  }
}
