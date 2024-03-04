import 'package:flutter/material.dart';
import 'dart:math';

class ImgLoadingPlaceholder extends StatefulWidget {
  const ImgLoadingPlaceholder({Key? key}) : super(key: key);

  @override
  State<ImgLoadingPlaceholder> createState() => _ImgLoadingPlaceholderState();
}

class _ImgLoadingPlaceholderState extends State<ImgLoadingPlaceholder> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double?> _yAnimation;
  late Animation<double?> _rotateAnimation;
  late Animation<double?> _scaleAnimation;
  late Animation<double?> _radiusAnimation;
  late Animation<double?> _shadowSizeAnimation;

  @override
  void initState() {
    super.initState();
    //创建容器
    _animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 500))
      ..addListener(() {
        setState(() {});
      });
    //控制y移动
    _yAnimation = TweenSequence<double?>([
      TweenSequenceItem(tween: Tween(begin: 0, end: 9), weight: 25),
      TweenSequenceItem(tween: Tween(begin: 9, end: 18), weight: 25),
      TweenSequenceItem(tween: Tween(begin: 18, end: 9), weight: 25),
      TweenSequenceItem(tween: Tween(begin: 9, end: 0), weight: 25),
    ]).animate(_animationController);
    //控制旋转
    _rotateAnimation = TweenSequence<double?>([
      TweenSequenceItem(tween: Tween(begin: 0, end: 22.5), weight: 25),
      TweenSequenceItem(tween: Tween(begin: 22.5, end: 45), weight: 25),
      TweenSequenceItem(tween: Tween(begin: 45, end: 67.5), weight: 25),
      TweenSequenceItem(tween: Tween(begin: 67.5, end: 90), weight: 25),
    ]).animate(_animationController);
    //缩放
    _scaleAnimation = TweenSequence<double?>([
      TweenSequenceItem(tween: Tween(begin: 1, end: 0.9), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 0.9, end: 1), weight: 1),
    ]).animate(_animationController);
    //圆角
    _radiusAnimation = TweenSequence<double?>([
      TweenSequenceItem(tween: Tween(begin: 0, end: 50), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 50, end: 0), weight: 1),
    ]).animate(_animationController);
    _animationController.repeat();
    //阴影
    _shadowSizeAnimation = TweenSequence<double?>([
      TweenSequenceItem(tween: Tween(begin: 1, end: 1.2), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 1.2, end: 1), weight: 1),
    ]).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
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
          alignment: Alignment.center,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                width: minValue / 3,
                height: 6,
                bottom: -minValue / 15,
                left: 0,
                child: Opacity(
                  opacity: 0.1,
                  child: Transform.scale(
                    scaleX: _shadowSizeAnimation.value ?? 1,
                    child: ClipOval(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Transform.scale(
                scaleY: _scaleAnimation.value ?? 1,
                child: Transform.translate(
                  offset: Offset(0, _yAnimation.value ?? 0),
                  child: Transform.rotate(
                    angle: (_rotateAnimation.value ?? 0) * pi / 180,
                    child: Container(
                      width: minValue / 3,
                      height: minValue / 3,
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(255, 111, 145, 1),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(3),
                          topRight: Radius.circular(3),
                          bottomLeft: Radius.circular(3),
                          bottomRight: Radius.circular(_radiusAnimation.value ?? 3),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
