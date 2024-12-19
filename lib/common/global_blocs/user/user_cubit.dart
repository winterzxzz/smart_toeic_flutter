import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toeic_desktop/common/router/route_config.dart';
import 'package:toeic_desktop/data/database/share_preferences_helper.dart';
import 'package:toeic_desktop/data/models/entities/profile/user_entity.dart';
import 'package:toeic_desktop/data/models/enums/load_status.dart';
import 'package:toeic_desktop/data/network/repositories/auth_repository.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  final AuthRepository authRepository;
  UserCubit(this.authRepository) : super(const UserState());

  Future<void> setUser(UserEntity user) async {
    emit(state.copyWith(user: user));
  }

  Future<void> getUser() async {
    emit(state.copyWith(loadStatus: LoadStatus.loading));
    final result = await authRepository.getUser();
    result.fold(
      (l) => emit(state.copyWith(
          loadStatus: LoadStatus.failure,
          message: l.errors?.first.message ?? 'Unexpected error occurred')),
      (r) => emit(state.copyWith(loadStatus: LoadStatus.success, user: r)),
    );
  }

  void updateUser(UserEntity user) {
    emit(state.copyWith(user: user));
  }

  Future<void> removeUser(BuildContext context) async {
    await SharedPreferencesHelper().removeCookies().then((_) {
      emit(const UserState());
      AppRouter.clearAndNavigate('/');
    });
  }
}
