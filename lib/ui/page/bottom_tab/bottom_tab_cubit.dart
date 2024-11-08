import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iscanner_app/ui/page/bottom_tab/bottom_tab_state.dart';

class BottomTabCubit extends Cubit<BottomTabState> {
  BottomTabCubit() : super(BottomTabState.initial());

  void updateIndex(int index) {
    emit(state.copyWith(selectedIndex: index));
  }
}
