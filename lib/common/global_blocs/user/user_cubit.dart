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
import 'package:toeic_desktop/language/generated/l10n.dart';
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
          message: l.message,
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
    emit(const UserState());
    await resetSingletonCubitsAndInitAgain();
    AppRouter.clearAndNavigate('/');
  }

  Future<void> updateTargetScore(int reading, int listening) async {
    emit(state.copyWith(updateTargetScoreStatus: LoadStatus.loading));
    final response =
        await profileRepository.updateTargetScore(reading, listening);
    response.fold(
      (l) {
        emit(state.copyWith(
            updateTargetScoreStatus: LoadStatus.failure, message: l.message));
        showToast(title: l.message, type: ToastificationType.error);
      },
      (r) {
        emit(state.copyWith(
            updateTargetScoreStatus: LoadStatus.success,
            user: r,
            isHaveUser: true));
        showToast(
            title: S.current.update_target_score_success,
            type: ToastificationType.success);
      },
    );
  }

  Future<void> updateProfileAvatar(File avatar) async {
    final response = await profileRepository.updateProfileAvatar(avatar);
    response.fold(
      (l) => showToast(
        title: l.message,
        type: ToastificationType.error,
      ),
      (r) {
        final currentUser = state.user!;
        final updatedUser = currentUser.copyWith(avatar: r);
        updateUser(updatedUser);
        showToast(
            title: S.current.update_profile_avatar_success,
            type: ToastificationType.success);
      },
    );
  }

  Future<void> updateProfile(ProfileUpdateRequest request) async {
    if (request.name.isEmpty) {
      emit(state.copyWith(
          updateStatus: LoadStatus.failure,
          message: S.current.please_enter_name));
      showToast(
          title: S.current.please_enter_name, type: ToastificationType.error);
      return;
    }
    emit(state.copyWith(updateStatus: LoadStatus.loading));
    final response = await profileRepository.updateProfile(request);
    response.fold(
      (l) {
        emit(state.copyWith(
            updateStatus: LoadStatus.failure, message: l.message));
        showToast(title: l.message, type: ToastificationType.error);
      },
      (r) {
        final currentUser = state.user!;
        final updatedUser =
            currentUser.copyWith(name: request.name, bio: request.bio);
        emit(state.copyWith(
            user: updatedUser, updateStatus: LoadStatus.success));
        showToast(
            title: S.current.update_profile_success,
            type: ToastificationType.success);
      },
    );
  }
}
