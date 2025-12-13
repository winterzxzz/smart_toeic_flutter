import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:toastification/toastification.dart';
import 'package:toeic_desktop/data/models/entities/blog/blog.dart';
import 'package:toeic_desktop/language/generated/l10n.dart';
import 'package:toeic_desktop/ui/common/app_colors.dart';
import 'package:toeic_desktop/ui/common/app_context.dart';
import 'package:toeic_desktop/ui/common/app_images.dart';
import 'package:toeic_desktop/ui/common/widgets/leading_back_button.dart';
import 'package:toeic_desktop/ui/common/widgets/loading_circle.dart';
import 'package:toeic_desktop/ui/common/widgets/show_toast.dart';
import 'package:url_launcher/url_launcher.dart';

class BlogDetail extends StatefulWidget {
  final Blog blog;

  const BlogDetail({
    super.key,
    required this.blog,
  });

  @override
  State<BlogDetail> createState() => _BlogDetailState();
}

class _BlogDetailState extends State<BlogDetail> {
  late ScrollController _scrollController;
  bool _showAppBarTitle = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    // 200.w is the expanded height, kToolbarHeight is usually 56
    // We want to show the title when the expanded header is collapsed.
    // The exact threshold can be tweaked.
    if (_scrollController.hasClients && _scrollController.offset > (140.w)) {
      if (!_showAppBarTitle) {
        setState(() {
          _showAppBarTitle = true;
        });
      }
    } else {
      if (_showAppBarTitle) {
        setState(() {
          _showAppBarTitle = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    final colorScheme = context.colorScheme;
    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 200.w,
            leading: const LeadingBackButton(
              isClose: true,
              color: Colors.white,
            ),
            automaticallyImplyLeading: false,
            backgroundColor: colorScheme.primary,
            title: _showAppBarTitle
                ? Text(
                    widget.blog.title?.trim() ?? '',
                    style: textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : null,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  CachedNetworkImage(
                    imageUrl: widget.blog.image ?? '',
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Image.asset(
                      AppImages.bgImagePlaceholder,
                      fit: BoxFit.cover,
                    ),
                    errorWidget: (context, url, error) => Image.asset(
                      AppImages.bgImagePlaceholder,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.4),
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.6),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.blog.category != null)
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 6.w,
                      ),
                      margin: EdgeInsets.only(bottom: 12.w),
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Text(
                        widget.blog.category!,
                        style: textTheme.labelMedium?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  Text(
                    widget.blog.title?.trim() ?? '',
                    style: textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                    ),
                  ),
                  SizedBox(height: 16.w),
                  Divider(color: AppColors.gray2.withValues(alpha: 0.5)),
                  SizedBox(height: 16.w),
                  SelectionArea(
                    child: HtmlWidget(
                      widget.blog.content ?? '',
                      textStyle: textTheme.bodyMedium?.copyWith(
                        height: 1.6,
                        fontSize: 16.sp,
                      ),
                      onTapUrl: (url) {
                        _launchUrl(url);
                        return true;
                      },
                      enableCaching: true,
                      onLoadingBuilder: (context, element, loadingProgress) {
                        return const Center(child: LoadingCircle());
                      },
                      customWidgetBuilder: (ele) {
                        if (ele.localName == 'img') {
                          final src = ele.attributes['src'];
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(12.r),
                            child: CachedNetworkImage(
                              imageUrl: src ?? '',
                              fit: BoxFit.cover,
                              width: double.infinity,
                              placeholder: (context, url) => const Center(
                                child: LoadingCircle(),
                              ),
                              errorWidget: (context, url, error) =>
                                  const SizedBox.shrink(),
                            ),
                          );
                        }
                        return null;
                      },
                      onErrorBuilder: (context, element, error) {
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                  SizedBox(height: 32.w),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _launchUrl(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      showToast(
        title: S.current.cannot_open_url,
        type: ToastificationType.error,
      );
    }
  }
}
