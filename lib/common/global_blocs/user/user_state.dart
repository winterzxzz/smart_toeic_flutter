part of 'user_cubit.dart';

class UserState extends Equatable {
  final LoadStatus loadStatus;
  final LoadStatus updateStatus;
  final LoadStatus updateTargetScoreStatus;
  final String message;
  final UserEntity? user;
  final bool isHaveUser;

  const UserState({
    this.loadStatus = LoadStatus.initial,
    this.updateStatus = LoadStatus.initial,
    this.updateTargetScoreStatus = LoadStatus.initial,
    this.message = '',
    this.user,
    this.isHaveUser = false,
  });

  @override
  List<Object?> get props => [
        loadStatus,
        updateStatus,
        updateTargetScoreStatus,
        message,
        user,
        isHaveUser,
      ];

  UserState copyWith({
    LoadStatus? loadStatus,
    LoadStatus? updateStatus,
    LoadStatus? updateTargetScoreStatus,
    String? message,
    UserEntity? user,
    bool? isHaveUser,
  }) {
    return UserState(
      loadStatus: loadStatus ?? this.loadStatus,
      updateStatus: updateStatus ?? this.updateStatus,
      updateTargetScoreStatus:
          updateTargetScoreStatus ?? this.updateTargetScoreStatus,
      message: message ?? this.message,
      user: (isHaveUser ?? this.isHaveUser) == true ? user ?? this.user : null,
      isHaveUser: isHaveUser ?? this.isHaveUser,
    );
  }
}
