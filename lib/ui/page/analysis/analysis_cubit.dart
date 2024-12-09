import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toeic_desktop/data/models/enums/load_status.dart';
import 'package:toeic_desktop/ui/page/analysis/analysis_state.dart';

class AnalysisCubit extends Cubit<AnalysisState> {
  AnalysisCubit() : super(AnalysisState.initial());

  Future<void> fetchProfileAnalysis() async {
    emit(state.copyWith(loadStatus: LoadStatus.loading));
    
  }
}
