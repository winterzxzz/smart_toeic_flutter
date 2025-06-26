import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toastification/toastification.dart';
import 'package:toeic_desktop/data/models/enums/load_status.dart';
import 'package:toeic_desktop/data/network/repositories/transcript_test.dart';
import 'package:toeic_desktop/ui/common/widgets/show_toast.dart';
import 'package:toeic_desktop/ui/page/transcript_test_set/listen_copy_state.dart';

class ListenCopyCubit extends Cubit<ListenCopyState> {
  final TranscriptTestRepository _transcriptTestRepository;

  ListenCopyCubit(this._transcriptTestRepository)
      : super(ListenCopyState.initial());

  Future<void> getTranscriptTests() async {
    emit(state.copyWith(loadStatus: LoadStatus.loading));

    final transcriptTests =
        await _transcriptTestRepository.getTranscriptTestSets();
    transcriptTests.fold(
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
      (r) => emit(state.copyWith(
          loadStatus: LoadStatus.success,
          transcriptTestSets: r,
          filteredTranscriptTestSets: r)),
    );
  }

  void toggleFilter() {
    emit(state.copyWith(isFilterOpen: !state.isFilterOpen));
  }

  void setFilterPart(String part) {
    final newFilterParts = state.filterParts.contains(part)
        ? state.filterParts.where((p) => p != part).toList()
        : [...state.filterParts, part];
    if (newFilterParts.isEmpty) {
      emit(state.copyWith(
          filteredTranscriptTestSets: state.transcriptTestSets,
          filterParts: newFilterParts));
    } else {
      final newTranscriptTestSets = state.transcriptTestSets.where((test) {
        if (test.transcriptTestSetPart == null) {
          return false;
        }
        return newFilterParts.contains(test.transcriptTestSetPart.toString());
      }).toList();
      emit(state.copyWith(
          filteredTranscriptTestSets: newTranscriptTestSets,
          filterParts: newFilterParts));
    }
  }
}
