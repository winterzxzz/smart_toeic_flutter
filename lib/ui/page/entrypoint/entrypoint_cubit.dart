import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toeic_desktop/ui/page/entrypoint/entrypoint_state.dart';

class EntrypointCubit extends Cubit<EntrypointState> {
  late PageController pageController;
  EntrypointCubit() : super(EntrypointState.initial()) {
    pageController = PageController(initialPage: 0);
  }

  void changeCurrentIndex(int index) {
    pageController.jumpToPage(index);
    emit(state.copyWith(currentIndex: index));
  }
}
