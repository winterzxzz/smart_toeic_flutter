import 'package:equatable/equatable.dart';

class EntrypointState extends Equatable {
  final int currentIndex;

  const EntrypointState({
    required this.currentIndex,
  });

  // init state
  factory EntrypointState.initial() => const EntrypointState(currentIndex: 0);

  // copyWith
  EntrypointState copyWith({
    int? currentIndex,
  }) {
    return EntrypointState(currentIndex: currentIndex ?? this.currentIndex);
  }

  @override
  List<Object?> get props => [currentIndex];
}
