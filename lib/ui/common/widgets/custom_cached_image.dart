import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:toeic_desktop/ui/common/widgets/loading_circle.dart';
import 'package:toeic_desktop/data/database/secure_storage_helper.dart';

class CustomCachedImage extends StatefulWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final Widget? placeholder;
  final Widget? errorWidget;

  const CustomCachedImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.placeholder,
    this.errorWidget,
  });

  @override
  State<CustomCachedImage> createState() => _CustomCachedImageState();
}

class _CustomCachedImageState extends State<CustomCachedImage> {
  String? _cookie;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCookie();
  }

  Future<void> _loadCookie() async {
    final cookie = await SecureStorageHelper.instance.getCookies();
    setState(() {
      _cookie = cookie;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return widget.placeholder ?? const LoadingCircle(size: 14);
    }

    final image = CachedNetworkImage(
      imageUrl: widget.imageUrl,
      httpHeaders: {
        HttpHeaders.cookieHeader: _cookie ?? '',
      },
      placeholder: (context, url) =>
          widget.placeholder ?? const LoadingCircle(size: 14),
      errorWidget: (context, url, error) =>
          widget.errorWidget ?? const Center(child: Icon(Icons.broken_image)),
      width: widget.width,
      height: widget.height,
      fit: widget.fit,
    );

    if (widget.borderRadius != null) {
      return ClipRRect(
        borderRadius: widget.borderRadius ?? BorderRadius.zero,
        child: image,
      );
    }

    return image;
  }
}
