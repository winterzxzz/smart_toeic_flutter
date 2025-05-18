import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toeic_desktop/data/models/enums/load_status.dart';
import 'package:toeic_desktop/data/network/repositories/proflie_respository.dart';
import 'package:toeic_desktop/ui/page/personal_analysis/analysis_state.dart';

class AnalysisCubit extends Cubit<AnalysisState> {
  final ProfileRepository profileRepository;

  late ScrollController scrollController;
  AnalysisCubit(this.profileRepository) : super(AnalysisState.initial()) {
    scrollController = ScrollController();
  }

  Future<void> fetchProfileAnalysis() async {
    await Future.microtask(
        () => emit(state.copyWith(loadStatus: LoadStatus.loading)));
    final result = await profileRepository.getProfileAnalysis();
    result.fold(
        (l) => emit(state.copyWith(
            loadStatus: LoadStatus.failure,
            message: l.errors?.first.message ?? 'Unexpected error occurred')),
        (r) => emit(state.copyWith(
            loadStatus: LoadStatus.success, profileAnalysis: r)));
  }

  Future<void> fetchSuggestForStudy() async {
    emit(state.copyWith(loadStatus: LoadStatus.loading));
    final result = await profileRepository.getSuggestForStudy();
    result.fold(
        (l) => emit(state.copyWith(
            loadStatus: LoadStatus.failure,
            message: l.errors?.first.message ?? 'Unexpected error occurred')),
        (r) {
      emit(state.copyWith(loadStatus: LoadStatus.success, suggestForStudy: r));
      _scrollToTheEnd();
    });
  }

  void _scrollToTheEnd() {
    scrollController.animateTo(scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
  }
}
