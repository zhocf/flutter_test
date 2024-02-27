import 'package:flutter/material.dart';

class Demo2Page extends StatefulWidget {
  const Demo2Page({Key? key}) : super(key: key);

  @override
  State<Demo2Page> createState() => _Demo2PageState();
}

class _Demo2PageState extends State<Demo2Page> with SingleTickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    animation = Tween(begin: 0.0, end: 1.0).animate(controller)
      ..addListener(() {
        setState(() {});
      });
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        children: [
          Opacity(
            opacity: animation?.value ?? 0,
            child: Container(
              width: screenSize.width,
              height: 300,
              color: Colors.red,
            ),
          ),
          ElevatedButton(
            onPressed: () {
              print('dsa');
            },
            child: Text('动画'),
          )
        ],
      ),
    );
  }
}
