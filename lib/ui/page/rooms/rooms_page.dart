import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:toeic_desktop/app.dart';
import 'package:toeic_desktop/common/router/route_config.dart';
import 'package:toeic_desktop/data/models/enums/load_status.dart';
import 'package:toeic_desktop/data/models/room_model.dart';
import 'package:toeic_desktop/ui/common/app_context.dart';
import 'package:toeic_desktop/ui/page/rooms/rooms_cubit.dart';
import 'package:toeic_desktop/ui/page/rooms/rooms_state.dart';
import 'widgets/room_card.dart';

class RoomsPage extends StatefulWidget {
  const RoomsPage({super.key});

  @override
  State<RoomsPage> createState() => _RoomsPageState();
}

class _RoomsPageState extends State<RoomsPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => injector<RoomsCubit>()..getRooms(),
      child: const Page(),
    );
  }
}

class Page extends StatefulWidget {
  const Page({super.key});

  @override
  State<Page> createState() => _PageState();
}

class _PageState extends State<Page> {
  late final RoomsCubit _roomsCubit;

  @override
  void initState() {
    super.initState();
    _roomsCubit = BlocProvider.of<RoomsCubit>(context);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    final colorScheme = context.colorScheme;
    return Scaffold(
      body: BlocBuilder<RoomsCubit, RoomsState>(
        builder: (context, state) {
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                title: Text('Live Streams', style: textTheme.titleMedium),
                floating: true,
                automaticallyImplyLeading: false,
                elevation: 0,
                actions: [
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.video_call_rounded)),
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.notification_add)),
                  IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
                ],
              ),
              if (state.loadStatus == LoadStatus.loading)
                const SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              else if (state.loadStatus == LoadStatus.failure)
                SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64,
                          color: colorScheme.error,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Failed to load rooms',
                          style: textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          state.message,
                          style: textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurface.withValues(alpha: 0.7),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _roomsCubit.getRooms,
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.all(8),
                  sliver: SliverGrid.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.7,
                      mainAxisSpacing: 2,
                      crossAxisSpacing: 2,
                    ),
                    itemBuilder: (context, index) {
                      final room = state.rooms[index];
                      return RoomCard(
                          room: room, onTap: () => _onRoomTap(room));
                    },
                    itemCount: state.rooms.length,
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  void _onRoomTap(RoomModel room) {
    GoRouter.of(context).push(AppRouter.liveStream);
  }
}
