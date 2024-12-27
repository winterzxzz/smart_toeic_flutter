import 'package:equatable/equatable.dart';
import 'package:toeic_desktop/data/models/entities/flash_card/word/word_random.dart';
import 'package:toeic_desktop/data/models/enums/load_status.dart';

class GetRandomWordState extends Equatable {
  final LoadStatus loadStatus;
  final String message;
  final List<WordRandom> random4Words;

  const GetRandomWordState({
    required this.loadStatus,
    required this.message,
    required this.random4Words,
  });

  factory GetRandomWordState.initial() => GetRandomWordState(
        loadStatus: LoadStatus.initial,
        message: '',
        random4Words: [],
      );

  GetRandomWordState copyWith({
    LoadStatus? loadStatus,
    String? message,
    List<WordRandom>? random4Words,
  }) =>
      GetRandomWordState(
        loadStatus: loadStatus ?? this.loadStatus,
        message: message ?? this.message,
        random4Words: random4Words ?? this.random4Words,
      );

  @override
  List<Object?> get props => [loadStatus, message, random4Words];
}
