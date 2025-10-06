import 'package:equatable/equatable.dart';
import 'package:toeic_desktop/data/network/error/api_error.dart';

class ChatMessage extends Equatable {
  const ChatMessage({
    required this.id,
    required this.content,
    required this.isUser,
    required this.createdAt,
  });

  final String id;
  final String content;
  final bool isUser;
  final DateTime createdAt;

  ChatMessage copyWith({
    String? id,
    String? content,
    bool? isUser,
    DateTime? createdAt,
  }) => ChatMessage(
        id: id ?? this.id,
        content: content ?? this.content,
        isUser: isUser ?? this.isUser,
        createdAt: createdAt ?? this.createdAt,
      );

  @override
  List<Object?> get props => [id, content, isUser, createdAt];
}

class ChatSession extends Equatable {
  const ChatSession({
    required this.id,
    required this.title,
    required this.createdAt,
  });

  final String id;
  final String title;
  final DateTime createdAt;

  ChatSession copyWith({
    String? id,
    String? title,
    DateTime? createdAt,
  }) => ChatSession(
        id: id ?? this.id,
        title: title ?? this.title,
        createdAt: createdAt ?? this.createdAt,
      );

  @override
  List<Object?> get props => [id, title, createdAt];
}

class ChatAiState extends Equatable {
  const ChatAiState({
    this.sessions = const [],
    this.selectedSession,
    this.messages = const [],
    this.isLoading = false,
    this.error,
    this.input = '',
    this.streamingMessage = '',
    this.isStreaming = false,
  });

  final List<ChatSession> sessions;
  final ChatSession? selectedSession;
  final List<ChatMessage> messages;
  final bool isLoading;
  final ApiError? error;
  final String input;
  final String streamingMessage;
  final bool isStreaming;

  ChatAiState copyWith({
    List<ChatSession>? sessions,
    ChatSession? selectedSession,
    bool clearSelectedSession = false,
    List<ChatMessage>? messages,
    bool? isLoading,
    ApiError? error,
    bool clearError = false,
    String? input,
    String? streamingMessage,
    bool? isStreaming,
  }) => ChatAiState(
        sessions: sessions ?? this.sessions,
        selectedSession:
            clearSelectedSession ? null : (selectedSession ?? this.selectedSession),
        messages: messages ?? this.messages,
        isLoading: isLoading ?? this.isLoading,
        error: clearError ? null : (error ?? this.error),
        input: input ?? this.input,
        streamingMessage: streamingMessage ?? this.streamingMessage,
        isStreaming: isStreaming ?? this.isStreaming,
      );

  @override
  List<Object?> get props => [
        sessions,
        selectedSession,
        messages,
        isLoading,
        error,
        input,
        streamingMessage,
        isStreaming,
      ];
}


