import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:toeic_desktop/ui/page/live_stream/live_stream_state.dart';

class LiveStreamCubit extends Cubit<LiveStreamState> {
  final Room _room;
  late final EventsListener<RoomEvent> _listener;
  LiveStreamCubit(this._room) : super(LiveStreamState.initial()) {
    _setupListener();
  }

  void _setupListener() {
    _listener = _room.createListener();
  }
}
