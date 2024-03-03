import 'dart:io';

import 'package:flutte_test/component/img/index.dart';
import 'package:flutter/material.dart';

import '../../component/img/cache_file_image.dart';

class ImgPage extends StatefulWidget {
  const ImgPage({Key? key}) : super(key: key);

  @override
  State<ImgPage> createState() => _ImgPageState();
}

class _ImgPageState extends State<ImgPage> {
  static final CacheFileImage _cacheFileImage = CacheFileImage();

  void clear() async {
    String path = await _cacheFileImage.getCachePath();
    Directory directory = Directory(path);
    // 检查目录是否存在
    if (await directory.exists()) {
      // 获取目录下的所有文件和目录
      List<FileSystemEntity> entities = await directory.list().toList();

      // 遍历所有文件和目录，并删除
      for (FileSystemEntity entity in entities) {
        if (entity is File) {
          print(entity);
          await entity.delete();
        } else if (entity is Directory) {
          await entity.delete(recursive: true);
        }
      }
      print('清除ok');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('图片加载'),
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            height: 300,
            child: ImgPreview(
              url: "https://taolive.top/api/pub_file/1/acg/90f2d5b604a17b3a915b8af713634335.png",
            ),
          ),
          ElevatedButton(onPressed: clear, child: Text("清除缓存"))
        ],
      ),
    );
  }
}
