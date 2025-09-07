import 'package:equatable/equatable.dart';
import 'package:toeic_desktop/data/models/enums/load_status.dart';
import 'package:toeic_desktop/data/models/room_model.dart';

class RoomsState extends Equatable {
  final LoadStatus loadStatus;
  final String message;
  final List<RoomModel> rooms;

  const RoomsState({
    required this.loadStatus,
    required this.message,
    required this.rooms,
  });

  factory RoomsState.initial() => const RoomsState(
        loadStatus: LoadStatus.initial,
        message: '',
        rooms: [],
      );

  RoomsState copyWith({
    LoadStatus? loadStatus,
    String? message,
    List<RoomModel>? rooms,
  }) =>
      RoomsState(
        loadStatus: loadStatus ?? this.loadStatus,
        message: message ?? this.message,
        rooms: rooms ?? this.rooms,
      );

  @override
  List<Object?> get props => [loadStatus, message, rooms];
}
