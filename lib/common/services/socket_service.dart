import 'dart:async';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class SocketService {
  static final SocketService _instance = SocketService._internal();
  factory SocketService() => _instance;
  SocketService._internal();

  io.Socket? _socket;
  String? _socketId;
  // get session id
  final StreamController<Map<String, dynamic>> _sessionCreatedController =
      StreamController<Map<String, dynamic>>.broadcast();
  final StreamController<Map<String, dynamic>> _streamStartedController =
      StreamController<Map<String, dynamic>>.broadcast();
  final StreamController<Map<String, dynamic>> _chatStreamController =
      StreamController<Map<String, dynamic>>.broadcast();
  final StreamController<Map<String, dynamic>> _streamCompleteController =
      StreamController<Map<String, dynamic>>.broadcast();
  // Getters for streams
  Stream<Map<String, dynamic>> get sessionCreatedStream =>
      _sessionCreatedController.stream;
  Stream<Map<String, dynamic>> get streamStartedStream =>
      _streamStartedController.stream;
  Stream<Map<String, dynamic>> get chatStreamStream =>
      _chatStreamController.stream;
  Stream<Map<String, dynamic>> get streamCompleteStream =>
      _streamCompleteController.stream;
  String? get socketId => _socketId;

  bool get isConnected => _socket?.connected ?? false;

  Future<void> connect(String serverUrl) async {
    try {
      _socket = io.io(
          serverUrl,
          io.OptionBuilder()
              .setTransports(['websocket'])
              .enableAutoConnect()
              .build());

      _socket!.onConnect((_) {
        debugPrint('Socket connected');
        _socketId = _socket!.id;
      });

      _socket!.onDisconnect((_) {
        debugPrint('Socket disconnected');
        _socketId = null;
      });

      _socket!.onError((error) {
        debugPrint('Socket error: $error');
      });

      // Lắng nghe event session_created
      _socket!.on('session_created', (data) {
        _sessionCreatedController.add(data);
      });

      _socket!.on('stream_start', (data) {
        _streamStartedController.add(data);
      });

      // Lắng nghe event chat_stream
      _socket!.on('chat_stream', (data) {
        _chatStreamController.add(data);
      });

      _socket!.on('stream_complete', (data) {
        _streamCompleteController.add(data);
      });
    } catch (e) {
      debugPrint('Error connecting to socket: $e');
    }
  }

  void disconnect() {
    _socket?.disconnect();
    _socket?.dispose();
    _socket = null;
    _socketId = null;
  }

  void emit(String event, dynamic data) {
    _socket?.emit(event, data);
  }

  void on(String event, Function(dynamic) callback) {
    _socket?.on(event, callback);
  }

  void off(String event, [Function(dynamic)? callback]) {
    _socket?.off(event, callback);
  }

  void dispose() {
    _sessionCreatedController.close();
    _streamStartedController.close();
    _chatStreamController.close();
    _streamCompleteController.close();
    disconnect();
  }
}
