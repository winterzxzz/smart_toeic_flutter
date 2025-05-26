import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toeic_desktop/data/models/enums/load_status.dart';
import 'package:toeic_desktop/data/network/repositories/blog_repository.dart';
import 'package:toeic_desktop/ui/page/blogs/blog_state.dart';

class BlogCubit extends Cubit<BlogState> {
  final BlogRepository blogRepository;
  BlogCubit(this.blogRepository) : super(BlogState.initial());

  Future<void> getBlog(String? blogId) async {
    emit(state.copyWith(loadStatus: LoadStatus.loading));

    final result = await blogRepository.getBlog();
    result.fold(
      (l) => emit(state.copyWith(
          loadStatus: LoadStatus.failure, message: l.message)),
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
    emit(state.copyWith(loadStatus: LoadStatus.loading));
    final searchBlogs = await blogRepository.searchBlog(keyword);
    searchBlogs.fold(
      (l) => emit(state.copyWith(
          loadStatus: LoadStatus.failure, message: l.message)),
      (r) {
        emit(state.copyWith(
          loadStatus: LoadStatus.success,
          searchBlogs: r,
        ));
      },
    );
  }
}
