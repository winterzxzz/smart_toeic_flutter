import 'package:equatable/equatable.dart';

class BottomTabState extends Equatable {
  final int currentIndex;

  const BottomTabState({
    required this.currentIndex,
  });

  // init state
  factory BottomTabState.initial() => const BottomTabState(currentIndex: 0);

  // copyWith
  BottomTabState copyWith({
    int? currentIndex,
  }) {
    return BottomTabState(currentIndex: currentIndex ?? this.currentIndex);
  }

  @override
  List<Object?> get props => [currentIndex];
}
