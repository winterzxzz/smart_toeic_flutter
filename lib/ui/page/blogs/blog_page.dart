import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toastification/toastification.dart';
import 'package:toeic_desktop/app.dart';
import 'package:toeic_desktop/data/models/enums/load_status.dart';
import 'package:toeic_desktop/language/generated/l10n.dart';
import 'package:toeic_desktop/ui/common/app_colors.dart';
import 'package:toeic_desktop/ui/common/widgets/loading_circle.dart';
import 'package:toeic_desktop/ui/common/widgets/show_toast.dart';
import 'package:toeic_desktop/ui/page/blogs/blog_cubit.dart';
import 'package:toeic_desktop/ui/page/blogs/blog_state.dart';
import 'package:toeic_desktop/ui/page/blogs/widgets/blog_horizontal.dart';

class BlogPage extends StatelessWidget {
  const BlogPage({super.key, this.blogId});

  final String? blogId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => injector<BlogCubit>()..getBlog(blogId),
      child: const Page(),
    );
  }
}

class Page extends StatefulWidget {
  const Page({super.key});

  @override
  State<Page> createState() => _PageState();
}

class _PageState extends State<Page> {
  late final BlogCubit _cubit;
  Timer? _timer;
  @override
  void initState() {
    super.initState();
    _cubit = context.read<BlogCubit>();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocListener<BlogCubit, BlogState>(
      listener: (context, state) {
        if (state.loadStatus == LoadStatus.failure) {
          showToast(title: state.message, type: ToastificationType.error);
        }
      },
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              title: Text(
                S.current.blogs_title,
              ),
              floating: true,
              bottom: const PreferredSize(
                preferredSize: Size.fromHeight(1),
                child: Divider(
                  height: 1,
                  color: AppColors.gray2,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                height: 50,
                margin: const EdgeInsets.only(left: 16, right: 16, top: 16),
                child: TextField(
                  onChanged: (value) {
                    _timer?.cancel();
                    _timer = Timer(const Duration(milliseconds: 500), () {
                      _cubit.searchBlog(value);
                    });
                  },
                  decoration: InputDecoration(
                    hintText: S.current.search_blogs,
                    prefixIcon: const Icon(
                      Icons.search,
                      size: 18,
                    ),
                    filled: true,
                    isDense: true,
                    fillColor: theme.cardColor,
                    hintStyle: theme.textTheme.bodyMedium,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: AppColors.gray1,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
              sliver: BlocBuilder<BlogCubit, BlogState>(
                builder: (context, state) {
                  if (state.loadStatus == LoadStatus.loading) {
                    return const SliverFillRemaining(
                      hasScrollBody: false,
                      child: LoadingCircle(),
                    );
                  }
                  if (state.searchBlogs.isEmpty) {
                    return SliverToBoxAdapter(
                      child: Center(child: Text(S.current.no_data_found)),
                    );
                  }
                  return SliverList.separated(
                    separatorBuilder: (context, index) {
                      return const SizedBox(height: 12);
                    },
                    itemBuilder: (context, index) {
                      final blog = state.searchBlogs[index];
                      return BlogHorizontalCard(blog: blog);
                    },
                    itemCount: state.searchBlogs.length,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
