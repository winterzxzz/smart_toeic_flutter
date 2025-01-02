import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:toeic_desktop/data/models/enums/load_status.dart';
import 'package:toeic_desktop/ui/common/app_colors.dart';
import 'package:toeic_desktop/ui/page/blog/blog_cubit.dart';
import 'package:toeic_desktop/ui/page/blog/blog_state.dart';
import 'package:toeic_desktop/ui/page/blog/widgets/blog_item_card.dart';

class ListViewBlog extends StatefulWidget {
  const ListViewBlog({
    super.key,
  });

  @override
  State<ListViewBlog> createState() => _ListViewBlogState();
}

class _ListViewBlogState extends State<ListViewBlog> {
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BlogCubit, BlogState>(
      builder: (context, state) {
        return SizedBox(
          width: MediaQuery.of(context).size.width * 0.32,
          child: Column(
            children: [
              const SizedBox(height: 16),
              // Search TextField
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    const FaIcon(FontAwesomeIcons.blogger),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        onChanged: (value) {
                          _debounce?.cancel();
                          _debounce =
                              Timer(const Duration(milliseconds: 500), () {
                            context.read<BlogCubit>().searchBlog(value);
                          });
                        },
                        decoration: InputDecoration(
                          hintText: 'Search blogs...',
                          prefixIcon: const Icon(Icons.search),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(color: AppColors.gray1),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide:
                                BorderSide(color: AppColors.focusBorder),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // ListView
              Expanded(
                child: state.loadStatus == LoadStatus.loading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        itemCount: state.searchBlogs.length,
                        itemBuilder: (context, index) {
                          final blog = state.searchBlogs[index];
                          return BlogItemCard(blog: blog);
                        },
                        separatorBuilder: (context, index) {
                          return const SizedBox(height: 12);
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}
