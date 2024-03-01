import 'dart:math';

import 'package:flutte_test/component/img/imgLoading.dart';
import 'package:flutter/material.dart';

class ImgPreview extends StatefulWidget {
  const ImgPreview({Key? key}) : super(key: key);

  @override
  State<ImgPreview> createState() => _ImgPreviewState();
}

class _ImgPreviewState extends State<ImgPreview> with SingleTickerProviderStateMixin {
  late Animation<double> _animation;
  late AnimationController _animatedContainer;

  @override
  void initState() {
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
      //获取父级的宽高，并且取最小值，然后缩放图标
      double parentWidth = constraints.maxWidth;
      double parentHeight = constraints.maxHeight;
      double minValue = min(parentHeight, parentWidth);
      return Container(
        width: parentWidth,
        child: Image.network(
          "https://taolive.top/api/pub_file/1/acg/90f2d5b604a17b3a915b8af713634335.png",
          fit: BoxFit.cover,
          frameBuilder: (BuildContext context, Widget child, int? frame, bool wasSynchronouslyLoaded) {
            if (wasSynchronouslyLoaded || frame != null) {
              _animatedContainer.forward();
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
    });
  }
}
