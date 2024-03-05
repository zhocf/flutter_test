import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 屏幕尺寸
    final screenSize = MediaQuery.of(context).size;
    //数据
    List<ListType> listData = [
      ListType(name: '测试', path: "/test"),
      ListType(name: '雪花', path: '/snow'),
      ListType(name: '轮播图', path: '/banner'),
      ListType(name: '大图预览', path: '/image_scan'),
      ListType(name: '下拉列表', path: '/pull_list'),
      ListType(name: '图片加载组件', path: "/img"),
    ];

    void hrefPage(String path) {
      context.push(path);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("首页导航"),
      ),
      body: Container(
          width: screenSize.width,
          height: screenSize.height,
          child: ScrollConfiguration(
            behavior: GlScrollBehavior(),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                children: listData.map((item) {
                  return InkWell(
                    onTap: () {
                      hrefPage(item.path);
                    },
                    child: Container(
                      width: screenSize.width,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        boxShadow: [BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.2), blurRadius: 5, offset: Offset(0, 2))],
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 13),
                      margin: EdgeInsets.only(bottom: 20),
                      child: Text(item.name),
                    ),
                  );
                }).toList(),
              ),
            ),
          )),
    );
  }
}

class ListType {
  final String name;
  final String path;

  ListType({required this.name, required this.path});
}

class GlScrollBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}
