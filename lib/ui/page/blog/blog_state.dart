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

  factory BlogState.initial() => const BlogState(
        loadStatus: LoadStatus.initial,
        blogs: [],
        searchBlogs: [],
        message: '',
      );

  BlogState copyWith({
    LoadStatus? loadStatus,
    List<Blog>? blogs,
    List<Blog>? searchBlogs,
    Blog? focusBlog,
    String? message,
  }) {
    return BlogState(
      loadStatus: loadStatus ?? this.loadStatus,
      blogs: blogs ?? this.blogs,
      searchBlogs: searchBlogs ?? this.searchBlogs,
      focusBlog: focusBlog ?? this.focusBlog,
      message: message ?? this.message,
    );
  }

  bool get isLoading => loadStatus == LoadStatus.loading;
  bool get isSuccess => loadStatus == LoadStatus.success;
  bool get isFailure => loadStatus == LoadStatus.failure;
  bool get hasError => message.isNotEmpty;
  bool get hasBlogs => blogs.isNotEmpty;
  bool get hasSearchResults => searchBlogs.isNotEmpty;

  @override
  List<Object?> get props => [
        loadStatus,
        blogs,
        searchBlogs,
        focusBlog,
        message,
      ];
}
