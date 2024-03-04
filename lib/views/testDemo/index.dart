
import 'package:flutte_test/component/img/index.dart';
import 'package:flutter/material.dart';

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
        child: ImgPreview(
          url: "https://taolive.top/api/pub_file/1/acg/90f2d5b604a17b3a915b8af713634335.png",
          preview: true,
        ),
      ),
    );
  }
}
