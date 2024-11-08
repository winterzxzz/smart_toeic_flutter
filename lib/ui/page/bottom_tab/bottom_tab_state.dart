import 'package:equatable/equatable.dart';

class BottomTabState extends Equatable {
  final int selectedIndex;

  const BottomTabState({
    required this.selectedIndex,
  });

  // initial state
  factory BottomTabState.initial() {
    return const BottomTabState(selectedIndex: 0);
  }

  // copy with
  BottomTabState copyWith({
    int? selectedIndex,
  }) {
    return BottomTabState(selectedIndex: selectedIndex ?? this.selectedIndex);
  }

  @override
  List<Object> get props => [selectedIndex];
}
