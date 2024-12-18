import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toastification/toastification.dart';
import 'package:toeic_desktop/app.dart';
import 'package:toeic_desktop/common/global_blocs/user/user_cubit.dart';
import 'package:toeic_desktop/data/models/request/profile_update_request.dart';
import 'package:toeic_desktop/data/network/repositories/proflie_respository.dart';
import 'package:toeic_desktop/ui/common/widgets/show_toast.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepository profileRepository;
  ProfileCubit(this.profileRepository) : super(ProfileInitial());

  Future<void> updateTargetScore(int reading, int listening) async {
    final response =
        await profileRepository.updateTargetScore(reading, listening);
    response.fold(
      (l) => showToast(
        title: l.message,
        type: ToastificationType.error,
      ),
      (r) {
        injector<UserCubit>().updateUser(r);
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
        title: l.message,
        type: ToastificationType.error,
      ),
      (r) {
        final currentUser = injector<UserCubit>().state.user!;
        final updatedUser = currentUser.copyWith(avatar: r);
        injector<UserCubit>().updateUser(updatedUser);
        showToast(
            title: 'Update prolfile avatar success',
            type: ToastificationType.success);
      },
    );
  }

  Future<void> updateProfile(ProfileUpdateRequest request) async {
    final response = await profileRepository.updateProfile(request);
    response.fold(
      (l) => showToast(title: l.message, type: ToastificationType.error),
      (r) {
        final currentUser = injector<UserCubit>().state.user!;
        final updatedUser =
            currentUser.copyWith(name: request.name, bio: request.bio);
        injector<UserCubit>().updateUser(updatedUser);
        showToast(
            title: 'Update profile success', type: ToastificationType.success);
      },
    );
  }
}
