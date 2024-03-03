import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutte_test/component/img/imgLoading.dart';
import 'package:flutter/material.dart';

import 'cache_file_image.dart';

class ImgPreview extends StatefulWidget {
  String url;

  ImgPreview({Key? key, required this.url}) : super(key: key);

  @override
  State<ImgPreview> createState() => _ImgPreviewState();
}

class _ImgPreviewState extends State<ImgPreview> with SingleTickerProviderStateMixin {
  late Animation<double> _animation;
  late AnimationController _animatedContainer;
  bool _isCache = false; //是否缓存
  String _cacheUrl = '';

  static final CacheFileImage _cacheFileImage = CacheFileImage();

  @override
  void initState() {
    super.initState();
    //判断缓存
    _setCacheStatus();
    _animatedContainer = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = Tween(begin: 0.0, end: 1.0).animate(_animatedContainer);
    _animation.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    _animatedContainer.dispose();
  }

  //判断有没有缓存
  Future<void> _setCacheStatus() async {
    final Uint8List? cacheBytes = await _cacheFileImage.getFileBytes(widget.url);
    if (cacheBytes != null) {
      String url = await _cacheFileImage.getCacheUrl(widget.url);
      print('有');
      _animatedContainer.forward();
      setState(() {
        _isCache = true;
        _cacheUrl = url;
      });
    } else {
      print('没有');
    }
  }

  static HttpClient get _httpClient {
    final HttpClient _sharedHttpClient = HttpClient()..autoUncompress = false;
    HttpClient? client;
    return client ?? _sharedHttpClient;
  }

  //请求并写入缓存
  Future<void> _getImageFile() async {
    final Uri resolved = Uri.base.resolve(widget.url);

    final HttpClientRequest request = await _httpClient.getUrl(resolved);
    final HttpClientResponse response = await request.close();

    if (response.statusCode == 200) {
      final List<int> bytes = await response.fold<List<int>>(<int>[], (List<int> bytes, List<int> chunk) {
        bytes.addAll(chunk);
        return bytes;
      });

      await _cacheFileImage.saveBytesFile(widget.url, bytes);
    } else {
      throw Exception('Failed to load image');
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        //获取父级的宽高，并且取最小值，然后缩放图标
        double parentWidth = constraints.maxWidth;
        double parentHeight = constraints.maxHeight;
        double minValue = min(parentHeight, parentWidth);
        return Container(
          width: parentWidth,
          color: Color.fromRGBO(120, 120, 120, 0.1),
          child: _isCache
              ? Opacity(
                  opacity: _animation.value,
                  child: Image.file(File(_cacheUrl)),
                )
              : Image.network(
                  widget.url,
                  fit: BoxFit.cover,
                  frameBuilder: (BuildContext context, Widget child, int? frame, bool wasSynchronouslyLoaded) {
                    if (wasSynchronouslyLoaded || frame != null) {
                      _animatedContainer.forward();
                      _getImageFile();
                      return Opacity(
                        opacity: _animation.value,
                        child: child,
                      ); // 图像加载完成，显示原始图像
                    } else {
                      return ImgLoading();
                    }
                  },
                  errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                    return Container(
                      alignment: Alignment.center,
                      color: Color.fromRGBO(225, 231, 241, 1),
                      child: Icon(
                        Icons.image,
                        size: minValue / 3,
                        color: Color.fromRGBO(211, 209, 209, 1.0),
                      ),
                    );
                  },
                ),
        );
      },
    );
  }
}
