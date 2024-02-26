import 'package:flutte_test/component/img/index.dart';
import 'package:flutter/material.dart';

class ImgPage extends StatefulWidget {
  const ImgPage({Key? key}) : super(key: key);

  @override
  State<ImgPage> createState() => _ImgPageState();
}

class _ImgPageState extends State<ImgPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('图片加载'),
      ),
      backgroundColor: Colors.white,
      body: Container(
        height: 300,
        child: ImgPreview(),
      ),
    );
  }
}
