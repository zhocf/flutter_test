import 'package:flutte_test/component/img/index.dart';
import 'package:flutter/material.dart';

class Demo2Page extends StatefulWidget {
  const Demo2Page({Key? key}) : super(key: key);

  @override
  State<Demo2Page> createState() => _Demo2PageState();
}

class _Demo2PageState extends State<Demo2Page> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late double _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 350),
      lowerBound: 0.0,
      upperBound: 0.1,
    )..addListener(() {
        setState(() {});
      });
  }

  void _tapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _tapUp(TapUpDetails details) {
    _controller.reverse();
    print('ds');
    showModalBottomSheet(
      context: context,
      enableDrag: false,
      builder: (BuildContext context) {
        return Container(
          height: 200,
          color: Colors.white,
          child: Center(
            child: Text('This is a modal bottom sheet'),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    _scale = 1 - _controller.value;
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: GestureDetector(
          onTapDown: _tapDown,
          onTapUp: _tapUp,
          child: Transform.scale(
            scale: _scale,
            child: Container(
              color: Colors.blue,
              width: screenSize.width,
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Text(
                '点击',
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
