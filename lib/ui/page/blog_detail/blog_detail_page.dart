import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:toastification/toastification.dart';
import 'package:toeic_desktop/data/models/entities/blog/blog.dart';
import 'package:toeic_desktop/ui/common/widgets/show_toast.dart';
import 'package:url_launcher/url_launcher.dart';

class BlogDetail extends StatelessWidget {
  final Blog blog;

  const BlogDetail({
    super.key,
    required this.blog,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(blog.title ?? ''),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Theme.of(context).appBarTheme.backgroundColor,
          padding: const EdgeInsets.all(16.0),
          child: SelectionArea(
            child: HtmlWidget(
              blog.content ?? '',
              onTapUrl: (url) {
                _launchUrl(url);
                return true;
              },
              enableCaching: true,
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
      ),
    );
  }

  void _launchUrl(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      showToast(
        title: 'Không thể mở URL',
        type: ToastificationType.error,
      );
    }
  }
}
