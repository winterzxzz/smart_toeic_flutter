import 'package:equatable/equatable.dart';
import 'package:toeic_desktop/data/models/entities/profile/profile_analysis.dart';
import 'package:toeic_desktop/data/models/enums/load_status.dart';

class AnalysisState extends Equatable {
  final LoadStatus loadStatus;
  final LoadStatus suggestForStudyStatus;
  final String message;
  final ProfileAnalysis profileAnalysis;
  final String suggestForStudy;

  const AnalysisState({
    required this.loadStatus,
    required this.suggestForStudyStatus,
    required this.message,
    required this.profileAnalysis,
    required this.suggestForStudy,
  });

  // initial state
  factory AnalysisState.initial() => AnalysisState(
        loadStatus: LoadStatus.initial,
        suggestForStudyStatus: LoadStatus.initial,
        message: '',
        profileAnalysis: ProfileAnalysis.initial(),
        suggestForStudy: '',
      );

  // copy with
  AnalysisState copyWith({
    LoadStatus? loadStatus,
    LoadStatus? suggestForStudyStatus,
    String? message,
    ProfileAnalysis? profileAnalysis,
    String? suggestForStudy,
  }) =>
      AnalysisState(
        loadStatus: loadStatus ?? this.loadStatus,
        suggestForStudyStatus:
            suggestForStudyStatus ?? this.suggestForStudyStatus,
        message: message ?? this.message,
        profileAnalysis: profileAnalysis ?? this.profileAnalysis,
        suggestForStudy: suggestForStudy ?? this.suggestForStudy,
      );

  @override
  List<Object?> get props => [
        loadStatus,
        suggestForStudyStatus,
        message,
        profileAnalysis,
        suggestForStudy,
      ];
}
