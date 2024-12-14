part of 'user_cubit.dart';

class UserState extends Equatable {
  final LoadStatus loadStatus;
  final String message;
  final UserEntity? user;

  const UserState({
    this.loadStatus = LoadStatus.initial,
    this.message = '',
    this.user,
  });

  @override
  List<Object?> get props => [
        loadStatus,
        message,
        user,
      ];

  UserState copyWith({
    LoadStatus? loadStatus,
    String? message,
    UserEntity? user,
  }) {
    return UserState(
      loadStatus: loadStatus ?? this.loadStatus,
      message: message ?? this.message,
      user: user ?? this.user,
    );
  }
}
