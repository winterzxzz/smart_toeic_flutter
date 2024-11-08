import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:toeic_desktop/ui/page/bottom_tab/bottom_tab_state.dart';

class BottomTabCubit extends Cubit<BottomTabState> {
  BottomTabCubit() : super(BottomTabState.initial());

  void updateNavigationShell(StatefulNavigationShell navigationShell) {
    emit(state.copyWith(navigationShell: navigationShell));
  }

  void updateIndex(int index) {
    emit(state.copyWith(selectedIndex: index));
    state.navigationShell?.goBranch(index,
        initialLocation: index == state.navigationShell?.currentIndex);
  }
}
