import 'package:flutte_test/views/banner/index.dart';
import 'package:flutte_test/views/demo2/index.dart';
import 'package:flutte_test/views/home/index.dart';
import 'package:flutte_test/views/imageScan/index.dart';
import 'package:flutte_test/views/snow/index.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: Color.fromRGBO(239, 239, 239, 1.0),
        textTheme: const TextTheme(bodyMedium: TextStyle(fontFamily: "pingFang-bold", fontSize: 16)),
      ),
      initialRoute: "/home",
      routes: {
        "/home":(context) => const Home(),
        "/banner": (context) => const BannerPage(),
        "/image_scan": (content) => const ImageScanPage(),
        "/snow": (content) => const SnowPage(),
        "/polygon": (context) => const Demo2Page(),
      },
    ),
  );
}