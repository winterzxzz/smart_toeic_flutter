import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toastification/toastification.dart';
import 'package:toeic_desktop/app.dart';
import 'package:toeic_desktop/data/models/enums/load_status.dart';
import 'package:toeic_desktop/ui/common/app_colors.dart';
import 'package:toeic_desktop/ui/common/widgets/show_toast.dart';
import 'package:toeic_desktop/ui/page/blogs/blog_cubit.dart';
import 'package:toeic_desktop/ui/page/blogs/blog_state.dart';
import 'package:toeic_desktop/ui/page/blogs/widgets/blog_vertical.dart';

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

class Page extends StatelessWidget {
  const Page({super.key});

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
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  onChanged: (value) {
                    context.read<BlogCubit>().searchBlog(value);
                  },
                  decoration: InputDecoration(
                    hintText: 'Search blogs...',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Theme.of(context).cardColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
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
              Expanded(
                child: BlocBuilder<BlogCubit, BlogState>(
                  builder: (context, state) {
                    if (state.loadStatus == LoadStatus.loading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    return ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      itemCount: state.searchBlogs.length,
                      itemBuilder: (context, index) {
                        final blog = state.searchBlogs[index];
                        return BlogVerticalCard(blog: blog);
                      },
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 16),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
