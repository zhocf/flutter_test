import 'dart:io';

import 'package:flutter/material.dart';

class ImgPreviewModal extends StatelessWidget {
  String url;
  bool type; //true为网图，false为缓存
  ImgPreviewModal({Key? key, required this.url, required this.type}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        color: Colors.black,
        child: Hero(tag: 'img', child: type ? Image.network(url, fit: BoxFit.cover) : Image.file(File(url))),
      ),
    );
  }
}
