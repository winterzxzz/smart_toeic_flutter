import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toeic_desktop/data/models/enums/load_status.dart';
import 'package:toeic_desktop/data/network/repositories/room_repository.dart';
import 'package:toeic_desktop/ui/page/rooms/rooms_state.dart';

class RoomsCubit extends Cubit<RoomsState> {
  final RoomRepository _roomRepository;
  RoomsCubit(this._roomRepository) : super(RoomsState.initial());

  Future<void> getRooms() async {
    emit(state.copyWith(loadStatus: LoadStatus.loading));
    final rs = await _roomRepository.getRooms();
    rs.fold(
        (l) => {
              emit(state.copyWith(
                  loadStatus: LoadStatus.failure, message: l.message)),
            },
        (r) => {
              emit(state.copyWith(loadStatus: LoadStatus.success, rooms: r)),
            });
  }
}
