
import 'package:equatable/equatable.dart';
import 'package:toeic_desktop/data/models/entities/blog/blog.dart';
import 'package:toeic_desktop/data/models/enums/load_status.dart';

class BlogState extends Equatable {
  final LoadStatus loadStatus;
  final List<Blog> blogs;
  final String message;

  const BlogState({
    required this.loadStatus,
    required this.blogs,
    required this.message,
  });

  // initial state
  factory BlogState.initial() {
    return BlogState(
      loadStatus: LoadStatus.initial,
      blogs: [],
      message: '',
    );
  }

  BlogState copyWith({
    LoadStatus? loadStatus,
    List<Blog>? blogs,
    String? message,
  }) {
    return BlogState(
      loadStatus: loadStatus ?? this.loadStatus,
      blogs: blogs ?? this.blogs,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [loadStatus, blogs, message];
}
