import 'dart:io';

import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:toeic_desktop/common/configs/app_configs.dart';
import 'package:toeic_desktop/data/models/entities/rooms/room_db.dart';
import 'package:toeic_desktop/data/models/request/create_room_request.dart';
import 'package:toeic_desktop/data/models/ui_models/rooms/live_args.dart';
import 'package:toeic_desktop/data/network/api_config/api_client.dart';
import 'package:toeic_desktop/data/network/error/api_error.dart';

import '../../models/ui_models/rooms/room_model.dart';

abstract class RoomRepository {
  Future<Either<ApiError, List<RoomModel>>> getRooms();
  Future<Either<ApiError, List<RoomModel>>> getRoomsByCategory(String category);
  Future<Either<ApiError, RoomModel>> getRoomById(String id);
  Future<Either<Exception, Room>> connect(String token);
  Future<Either<ApiError, RoomDb>> createRoom(CreateRoomRequest request);
  Future<Either<ApiError, LiveArgs>> startLive(RoomDb room);
}

class RoomRepositoryImpl implements RoomRepository {
  final ApiClient _apiClient;

  RoomRepositoryImpl(this._apiClient);

  static const List<RoomModel> _sampleRooms = [
    RoomModel(
      id: '1',
      title: '欢乐直播',
      description: '德云色 云顶寻找神之一手',
      creator: '老实憨厚的笑笑',
      viewCount: 1093000,
      imageUrl: 'https://picsum.photos/400/300?random=1',
      category: 'Gaming',
      isLive: true,
    ),
    RoomModel(
      id: '2',
      title: '夏超甜',
      description: '古灵精怪DOTA2少女',
      creator: '叫~我~小~夏~就~好~!',
      viewCount: 511000,
      imageUrl: 'https://picsum.photos/400/300?random=2',
      category: 'Gaming',
      isLive: true,
    ),
    RoomModel(
      id: '3',
      title: '国一香香',
      description: '国一孙尚香带粉 有车位...',
      creator: '甜辰不加糖',
      viewCount: 418000,
      imageUrl: 'https://picsum.photos/400/300?random=3',
      category: 'Gaming',
      isLive: true,
    ),
    RoomModel(
      id: '4',
      title: '全麦反差',
      description: '老公甜我-招主持',
      creator: '全麦反差',
      viewCount: 321000,
      imageUrl: 'https://picsum.photos/400/300?random=4',
      category: 'Entertainment',
      isLive: true,
    ),
    RoomModel(
      id: '5',
      title: '无畏竞巅峰',
      description: '【预告】2月27日17:00...',
      creator: '哔哩哔哩英雄联盟赛事',
      viewCount: 318000,
      imageUrl: 'https://picsum.photos/400/300?random=5',
      category: 'Esports',
      isLive: false,
    ),
    RoomModel(
      id: '6',
      title: '热水器忽冷忽热',
      description: '热水器忽冷忽热就是有...',
      creator: '芳心暗许-有萧亦有晴',
      viewCount: 315000,
      imageUrl: 'https://picsum.photos/400/300?random=6',
      category: 'Entertainment',
      isLive: true,
    ),
    RoomModel(
      id: '7',
      title: 'Flutter Development',
      description: 'Building amazing mobile apps',
      creator: 'Flutter Developer',
      viewCount: 250000,
      imageUrl: 'https://picsum.photos/400/300?random=7',
      category: 'Technology',
      isLive: true,
    ),
    RoomModel(
      id: '8',
      title: 'Cooking Masterclass',
      description: 'Learn to cook like a pro',
      creator: 'Chef Master',
      viewCount: 180000,
      imageUrl: 'https://picsum.photos/400/300?random=8',
      category: 'Lifestyle',
      isLive: false,
    ),
  ];

  @override
  Future<Either<ApiError, List<RoomModel>>> getRooms() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    return const Right(_sampleRooms);
  }

  @override
  Future<Either<ApiError, List<RoomModel>>> getRoomsByCategory(
      String category) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return Right(
        _sampleRooms.where((room) => room.category == category).toList());
  }

  @override
  Future<Either<ApiError, RoomModel>> getRoomById(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    try {
      return Right(_sampleRooms.firstWhere((room) => room.id == id));
    } on DioException catch (e) {
      return Left(ApiError.fromDioError(e));
    }
  }

  @override
  Future<Either<ApiError, RoomDb>> createRoom(CreateRoomRequest request) async {
    try {
      final file = File(request.thumbnail);
      final thumbnail = await _apiClient.uploadFile(file);
      final newRequest = request.copyWith(thumbnail: thumbnail);
      final response = await _apiClient.createRoom(newRequest);
      return Right(response);
    } on DioException catch (e) {
      return Left(ApiError.fromDioError(e));
    }
  }

  @override
  Future<Either<Exception, Room>> connect(String token) async {
    try {
      final room = Room(
          roomOptions: const RoomOptions(
        adaptiveStream: true,
        dynacast: true,
      ));
      await room.connect(AppConfigs.livekitWss, token,
          connectOptions: const ConnectOptions(autoSubscribe: true));
      return Right(room);
    } catch (e) {
      return Left(Exception(e));
    }
  }

  @override
  Future<Either<ApiError, LiveArgs>> startLive(RoomDb roomDb) async {
    try {
      final token = await _apiClient.createLivekitRoom(roomDb.id.toString());
      final room = Room(
          roomOptions: const RoomOptions(
        adaptiveStream: true,
        dynacast: true,
      ));
      final listener = room.createListener();
      return Right(LiveArgs(
        roomId: roomDb.id,
        room: room,
        listener: listener,
        currentCameraDescription: null,
        isOpenCamera: true,
        isOpenMic: true,
        token: token,
      ));
    } on DioException catch (e) {
      return Left(ApiError.fromDioError(e));
    }
  }
}
