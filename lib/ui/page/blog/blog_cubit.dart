import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toeic_desktop/data/models/entities/blog/blog.dart';
import 'package:toeic_desktop/data/models/enums/load_status.dart';
import 'package:toeic_desktop/data/network/repositories/blog_repository.dart';
import 'package:toeic_desktop/ui/page/blog/blog_state.dart';

class BlogCubit extends Cubit<BlogState> {
  final BlogRepository blogRepository;
  BlogCubit(this.blogRepository) : super(BlogState.initial());

  Future<void> getBlog() async {
    // Ensure loading state is emitted
    await Future.microtask(
        () => emit(state.copyWith(loadStatus: LoadStatus.loading)));

    final result = await blogRepository.getBlog();
    result.fold(
      (l) => emit(state.copyWith(
          loadStatus: LoadStatus.failure, message: l.errors?.first.message)),
      (r) => emit(state.copyWith(
          loadStatus: LoadStatus.success,
          blogs: r,
          searchBlogs: r,
          focusBlog: r.first)),
    );
  }

  // search
  void searchBlog(String keyword) {
    final searchBlogs = state.blogs
        .where((blog) => blog.title?.contains(keyword) ?? false)
        .toList();
    emit(
        state.copyWith(searchBlogs: searchBlogs, focusBlog: searchBlogs.first));
  }

  void setFocusBlog(Blog blog) {
    emit(state.copyWith(focusBlog: blog));
  }
}
