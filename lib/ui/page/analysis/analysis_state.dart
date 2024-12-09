import 'package:equatable/equatable.dart';
import 'package:toeic_desktop/data/models/entities/profile/profile_analysis.dart';
import 'package:toeic_desktop/data/models/enums/load_status.dart';

class AnalysisState extends Equatable {
  final LoadStatus loadStatus;
  final String message;
  final ProfileAnalysis profileAnalysis;

  const AnalysisState({
    required this.loadStatus,
    required this.message,
    required this.profileAnalysis,
  });

  // initial state
  factory AnalysisState.initial() => AnalysisState(
        loadStatus: LoadStatus.initial,
        message: '',
        profileAnalysis: ProfileAnalysis.initial(),
      );

  // copy with
  AnalysisState copyWith({
    LoadStatus? loadStatus,
    String? message,
    ProfileAnalysis? profileAnalysis,
  }) =>
      AnalysisState(
        loadStatus: loadStatus ?? this.loadStatus,
        message: message ?? this.message,
        profileAnalysis: profileAnalysis ?? this.profileAnalysis,
      );

  @override
  List<Object?> get props => [loadStatus, message, profileAnalysis];
}
