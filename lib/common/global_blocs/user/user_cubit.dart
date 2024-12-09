import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:toeic_desktop/common/router/route_config.dart';
import 'package:toeic_desktop/data/database/share_preferences_helper.dart';
import 'package:toeic_desktop/data/models/entities/profile/user_entity.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit() : super(const UserState());

  Future<void> setUser(UserEntity user) async {
    emit(state.copyWith(user: user));
  }

  void updateUser(UserEntity user) {
    emit(state.copyWith(user: user));
  }

  void removeUser(BuildContext context) {
    SharedPreferencesHelper().removeCookies();
    emit(const UserState());
    GoRouter.of(context).goNamed(AppRouter.splash);
  }
}
