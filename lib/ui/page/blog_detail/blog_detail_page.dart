import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:toastification/toastification.dart';
import 'package:toeic_desktop/data/models/entities/blog/blog.dart';
import 'package:toeic_desktop/language/generated/l10n.dart';
import 'package:toeic_desktop/ui/common/app_colors.dart';
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

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.blog.title?.trim() ?? ''),
        leading: const LeadingBackButton(
          isClose: true,
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(
            height: 1,
            color: AppColors.gray2,
          ),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: SelectionArea(
                child: HtmlWidget(
                  widget.blog.content ?? '',
                  onTapUrl: (url) {
                    _launchUrl(url);
                    return true;
                  },
                  enableCaching: true,
                  onLoadingBuilder: (context, element, loadingProgress) {
                    return const LoadingCircle();
                  },
                  customWidgetBuilder: (ele) {
                    if (ele.localName == 'img') {
                      final src = ele.attributes['src'];
                      return Image.network(
                        src ?? '',
                        fit: BoxFit.cover,
                      );
                    }
                    return null;
                  },
                  onErrorBuilder: (context, element, error) {
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ),
          )
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
