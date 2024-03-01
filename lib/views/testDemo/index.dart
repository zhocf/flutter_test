import 'package:flutte_test/component/img/imgLoading.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class Demo2Page extends StatefulWidget {
  const Demo2Page({Key? key}) : super(key: key);

  @override
  State<Demo2Page> createState() => _Demo2PageState();
}

class _Demo2PageState extends State<Demo2Page> with SingleTickerProviderStateMixin {

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        width: screenSize.width,
        height: 300,
        color: Color.fromRGBO(120, 120, 120, 0.1),
        alignment: Alignment.center,
        child: ImgLoading()
      ),
    );
  }
}
