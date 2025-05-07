import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toeic_desktop/data/models/enums/load_status.dart';
import 'package:toeic_desktop/data/network/repositories/blog_repository.dart';
import 'package:toeic_desktop/ui/page/blog/blog_state.dart';

class BlogCubit extends Cubit<BlogState> {
  final BlogRepository blogRepository;
  BlogCubit(this.blogRepository) : super(BlogState.initial());

  Future<void> getBlog(String? blogId) async {
    log('getBlog: $blogId');
    // Ensure loading state is emitted
    await Future.microtask(
        () => emit(state.copyWith(loadStatus: LoadStatus.loading)));

    final result = await blogRepository.getBlog();
    result.fold(
      (l) => emit(state.copyWith(
          loadStatus: LoadStatus.failure, message: l.errors?.first.message)),
      (r) {
        if (blogId != null) {
          emit(state.copyWith(
            loadStatus: LoadStatus.success,
            blogs: r,
            searchBlogs: r,
          ));
        } else {
          emit(state.copyWith(
            loadStatus: LoadStatus.success,
            blogs: r,
            searchBlogs: r,
          ));
        }
      },
    );
  }

  // search
  void searchBlog(String keyword) async {
    if (keyword.isEmpty) {
      emit(state.copyWith(
        searchBlogs: state.blogs,
      ));
      return;
    }
    await Future.microtask(
        () => emit(state.copyWith(loadStatus: LoadStatus.loading)));
    final searchBlogs = await blogRepository.searchBlog(keyword);
    searchBlogs.fold(
      (l) => emit(state.copyWith(
          loadStatus: LoadStatus.failure, message: l.errors?.first.message)),
      (r) {
        emit(state.copyWith(
          loadStatus: LoadStatus.success,
          searchBlogs: r,
        ));
      },
    );
  }
}
