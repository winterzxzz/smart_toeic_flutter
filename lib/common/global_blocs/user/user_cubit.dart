import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toeic_desktop/data/models/entities/user_entity.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit() : super(const UserState());

  Future<void> setUser(UserEntity user) async {
    emit(state.copyWith(user: user));
  }

  void updateUser(UserEntity user) {
    emit(state.copyWith(user: user));
  }

  void removeUser() {
    emit(const UserState());
  }
}
