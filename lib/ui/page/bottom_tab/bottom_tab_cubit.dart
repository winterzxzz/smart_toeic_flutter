import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toeic_desktop/ui/page/bottom_tab/bottom_tab_state.dart';

class BottomTabCubit extends Cubit<BottomTabState> {
  late PageController pageController;
  BottomTabCubit() : super(BottomTabState.initial()) {
    pageController = PageController(initialPage: 0);
  }

  void changeCurrentIndex(int index) {
    pageController.jumpToPage(index);
    emit(state.copyWith(currentIndex: index));
  }
}
