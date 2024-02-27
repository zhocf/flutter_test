import 'dart:math';

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
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _animation = Tween(begin: 0.0, end: 1.0).animate(_animatedContainer);
    _animation.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
      //获取父级的宽高，并且取最小值，然后缩放图标
      double parentWidth = constraints.maxWidth;
      double parentHeight = constraints.maxHeight;
      double minValue = min(parentHeight, parentWidth);
      return Container(
        color: Color.fromRGBO(225, 231, 241, 1),
        child: Image.network(
          "https://taolive.top/api/pub_file/1/acg/12bd8028590195554fdad0d981acffda.png?size=1500",
          fit: BoxFit.cover,
          loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
            if (loadingProgress == null) {
              _animatedContainer.forward();
              return Opacity(
                opacity: _animation.value,
                child: child,
              ); // 图像加载完成，显示原始图像
            } else {
              return Container(
                alignment: Alignment.center,
                color: Color.fromRGBO(225, 231, 241, 1),
                child: SizedBox(
                  width: minValue / 3,
                  height: minValue / 3,
                  child: CircularProgressIndicator(
                    value: 0.5,
                  ),
                ),
              );
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
