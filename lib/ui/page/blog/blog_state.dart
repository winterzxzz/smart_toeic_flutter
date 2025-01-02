import 'package:equatable/equatable.dart';
import 'package:toeic_desktop/data/models/entities/blog/blog.dart';
import 'package:toeic_desktop/data/models/enums/load_status.dart';

class BlogState extends Equatable {
  final LoadStatus loadStatus;
  final List<Blog> blogs;
  final List<Blog> searchBlogs;
  final Blog? focusBlog;
  final String message;

  const BlogState({
    required this.loadStatus,
    required this.blogs,
    required this.searchBlogs,
    this.focusBlog,
    required this.message,
  });

  // initial state
  factory BlogState.initial() {
    return BlogState(
      loadStatus: LoadStatus.initial,
      blogs: [],
      searchBlogs: [],
      message: '',
      focusBlog: null,
    );
  }

  BlogState copyWith({
    LoadStatus? loadStatus,
    List<Blog>? blogs,
    List<Blog>? searchBlogs,
    String? message,
    Blog? focusBlog,
  }) {
    return BlogState(
      loadStatus: loadStatus ?? this.loadStatus,
      blogs: blogs ?? this.blogs,
      searchBlogs: searchBlogs ?? this.searchBlogs,
      message: message ?? this.message,
      focusBlog: focusBlog ?? this.focusBlog,
    );
  }

  @override
  List<Object?> get props =>
      [loadStatus, blogs, searchBlogs, message, focusBlog];
}
