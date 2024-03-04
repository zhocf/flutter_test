import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutte_test/component/img/img_loading_placeholder.dart';
import 'package:flutte_test/component/img/img_preview_modal.dart';
import 'package:flutte_test/route/index.dart';
import 'package:flutter/material.dart';

import 'cache_file_image.dart';

class ImgPreview extends StatefulWidget {
  String url;
  bool? preview = false;

  ImgPreview({Key? key, required this.url, this.preview}) : super(key: key);

  @override
  State<ImgPreview> createState() => _ImgPreviewState();
}

class _ImgPreviewState extends State<ImgPreview> with SingleTickerProviderStateMixin {
  late Animation<double> _animation;
  late AnimationController _animatedContainer;
  int loadingStatus = 0; //加载状态，0加载中，1网络图，2缓存
  String _cacheUrl = ''; //路径
  bool throt = true; //防抖

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
      setState(() {
        loadingStatus = 2;
        _cacheUrl = url;
      });
    } else {
      setState(() {
        loadingStatus = 1;
      });
      print('没有');
    }
  }

  //请求并写入缓存
  Future<void> _getImageFile() async {
    if (throt) {
      throt = false;
      print('触发');
      _animatedContainer.forward();
      Uri uri = Uri.parse(widget.url);
      HttpClient client = HttpClient();
      //发起请求
      HttpClientRequest request = await client.getUrl(uri);
      HttpClientResponse response = await request.close();
      if (response.statusCode == 200) {
        try {
          final List<int> bytes = await response.fold<List<int>>(<int>[], (List<int> bytes, List<int> chunk) {
            bytes.addAll(chunk);
            return bytes;
          });

          await _cacheFileImage.saveBytesFile(widget.url, bytes);
        } catch (e) {
          throw Exception('Failed to load image');
        }
      }
    }
  }

  //跳转大屏显示
  void _goPreview() {
    if (widget.preview == true) {
      bool type = loadingStatus == 1;
      String url = type ? widget.url : _cacheUrl;
      NavigatorUtils.push(
        context,
        ImgPreviewModal(
          url: url,
          type: type,
        ),
      );
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
        Widget child;
        if (loadingStatus == 1) {
          child = ImgNetwork(
            url: widget.url,
            minValue: minValue,
            load: _getImageFile,
            animation: _animation,
          );
        } else if (loadingStatus == 2) {
          child = Opacity(opacity: _animation.value, child: ImgFile(url: _cacheUrl));
          _animatedContainer.forward();
        } else {
          child = SizedBox();
        }
        return Container(
          width: parentWidth,
          color: Color.fromRGBO(120, 120, 120, 0.1),
          child: InkWell(
            onTap: _goPreview,
            child: Hero(tag: 'img', child: child),
          ),
        );
      },
    );
  }
}

class ImgNetwork extends StatelessWidget {
  String url;
  double minValue;
  final Future<void> Function() load;
  Animation animation;

  ImgNetwork({Key? key, required this.url, required this.minValue, required this.load, required this.animation}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.network(
      url,
      fit: BoxFit.cover,
      frameBuilder: (BuildContext context, Widget child, int? frame, bool wasSynchronouslyLoaded) {
        if (wasSynchronouslyLoaded || frame != null) {
          load();
          return Opacity(opacity: animation.value, child: child); // 图像加载完成，显示原始图像
        } else {
          return ImgLoadingPlaceholder();
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
    );
  }
}

class ImgFile extends StatelessWidget {
  String url;

  ImgFile({Key? key, required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.file(
      File(url),
      fit: BoxFit.cover,
    );
  }
}
