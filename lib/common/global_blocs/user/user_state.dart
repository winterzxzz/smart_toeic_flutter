part of 'user_cubit.dart';

class UserState extends Equatable {
  final UserEntity? user;

  const UserState({
    this.user,
  });

  @override
  List<Object?> get props => [
        user,
      ];

  UserState copyWith({
    UserEntity? user,
  }) {
    return UserState(
      user: user ?? this.user,
    );
  }
}
