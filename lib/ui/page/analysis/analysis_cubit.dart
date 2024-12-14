import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toeic_desktop/data/models/enums/load_status.dart';
import 'package:toeic_desktop/data/network/repositories/proflie_respository.dart';
import 'package:toeic_desktop/ui/page/analysis/analysis_state.dart';

class AnalysisCubit extends Cubit<AnalysisState> {
  final ProfileRepository profileRepository;
  AnalysisCubit(this.profileRepository) : super(AnalysisState.initial());

  Future<void> fetchProfileAnalysis() async {
    emit(state.copyWith(loadStatus: LoadStatus.loading));
    final result = await profileRepository.getProfileAllAnalysis();
    result.fold(
        (l) => emit(
            state.copyWith(loadStatus: LoadStatus.failure, message: l.message)),
        (r) => emit(state.copyWith(
            loadStatus: LoadStatus.success,
            profileAnalysis: r.profileAnalysis,
            suggestForStudy: r.suggestForStudy)));
  }
}
