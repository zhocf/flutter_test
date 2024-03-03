import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:crypto/crypto.dart';
import 'package:path_provider/path_provider.dart';

class CacheFileImage {
  //获取url字符串的md5
  static String getUrlMd5(String url) {
    var content = new Utf8Encoder().convert(url);
    var digest = md5.convert(content);
    return digest.toString();
  }

  //获取图片缓存目录
  Future<String> getCachePath() async {
    Directory dir = await getApplicationDocumentsDirectory();
    Directory cachePath = Directory("${dir.path}/imagecache/");
    //如果目录不存在，则创建
    if (!cachePath.existsSync()) {
      cachePath.createSync();
    }
    return cachePath.path;
  }

  //获取图片本地缓存路径
  Future<String> getCacheUrl(String url) async {
    String mkdirPath = await getCachePath();
    String md5name = getUrlMd5(url);
    return mkdirPath + md5name;
  }

  // 判断是否有对应图片缓存文件存在
  Future<Uint8List?> getFileBytes(String url) async {
    String cacheDirPath = await getCachePath();
    String urlMd5 = getUrlMd5(url);
    File file = File("$cacheDirPath/$urlMd5");
    if (file.existsSync()) {
      //如果存在，返回字节列表
      return await file.readAsBytes();
    }
    return null;
  }

  // 将下载的图片数据缓存到指定文件
  Future saveBytesFile(String url, List<int> bytes) async {
    String cacheDirPath = await getCachePath();
    String urlMd5 = getUrlMd5(url);
    File file = File("$cacheDirPath/$urlMd5");
    if (!file.existsSync()) {
      file.createSync();
      await file.writeAsBytes(bytes);
    }
  }
}
