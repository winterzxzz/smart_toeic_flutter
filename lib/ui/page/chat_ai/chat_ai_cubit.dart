import 'dart:async';
import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:toeic_desktop/common/configs/app_configs.dart';
import 'package:toeic_desktop/common/services/socket_service.dart';
import 'package:toeic_desktop/data/network/error/api_error.dart';
import 'package:toeic_desktop/data/network/repositories/chat_ai_repository.dart';

part 'chat_ai_cubit.freezed.dart';

@freezed
class ChatMessage with _$ChatMessage {
  const factory ChatMessage({
    required String id,
    required String content,
    required bool isUser,
    required DateTime createdAt,
  }) = _ChatMessage;
}

@freezed
class ChatSession with _$ChatSession {
  const factory ChatSession({
    required String id,
    required String title,
    required DateTime createdAt,
  }) = _ChatSession;
}

@freezed
class ChatAiState with _$ChatAiState {
  const factory ChatAiState({
    @Default([]) List<ChatSession> sessions,
    ChatSession? selectedSession,
    @Default([]) List<ChatMessage> messages,
    @Default(false) bool isLoading,
    ApiError? error,
    @Default('') String input,
    @Default('') String streamingMessage,
    @Default(false) bool isStreaming,
  }) = _ChatAiState;
}

class ChatAiCubit extends Cubit<ChatAiState> {
  ChatAiCubit(this._repository) : super(const ChatAiState()) {
    _initializeSocket();
  }

  final ChatAiRepository _repository;
  final SocketService _socketService = SocketService();
  StreamSubscription<Map<String, dynamic>>? _sessionCreatedSubscription;
  StreamSubscription<Map<String, dynamic>>? _chatStreamSubscription;
  StreamSubscription<Map<String, dynamic>>? _streamCompleteSubscription;

  void _initializeSocket() {
    // Kết nối tới server Socket.IO
    // cắt đoạn /api/
    _socketService.connect(AppConfigs.baseUrl.replaceAll('/api', ''));

    // Lắng nghe event session_created
    _sessionCreatedSubscription =
        _socketService.sessionCreatedStream.listen((data) {
      final sessionId = data['sessionId'] as String?;
      if (sessionId != null) {
        emit(state.copyWith(
            selectedSession: ChatSession(
                id: sessionId, title: '', createdAt: DateTime.now())));
      }
    });

    // Lắng nghe event chat_stream
    _chatStreamSubscription = _socketService.chatStreamStream.listen((data) {
      final chunk = data['chunk'] as String?;
      if (chunk != null) {
        _handleStreamingChunk(chunk);
      }
    });

    // Lắng nghe event stream_complete
    _streamCompleteSubscription = _socketService.streamCompleteStream.listen((data) {
      emit(state.copyWith(isStreaming: false));
    });
  }

  void _handleStreamingChunk(String chunk) {
    if (state.isStreaming) {
      // Nếu đang streaming, cập nhật message hiện tại
      emit(state.copyWith(
        streamingMessage: state.streamingMessage + chunk,
      ));
    }
  }

  void onInputChanged(String value) => emit(state.copyWith(input: value));

  Future<void> createSession(String title) async {
    emit(state.copyWith(isLoading: true, error: null));
    final result = await _repository.createAiChatSession(title);
    return result.fold(
      (l) => emit(state.copyWith(isLoading: false, error: l)),
      (r) {
        final newSession = ChatSession(
          id: r,
          title: title,
          createdAt: DateTime.now(),
        );
        final updated = [...state.sessions, newSession];
        emit(state.copyWith(
          sessions: updated,
          selectedSession: newSession,
          isLoading: false,
        ));
      },
    );
  }

  Future<void> selectSession(ChatSession session) async {
    emit(
        state.copyWith(selectedSession: session, isLoading: true, error: null));
    final res = await _repository.getAiChatHistory(session.id);
    res.fold(
      (l) => emit(state.copyWith(isLoading: false, error: l)),
      (r) {
        // Demo parsing, expect r as JSON list
        try {
          final List<dynamic> data = jsonDecode(r) as List<dynamic>;
          final parsed = data
              .map((e) => ChatMessage(
                    id: e['id'] as String,
                    content: e['content'] as String,
                    isUser: e['is_user'] as bool,
                    createdAt: DateTime.parse(e['created_at'] as String),
                  ))
              .toList();
          emit(state.copyWith(messages: parsed, isLoading: false));
        } catch (_) {
          emit(state.copyWith(messages: const [], isLoading: false));
        }
      },
    );
  }

  Future<void> sendMessage() async {
    if (state.input.trim().isEmpty) return;

    final userMsg = ChatMessage(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      content: state.input.trim(),
      isUser: true,
      createdAt: DateTime.now(),
    );

    emit(state.copyWith(
      messages: [...state.messages, userMsg],
      input: '',
      isLoading: true,
      isStreaming: true,
      streamingMessage: '',
      error: null,
    ));

    // Fallback: nếu Socket.IO không hoạt động, sử dụng HTTP API
    final res = await _repository.sendAiChatMessage(
        sessionId: state.selectedSession?.id ?? '',
        content: userMsg.content,
        socketId: _socketService.socketId ?? '');
    res.fold(
      (l) =>
          emit(state.copyWith(isLoading: false, isStreaming: false, error: l)),
      (r) {
        // Nếu không có streaming, thêm message hoàn chỉnh
        if (!state.isStreaming) {
          emit(state.copyWith(
            isLoading: false,
          ));
        }
      },
    );
  }

  void finishStreaming() {
    if (state.isStreaming && state.streamingMessage.isNotEmpty) {
      final aiMsg = ChatMessage(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        content: state.streamingMessage,
        isUser: false,
        createdAt: DateTime.now(),
      );
      emit(state.copyWith(
        messages: [...state.messages, aiMsg],
        isLoading: false,
        isStreaming: false,
        streamingMessage: '',
      ));
    }
  }

  Future<void> deleteCurrentSession() async {
    final session = state.selectedSession;
    if (session == null) return;
    emit(state.copyWith(isLoading: true, error: null));
    final res = await _repository.deleteAiChatHistory(session.id);
    res.fold(
      (l) => emit(state.copyWith(isLoading: false, error: l)),
      (r) {
        final remaining =
            state.sessions.where((s) => s.id != session.id).toList();
        emit(state.copyWith(
          sessions: remaining,
          selectedSession: remaining.isEmpty ? null : remaining.last,
          messages: const [],
          isLoading: false,
        ));
      },
    );
  }

  @override
  Future<void> close() {
    _sessionCreatedSubscription?.cancel();
    _chatStreamSubscription?.cancel();
    _streamCompleteSubscription?.cancel();
    _socketService.dispose();
    return super.close();
  }
}
