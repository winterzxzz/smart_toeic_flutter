import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toastification/toastification.dart';
import 'package:toeic_desktop/app.dart';
import 'package:toeic_desktop/common/global_blocs/user/user_cubit.dart';
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
}
