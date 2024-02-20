import 'dart:math';

import 'package:flutter/material.dart';

class SnowPage extends StatefulWidget {
  const SnowPage({Key? key}) : super(key: key);

  @override
  State<SnowPage> createState() => _SnowPageState();
}

class _SnowPageState extends State<SnowPage> with TickerProviderStateMixin {
  List<CustomPoint> _list = [];

  final Random _random = new Random();
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 4000),
      vsync: this,
    );
    _animationController.addListener(_animationListener);
    _animationController.repeat();
  }

  void _animationListener() {
    setState(() {});
  }

  //初始化
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    for (int i = 0; i < 150; i++) {
      CustomPoint point = CustomPoint();
      point.position = Offset(
        _random.nextDouble() * MediaQuery.of(context).size.width,
        _random.nextDouble() * MediaQuery.of(context).size.height,
      );
      // 随机大小
      point.radius = 3.0 * _random.nextDouble();
      point.origin = const Offset(0, 0);
      point.speet = _random.nextDouble();

      _list.add(point);
    }
  }

  @override
  void dispose() {
    _animationController.removeListener(_animationListener);
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/bg_snow.png',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: CustomPaint(
              size: MediaQuery.of(context).size,
              painter: SnowCustomMyPainter(list: _list),
            ),
          ),
        ],
      ),
    );
  }
}

class SnowCustomMyPainter extends CustomPainter {
  //创建画笔
  final Paint _paint = Paint()
    ..isAntiAlias = true
    ..color = Colors.white;

//  雪花数组
  List<CustomPoint> list = [];

  SnowCustomMyPainter({required this.list});

  @override
  void paint(Canvas canvas, Size size) {
    list.forEach((element) {
      double x = element.position.dx;
      double y = element.position.dy;

      //重置
      if (y >= size.height) {
        y = element.origin.dy;
      }

      element.position = Offset(x, y + element.speet);
    });

    for (var element in list) {
      canvas.drawCircle(element.position, element.radius, _paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class CustomPoint {
  //位置
  late Offset position;

  //初始化位置，移动后还原
  late Offset origin;

  //点的大小
  late double radius;

//  随机速度
  late double speet;
}
