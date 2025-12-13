import 'dart:async';
import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toeic_desktop/common/configs/app_configs.dart';
import 'package:toeic_desktop/common/services/socket_service.dart';
import 'package:toeic_desktop/data/models/chatbox/ai_chat_session.dart';
import 'package:toeic_desktop/data/network/repositories/chat_ai_repository.dart';
import 'package:toeic_desktop/ui/page/chat_ai/chat_ai_state.dart';

// State, message, session moved to chat_ai_state.dart using Equatable

class ChatAiCubit extends Cubit<ChatAiState> {
  ChatAiCubit(this._repository) : super(const ChatAiState()) {
    _initializeSocket();
    _loadSessions();
  }

  final ChatAiRepository _repository;
  final SocketService _socketService = SocketService();
  StreamSubscription<Map<String, dynamic>>? _sessionCreatedSubscription;
  StreamSubscription<Map<String, dynamic>>? _chatStreamSubscription;
  StreamSubscription<Map<String, dynamic>>? _streamCompleteSubscription;
  String? _tempSessionId;

  void _initializeSocket() {
    // Kết nối tới server Socket.IO
    // cắt đoạn /api/
    _socketService.connect(AppConfigs.baseUrl.replaceAll('/api', ''));

    // Lắng nghe event session_created
    _sessionCreatedSubscription =
        _socketService.sessionCreatedStream.listen((data) {
      final sessionId = data['sessionId'] as String?;
      if (sessionId == null) return;

      // If we created a temp session, replace its id with the real one
      final current = state.selectedSession;
      if (current != null && (current.id == _tempSessionId)) {
        final updatedSelected = ChatSession(
          id: sessionId,
          title: current.title,
          createdAt: current.createdAt,
        );
        final updatedSessions = state.sessions
            .map((s) => s.id == _tempSessionId ? updatedSelected : s)
            .toList();
        _tempSessionId = null;
        emit(state.copyWith(
          selectedSession: updatedSelected,
          sessions: updatedSessions,
        ));
        return;
      }

      // Fallback: if nothing selected, select the created session
      emit(state.copyWith(
        selectedSession: ChatSession(
          id: sessionId,
          title: state.selectedSession?.title ?? '',
          createdAt: DateTime.now(),
        ),
      ));
    });

    // Lắng nghe event chat_stream
    _chatStreamSubscription = _socketService.chatStreamStream.listen((data) {
      final chunk = data['chunk'] as String?;
      if (chunk != null) {
        _handleStreamingChunk(chunk);
      }
    });

    // Lắng nghe event stream_complete
    _streamCompleteSubscription =
        _socketService.streamCompleteStream.listen((data) {
      finishStreaming();
    });
  }

