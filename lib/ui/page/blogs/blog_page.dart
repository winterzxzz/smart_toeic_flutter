import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:toastification/toastification.dart';
import 'package:toeic_desktop/app.dart';
import 'package:toeic_desktop/data/models/enums/load_status.dart';
import 'package:toeic_desktop/language/generated/l10n.dart';
import 'package:toeic_desktop/ui/common/app_context.dart';
import 'package:toeic_desktop/ui/common/widgets/loading_circle.dart';
import 'package:toeic_desktop/ui/common/widgets/no_data_found_widget.dart';
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
    final colorScheme = context.colorScheme;
    final theme = context.theme;
    final textTheme = theme.textTheme;
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
              floating: true,
              title: Text(
                S.current.blogs_title,
                style: textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              centerTitle: false,
            ),
            SliverPersistentHeader(
              pinned: true,
              delegate: _SearchBarDelegate(
                minHeight: 74.w,
                maxHeight: 74.w,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  child: Container(
                    height: 50.w,
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: TextField(
                      onChanged: (value) {
                        _timer?.cancel();
                        _timer = Timer(const Duration(milliseconds: 500), () {
                          _cubit.searchBlog(value);
                        });
                      },
                      decoration: InputDecoration(
                        hintText: S.current.search_blogs,
                        prefixIcon: Icon(
                          Icons.search,
                          size: 20,
                          color: theme.hintColor,
                        ),
                        filled: true,
                        fillColor: Colors.transparent,
                        isDense: true,
                        hintStyle: textTheme.bodyMedium?.copyWith(
                          color: theme.hintColor,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: colorScheme.primary,
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              sliver: BlocBuilder<BlogCubit, BlogState>(
                builder: (context, state) {
                  if (state.loadStatus == LoadStatus.loading) {
                    return const SliverFillRemaining(
                      hasScrollBody: false,
                      child: LoadingCircle(),
                    );
                  }
                  if (state.searchBlogs.isEmpty) {
                    return const SliverFillRemaining(
                      child: NotDataFoundWidget(),
                    );
                  }
                  return SliverList.separated(
                    separatorBuilder: (context, index) {
                      return const SizedBox(height: 16);
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
            const SliverToBoxAdapter(child: SizedBox(height: 32)),
          ],
        ),
      ),
    );
  }
}

class _SearchBarDelegate extends SliverPersistentHeaderDelegate {
  _SearchBarDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SearchBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
