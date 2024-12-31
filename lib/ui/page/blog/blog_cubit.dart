
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toeic_desktop/data/models/enums/load_status.dart';
import 'package:toeic_desktop/data/network/repositories/blog_repository.dart';
import 'package:toeic_desktop/ui/page/blog/blog_state.dart';

class BlogCubit extends Cubit<BlogState> {
  final BlogRepository blogRepository;
  BlogCubit(this.blogRepository) : super(BlogState.initial());


  void getBlog() async {
    emit(state.copyWith(loadStatus: LoadStatus.loading));
    final result = await blogRepository.getBlog();
    result.fold(
      (l) => emit(state.copyWith(loadStatus: LoadStatus.failure, message: l.errors?.first.message)),
      (r) => emit(state.copyWith(loadStatus: LoadStatus.success, blogs: r)),
    );
  }
}
