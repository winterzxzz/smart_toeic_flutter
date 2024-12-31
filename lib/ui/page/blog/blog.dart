import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toastification/toastification.dart';
import 'package:toeic_desktop/app.dart';
import 'package:toeic_desktop/data/models/entities/blog/blog.dart';
import 'package:toeic_desktop/data/models/enums/load_status.dart';
import 'package:toeic_desktop/ui/common/app_colors.dart';
import 'package:toeic_desktop/ui/common/app_navigator.dart';
import 'package:toeic_desktop/ui/common/widgets/show_toast.dart';
import 'package:toeic_desktop/ui/page/blog/blog_cubit.dart';
import 'package:toeic_desktop/ui/page/blog/blog_state.dart';
import 'package:toeic_desktop/ui/page/blog/widgets/blog_item_card.dart';

class BlogPage extends StatelessWidget {
  const BlogPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => injector<BlogCubit>()..getBlog(),
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
    final navigator = AppNavigator(context: context);
    return BlocConsumer<BlogCubit, BlogState>(
      listener: (context, state) {
        if (state.loadStatus == LoadStatus.loading) {
          navigator.showLoadingOverlay();
        } else {
          navigator.hideLoadingOverlay();
          if (state.loadStatus == LoadStatus.failure) {
            showToast(title: state.message, type: ToastificationType.error);
          }
        }
      },
      builder: (context, state) {
        if (state.loadStatus != LoadStatus.success) {
          return const SizedBox.shrink();
        }
        return Scaffold(
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          body: Row(
            children: [
              ListViewBlog(blogs: state.blogs),
              Expanded(
                child: Container(
                  color: Colors.blue,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class ListViewBlog extends StatefulWidget {
  const ListViewBlog({
    super.key,
    required this.blogs,
  });

  final List<Blog> blogs;

  @override
  State<ListViewBlog> createState() => _ListViewBlogState();
}

class _ListViewBlogState extends State<ListViewBlog> {
  final _searchController = TextEditingController();
  List<Blog> _filteredBlogs = [];

  @override
  void initState() {
    super.initState();
    _filteredBlogs = widget.blogs;
  }


  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    setState(() {
      _filteredBlogs = widget.blogs.where((blog) {
        final titleMatch = blog.title?.toLowerCase().contains(query.toLowerCase()) ?? false;
        final descriptionMatch = blog.description?.toLowerCase().contains(query.toLowerCase()) ?? false;
        return titleMatch || descriptionMatch;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.32,
      child: Column(
        children: [
          // Search TextField
          TextField(
            controller: _searchController,
            onChanged: _onSearchChanged,
            decoration: InputDecoration(
              hintText: 'Search blogs...',
              prefixIcon: const Icon(Icons.search),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16),
                      ),
                      borderSide: BorderSide(color: AppColors.inputBorder),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16),
                      ),
                      borderSide: BorderSide(color: AppColors.focusBorder ),
                    ),
            ),
          ),
          // ListView
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16) ,
              itemCount: _filteredBlogs.length,
              itemBuilder: (context, index) {
                final blog = _filteredBlogs[index];
                return BlogItemCard(blog: blog);
              },
            ),
          ),
        ],
      ),
    );
  }
}
