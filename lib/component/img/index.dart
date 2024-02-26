import 'dart:math';

import 'package:flutter/material.dart';

class ImgPreview extends StatefulWidget {
  const ImgPreview({Key? key}) : super(key: key);

  @override
  State<ImgPreview> createState() => _ImgPreviewState();
}

class _ImgPreviewState extends State<ImgPreview> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
      //获取父级的宽高，并且取最小值，然后缩放图标
      double parentWidth = constraints.maxWidth;
      double parentHeight = constraints.maxHeight;
      double minValue = min(parentHeight, parentWidth);
      return Image.network(
        "https://taolive.top/api/pub_file/1/acg/12bd8028590195554fdad0d981acffda.png?size=1200",
        fit: BoxFit.cover,
        loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
          if (loadingProgress == null) {
            return AnimatedOpacity(
              opacity: 0.5,
              duration: Duration(milliseconds: 500),
              child: child,
            ); // 图像加载完成，显示原始图像
          } else {
            return Container(
              alignment: Alignment.center,
              color: Color.fromRGBO(0, 0, 0, 0.05),
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
            color: Color.fromRGBO(0, 0, 0, 0.05),
            child: Icon(
              Icons.image,
              size: minValue / 3,
              color: Color.fromRGBO(211, 209, 209, 1.0),
            ),
          );
        },
      );
    });
  }
}
