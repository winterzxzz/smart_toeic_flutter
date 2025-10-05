// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_ai_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ChatMessage {
  String get id => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  bool get isUser => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Create a copy of ChatMessage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ChatMessageCopyWith<ChatMessage> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChatMessageCopyWith<$Res> {
  factory $ChatMessageCopyWith(
          ChatMessage value, $Res Function(ChatMessage) then) =
      _$ChatMessageCopyWithImpl<$Res, ChatMessage>;
  @useResult
  $Res call({String id, String content, bool isUser, DateTime createdAt});
}

/// @nodoc
class _$ChatMessageCopyWithImpl<$Res, $Val extends ChatMessage>
    implements $ChatMessageCopyWith<$Res> {
  _$ChatMessageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ChatMessage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? content = null,
    Object? isUser = null,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      isUser: null == isUser
          ? _value.isUser
          : isUser // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ChatMessageImplCopyWith<$Res>
    implements $ChatMessageCopyWith<$Res> {
  factory _$$ChatMessageImplCopyWith(
          _$ChatMessageImpl value, $Res Function(_$ChatMessageImpl) then) =
      __$$ChatMessageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String content, bool isUser, DateTime createdAt});
}

/// @nodoc
class __$$ChatMessageImplCopyWithImpl<$Res>
    extends _$ChatMessageCopyWithImpl<$Res, _$ChatMessageImpl>
    implements _$$ChatMessageImplCopyWith<$Res> {
  __$$ChatMessageImplCopyWithImpl(
      _$ChatMessageImpl _value, $Res Function(_$ChatMessageImpl) _then)
      : super(_value, _then);

  /// Create a copy of ChatMessage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? content = null,
    Object? isUser = null,
    Object? createdAt = null,
  }) {
    return _then(_$ChatMessageImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      isUser: null == isUser
          ? _value.isUser
          : isUser // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc

class _$ChatMessageImpl implements _ChatMessage {
  const _$ChatMessageImpl(
      {required this.id,
      required this.content,
      required this.isUser,
      required this.createdAt});

  @override
  final String id;
  @override
  final String content;
  @override
  final bool isUser;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'ChatMessage(id: $id, content: $content, isUser: $isUser, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChatMessageImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.isUser, isUser) || other.isUser == isUser) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, content, isUser, createdAt);

  /// Create a copy of ChatMessage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChatMessageImplCopyWith<_$ChatMessageImpl> get copyWith =>
      __$$ChatMessageImplCopyWithImpl<_$ChatMessageImpl>(this, _$identity);
}

abstract class _ChatMessage implements ChatMessage {
  const factory _ChatMessage(
      {required final String id,
      required final String content,
      required final bool isUser,
      required final DateTime createdAt}) = _$ChatMessageImpl;

  @override
  String get id;
  @override
  String get content;
  @override
  bool get isUser;
  @override
  DateTime get createdAt;

  /// Create a copy of ChatMessage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChatMessageImplCopyWith<_$ChatMessageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$ChatSession {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Create a copy of ChatSession
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ChatSessionCopyWith<ChatSession> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChatSessionCopyWith<$Res> {
  factory $ChatSessionCopyWith(
          ChatSession value, $Res Function(ChatSession) then) =
      _$ChatSessionCopyWithImpl<$Res, ChatSession>;
  @useResult
  $Res call({String id, String title, DateTime createdAt});
}

/// @nodoc
class _$ChatSessionCopyWithImpl<$Res, $Val extends ChatSession>
    implements $ChatSessionCopyWith<$Res> {
  _$ChatSessionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ChatSession
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ChatSessionImplCopyWith<$Res>
    implements $ChatSessionCopyWith<$Res> {
  factory _$$ChatSessionImplCopyWith(
          _$ChatSessionImpl value, $Res Function(_$ChatSessionImpl) then) =
      __$$ChatSessionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String title, DateTime createdAt});
}

/// @nodoc
class __$$ChatSessionImplCopyWithImpl<$Res>
    extends _$ChatSessionCopyWithImpl<$Res, _$ChatSessionImpl>
    implements _$$ChatSessionImplCopyWith<$Res> {
  __$$ChatSessionImplCopyWithImpl(
      _$ChatSessionImpl _value, $Res Function(_$ChatSessionImpl) _then)
      : super(_value, _then);

  /// Create a copy of ChatSession
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? createdAt = null,
  }) {
    return _then(_$ChatSessionImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc

class _$ChatSessionImpl implements _ChatSession {
  const _$ChatSessionImpl(
      {required this.id, required this.title, required this.createdAt});

  @override
  final String id;
  @override
  final String title;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'ChatSession(id: $id, title: $title, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChatSessionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, title, createdAt);

  /// Create a copy of ChatSession
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChatSessionImplCopyWith<_$ChatSessionImpl> get copyWith =>
      __$$ChatSessionImplCopyWithImpl<_$ChatSessionImpl>(this, _$identity);
}

abstract class _ChatSession implements ChatSession {
  const factory _ChatSession(
      {required final String id,
      required final String title,
      required final DateTime createdAt}) = _$ChatSessionImpl;

  @override
  String get id;
  @override
  String get title;
  @override
  DateTime get createdAt;

  /// Create a copy of ChatSession
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChatSessionImplCopyWith<_$ChatSessionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$ChatAiState {
  List<ChatSession> get sessions => throw _privateConstructorUsedError;
  ChatSession? get selectedSession => throw _privateConstructorUsedError;
  List<ChatMessage> get messages => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  ApiError? get error => throw _privateConstructorUsedError;
  String get input => throw _privateConstructorUsedError;

  /// Create a copy of ChatAiState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ChatAiStateCopyWith<ChatAiState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChatAiStateCopyWith<$Res> {
  factory $ChatAiStateCopyWith(
          ChatAiState value, $Res Function(ChatAiState) then) =
      _$ChatAiStateCopyWithImpl<$Res, ChatAiState>;
  @useResult
  $Res call(
      {List<ChatSession> sessions,
      ChatSession? selectedSession,
      List<ChatMessage> messages,
      bool isLoading,
      ApiError? error,
      String input});

  $ChatSessionCopyWith<$Res>? get selectedSession;
}

/// @nodoc
class _$ChatAiStateCopyWithImpl<$Res, $Val extends ChatAiState>
    implements $ChatAiStateCopyWith<$Res> {
  _$ChatAiStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ChatAiState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sessions = null,
    Object? selectedSession = freezed,
    Object? messages = null,
    Object? isLoading = null,
    Object? error = freezed,
    Object? input = null,
  }) {
    return _then(_value.copyWith(
      sessions: null == sessions
          ? _value.sessions
          : sessions // ignore: cast_nullable_to_non_nullable
              as List<ChatSession>,
      selectedSession: freezed == selectedSession
          ? _value.selectedSession
          : selectedSession // ignore: cast_nullable_to_non_nullable
              as ChatSession?,
      messages: null == messages
          ? _value.messages
          : messages // ignore: cast_nullable_to_non_nullable
              as List<ChatMessage>,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as ApiError?,
      input: null == input
          ? _value.input
          : input // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }

  /// Create a copy of ChatAiState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ChatSessionCopyWith<$Res>? get selectedSession {
    if (_value.selectedSession == null) {
      return null;
    }

    return $ChatSessionCopyWith<$Res>(_value.selectedSession!, (value) {
      return _then(_value.copyWith(selectedSession: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ChatAiStateImplCopyWith<$Res>
    implements $ChatAiStateCopyWith<$Res> {
  factory _$$ChatAiStateImplCopyWith(
          _$ChatAiStateImpl value, $Res Function(_$ChatAiStateImpl) then) =
      __$$ChatAiStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<ChatSession> sessions,
      ChatSession? selectedSession,
      List<ChatMessage> messages,
      bool isLoading,
      ApiError? error,
      String input});

  @override
  $ChatSessionCopyWith<$Res>? get selectedSession;
}

/// @nodoc
class __$$ChatAiStateImplCopyWithImpl<$Res>
    extends _$ChatAiStateCopyWithImpl<$Res, _$ChatAiStateImpl>
    implements _$$ChatAiStateImplCopyWith<$Res> {
  __$$ChatAiStateImplCopyWithImpl(
      _$ChatAiStateImpl _value, $Res Function(_$ChatAiStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of ChatAiState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sessions = null,
    Object? selectedSession = freezed,
    Object? messages = null,
    Object? isLoading = null,
    Object? error = freezed,
    Object? input = null,
  }) {
    return _then(_$ChatAiStateImpl(
      sessions: null == sessions
          ? _value._sessions
          : sessions // ignore: cast_nullable_to_non_nullable
              as List<ChatSession>,
      selectedSession: freezed == selectedSession
          ? _value.selectedSession
          : selectedSession // ignore: cast_nullable_to_non_nullable
              as ChatSession?,
      messages: null == messages
          ? _value._messages
          : messages // ignore: cast_nullable_to_non_nullable
              as List<ChatMessage>,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as ApiError?,
      input: null == input
          ? _value.input
          : input // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$ChatAiStateImpl implements _ChatAiState {
  const _$ChatAiStateImpl(
      {final List<ChatSession> sessions = const [],
      this.selectedSession,
      final List<ChatMessage> messages = const [],
      this.isLoading = false,
      this.error,
      this.input = ''})
      : _sessions = sessions,
        _messages = messages;

  final List<ChatSession> _sessions;
  @override
  @JsonKey()
  List<ChatSession> get sessions {
    if (_sessions is EqualUnmodifiableListView) return _sessions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_sessions);
  }

  @override
  final ChatSession? selectedSession;
  final List<ChatMessage> _messages;
  @override
  @JsonKey()
  List<ChatMessage> get messages {
    if (_messages is EqualUnmodifiableListView) return _messages;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_messages);
  }

  @override
  @JsonKey()
  final bool isLoading;
  @override
  final ApiError? error;
  @override
  @JsonKey()
  final String input;

  @override
  String toString() {
    return 'ChatAiState(sessions: $sessions, selectedSession: $selectedSession, messages: $messages, isLoading: $isLoading, error: $error, input: $input)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChatAiStateImpl &&
            const DeepCollectionEquality().equals(other._sessions, _sessions) &&
            (identical(other.selectedSession, selectedSession) ||
                other.selectedSession == selectedSession) &&
            const DeepCollectionEquality().equals(other._messages, _messages) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.input, input) || other.input == input));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_sessions),
      selectedSession,
      const DeepCollectionEquality().hash(_messages),
      isLoading,
      error,
      input);

  /// Create a copy of ChatAiState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChatAiStateImplCopyWith<_$ChatAiStateImpl> get copyWith =>
      __$$ChatAiStateImplCopyWithImpl<_$ChatAiStateImpl>(this, _$identity);
}

abstract class _ChatAiState implements ChatAiState {
  const factory _ChatAiState(
      {final List<ChatSession> sessions,
      final ChatSession? selectedSession,
      final List<ChatMessage> messages,
      final bool isLoading,
      final ApiError? error,
      final String input}) = _$ChatAiStateImpl;

  @override
  List<ChatSession> get sessions;
  @override
  ChatSession? get selectedSession;
  @override
  List<ChatMessage> get messages;
  @override
  bool get isLoading;
  @override
  ApiError? get error;
  @override
  String get input;

  /// Create a copy of ChatAiState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChatAiStateImplCopyWith<_$ChatAiStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
