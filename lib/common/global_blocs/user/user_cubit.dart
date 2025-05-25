import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toastification/toastification.dart';
import 'package:toeic_desktop/app.dart';
import 'package:toeic_desktop/common/router/route_config.dart';
import 'package:toeic_desktop/data/database/share_preferences_helper.dart';
import 'package:toeic_desktop/data/models/entities/profile/user_entity.dart';
import 'package:toeic_desktop/data/models/enums/load_status.dart';
import 'package:toeic_desktop/data/models/request/profile_update_request.dart';
import 'package:toeic_desktop/data/network/repositories/proflie_respository.dart';
import 'package:toeic_desktop/ui/common/widgets/show_toast.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  final ProfileRepository profileRepository;
  UserCubit(this.profileRepository) : super(const UserState());

  Future<void> getUser() async {
    emit(state.copyWith(loadStatus: LoadStatus.loading));
    final result = await profileRepository.getUser();
    result.fold(
      (l) => emit(state.copyWith(
          loadStatus: LoadStatus.failure,
          message: l.errors?.first.message ?? 'Unexpected error occurred',
          isHaveUser: false)),
      (r) => emit(state.copyWith(
          loadStatus: LoadStatus.success, user: r, isHaveUser: true)),
    );
  }

  void updateUser(UserEntity user) {
    emit(state.copyWith(
        user: user, loadStatus: LoadStatus.success, isHaveUser: true));
  }

  Future<void> removeUser(BuildContext context) async {
    await SharedPreferencesHelper().removeCookies();
    await injector.reset();
    await init();
    AppRouter.clearAndNavigate('/');
  }

  Future<void> updateTargetScore(int reading, int listening) async {
    emit(state.copyWith(updateTargetScoreStatus: LoadStatus.loading));
    final response =
        await profileRepository.updateTargetScore(reading, listening);
    response.fold(
      (l) {
        emit(state.copyWith(
            updateTargetScoreStatus: LoadStatus.failure,
            message: l.errors?.first.message ?? 'Unexpected error occurred'));
        showToast(
            title: l.errors?.first.message ?? 'Unexpected error occurred',
            type: ToastificationType.error);
      },
      (r) {
        emit(state.copyWith(
            updateTargetScoreStatus: LoadStatus.success, user: r));
        showToast(
            title: 'Update target score success',
            type: ToastificationType.success);
      },
    );
  }

  Future<void> updateProfileAvatar(File avatar) async {
    final response = await profileRepository.updateProfileAvatar(avatar);
    response.fold(
      (l) => showToast(
        title: l.errors?.first.message ?? 'Unexpected error occurred',
        type: ToastificationType.error,
      ),
      (r) {
        final currentUser = state.user!;
        final updatedUser = currentUser.copyWith(avatar: r);
        updateUser(updatedUser);
        showToast(
            title: 'Update prolfile avatar success',
            type: ToastificationType.success);
      },
    );
  }

  Future<void> updateProfile(ProfileUpdateRequest request) async {
    emit(state.copyWith(updateStatus: LoadStatus.loading));
    final response = await profileRepository.updateProfile(request);
    response.fold(
      (l) {
        emit(state.copyWith(
            updateStatus: LoadStatus.failure,
            message: l.errors?.first.message ?? 'Unexpected error occurred'));
        showToast(
            title: l.errors?.first.message ?? 'Unexpected error occurred',
            type: ToastificationType.error);
      },
      (r) {
        final currentUser = state.user!;
        final updatedUser =
            currentUser.copyWith(name: request.name, bio: request.bio);
        emit(state.copyWith(
            user: updatedUser, updateStatus: LoadStatus.success));
        showToast(
            title: 'Update profile success', type: ToastificationType.success);
      },
    );
  }
}
