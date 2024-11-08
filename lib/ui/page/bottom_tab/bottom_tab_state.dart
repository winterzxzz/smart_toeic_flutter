import 'package:equatable/equatable.dart';
import 'package:go_router/go_router.dart';

class BottomTabState extends Equatable {
  final int selectedIndex;
  final StatefulNavigationShell? navigationShell;

  const BottomTabState({
    required this.selectedIndex,
    this.navigationShell,
  });

  // initial state
  factory BottomTabState.initial() {
    return const BottomTabState(selectedIndex: 0);
  }

  // copy with
  BottomTabState copyWith({
    int? selectedIndex,
    StatefulNavigationShell? navigationShell,
  }) {
    return BottomTabState(
      selectedIndex: selectedIndex ?? this.selectedIndex,
      navigationShell: navigationShell ?? this.navigationShell,
    );
  }

  @override
  List<Object?> get props => [selectedIndex, navigationShell];
}
