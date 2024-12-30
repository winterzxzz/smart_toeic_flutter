import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toeic_desktop/data/models/enums/load_status.dart';
import 'package:toeic_desktop/data/network/repositories/transcript_test.dart';
import 'package:toeic_desktop/ui/page/listen_copy/listen_copy_state.dart';

class ListenCopyCubit extends Cubit<ListenCopyState> {
  final TranscriptTestRepository _transcriptTestRepository;

  ListenCopyCubit(this._transcriptTestRepository)
      : super(ListenCopyState.initial());

  Future<void> getTranscriptTests() async {
    emit(state.copyWith(loadStatus: LoadStatus.loading));
    final transcriptTests = await _transcriptTestRepository.getTranscriptTest();
    transcriptTests.fold(
      (l) => emit(state.copyWith(
        loadStatus: LoadStatus.failure,
        message: l.errors?.first.message,
      )),
      (r) => emit(
          state.copyWith(loadStatus: LoadStatus.success, transcriptTests: r)),
    );
  }
}
