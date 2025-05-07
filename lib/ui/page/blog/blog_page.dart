import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toastification/toastification.dart';
import 'package:toeic_desktop/app.dart';
import 'package:toeic_desktop/data/models/enums/load_status.dart';
import 'package:toeic_desktop/ui/common/widgets/show_toast.dart';
import 'package:toeic_desktop/ui/page/blog/blog_cubit.dart';
import 'package:toeic_desktop/ui/page/blog/blog_state.dart';
import 'package:toeic_desktop/ui/page/blog/widgets/list_view_blog_side.dart';

class BlogPage extends StatelessWidget {
  const BlogPage({super.key, this.blogId});

  final String? blogId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => injector<BlogCubit>()..getBlog(blogId),
      child: Page(),
    );
  }
}

class Page extends StatelessWidget {
  const Page({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<BlogCubit, BlogState>(
      listener: (context, state) {
        log('Current load status: ${state.loadStatus}');
        if (state.loadStatus == LoadStatus.failure) {
          showToast(title: state.message, type: ToastificationType.error);
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        body: ListViewBlog(),
      ),
    );
  }
}