  Future<void> _loadSessions() async {
    emit(state.copyWith(isLoading: true, error: null));
    final res = await _repository.getAiChatSessions();
    res.fold(
      (l) => emit(state.copyWith(isLoading: false, error: l)),
      (r) {
        try {
          final List<AiChatSession> data = r;
          final sessions = data
              .map((e) => ChatSession(
                    id: e.id,
                    title: e.title,
                    createdAt: e.createdAt,
                  ))
              .toList();
          emit(state.copyWith(sessions: sessions, isLoading: false));
        } catch (_) {
          emit(state.copyWith(sessions: const [], isLoading: false));
        }
      },
    );
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

  void createTempSession() {
    final tempId = 'temp_${DateTime.now().microsecondsSinceEpoch}';
    final temp = ChatSession(
      id: tempId,
      title: '',
      createdAt: DateTime.now(),
    );
    emit(state.copyWith(
      sessions: [...state.sessions, temp],
      selectedSession: temp,
      messages: const [],
      error: null,
    ));
    _tempSessionId = tempId;
  }

  Future<void> selectSession(ChatSession session) async {
    // If selecting a temp session, do not call API
    if (session.id.startsWith('temp_')) {
      emit(state.copyWith(
        selectedSession: session,
        messages: const [],
        isLoading: false,
        error: null,
      ));
      return;
    }
    emit(
        state.copyWith(selectedSession: session, isLoading: true, error: null));
    final res = await _repository.getAiChatHistory(session.id);
    res.fold(
      (l) => emit(state.copyWith(isLoading: false, error: l)),
      (r) {
        try {
          // r is JSON string from API
          final List<dynamic> data = jsonDecode(r) as List<dynamic>;
          final messages = data.map((raw) {
            final Map<String, dynamic> e = raw as Map<String, dynamic>;
            final String id = (e['id'] ??
                    e['_id'] ??
                    DateTime.now().microsecondsSinceEpoch.toString())
                .toString();
            final String content = (e['content'] ?? '').toString();
            final String role = (e['role'] ?? '').toString();
            final String createdAtStr = (e['createdAt'] ??
                    e['created_at'] ??
                    DateTime.now().toIso8601String())
                .toString();
            return ChatMessage(
              id: id,
              content: content,
              isUser: role == 'user',
              createdAt: DateTime.tryParse(createdAtStr) ?? DateTime.now(),
            );
          }).toList();
          emit(state.copyWith(messages: messages, isLoading: false));
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

    // Derive a title from the first message
    String deriveTitle(String text) {
      final trimmed = text.trim();
      if (trimmed.isEmpty) return '';
      final normalized = trimmed.replaceAll(RegExp(r'\s+'), ' ');
      return normalized.length <= 60 ? normalized : normalized.substring(0, 60);
    }

    ChatSession? selected = state.selectedSession;
    List<ChatSession> sessions = state.sessions;

    // If no session selected, create a temp one using the first message as title
    if (selected == null) {
      _tempSessionId = 'temp_${DateTime.now().microsecondsSinceEpoch}';
      final temp = ChatSession(
        id: _tempSessionId!,
        title: deriveTitle(userMsg.content),
        createdAt: DateTime.now(),
      );
      sessions = [...sessions, temp];
      selected = temp;
    } else if (selected.title.trim().isEmpty) {
      // If session exists but has no title, set it from the first message
      final renamed = ChatSession(
        id: selected.id,
        title: deriveTitle(userMsg.content),
        createdAt: selected.createdAt,
      );
      final selectedId = selected.id;
      sessions = sessions.map((s) => s.id == selectedId ? renamed : s).toList();
      selected = renamed;
    }

    emit(state.copyWith(
      sessions: sessions,
      selectedSession: selected,
      messages: [...state.messages, userMsg],
      input: '',
      isLoading: true,
      isStreaming: true,
      streamingMessage: '',
      error: null,
    ));

    // Fallback: nếu Socket.IO không hoạt động, sử dụng HTTP API
    final res = await _repository.sendAiChatMessage(
        sessionId: selected.id.startsWith('temp_') ? '' : selected.id,
        content: userMsg.content,
        socketId: _socketService.socketId ?? '');
    res.fold(
      (l) =>
          emit(state.copyWith(isLoading: false, isStreaming: false, error: l)),
      (r) {
        // Use HTTP response as fallback if streaming didn't receive any chunks
        // Wait a short time to see if streaming delivers content
        Future.delayed(const Duration(milliseconds: 500), () {
          // If still streaming but no content received via socket, use HTTP response
          if (state.isStreaming &&
              state.streamingMessage.isEmpty &&
              r.isNotEmpty) {
            final aiMsg = ChatMessage(
              id: DateTime.now().microsecondsSinceEpoch.toString(),
              content: r,
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
        });
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
    // If temp session, just remove locally
    if (session.id.startsWith('temp_')) {
      final remaining =
          state.sessions.where((s) => s.id != session.id).toList();
      final nextSelected = remaining.isEmpty ? null : remaining.last;
      emit(state.copyWith(
        sessions: remaining,
        selectedSession: nextSelected,
        messages: const [],
        isLoading: false,
      ));
      if (nextSelected != null) {
        await selectSession(nextSelected);
      }
      return;
    }
    emit(state.copyWith(isLoading: true, error: null));
    final res = await _repository.deleteAiChatHistory(session.id);
    res.fold(
      (l) => emit(state.copyWith(isLoading: false, error: l)),
      (r) async {
        final remaining =
            state.sessions.where((s) => s.id != session.id).toList();
        final nextSelected = remaining.isEmpty ? null : remaining.last;
        emit(state.copyWith(
          sessions: remaining,
          selectedSession: nextSelected,
          messages: const [],
          isLoading: false,
        ));
        if (nextSelected != null) {
          await selectSession(nextSelected);
        }
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
