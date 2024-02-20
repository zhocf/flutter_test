import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BannerPage extends StatefulWidget {
  const BannerPage({Key? key}) : super(key: key);

  @override
  State<BannerPage> createState() => _BannerPageState();
}

class _BannerPageState extends State<BannerPage> {
  List<String> imgList = [
    "https://api.mmbkz.cn/img/api-tengyuanheng.php",
    "https://mydiary.mmbkz.cn/usr/themes/MyDiary/resource/img/default/7.webp",
    "https://api.mmbkz.cn/img/api-tengyuanheng.php?2",
    "https://api.mmbkz.cn/img/api-tengyuanheng.php?4"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BannerWidget(
        imageList: imgList,
      ),
    );
  }
}

class BannerWidget extends StatefulWidget {
  final List<String> imageList;

  const BannerWidget({Key? key, required this.imageList}) : super(key: key);

  @override
  State<BannerWidget> createState() => _BannerWidgetState();
}

class _BannerWidgetState extends State<BannerWidget> {
  int _total = 0;
  int _current = 1;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _total = widget.imageList.length;
    _pageController = new PageController(
      initialPage: 5000,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: GestureDetector(
        child: buildStack(),
      ),
    );
  }

  Stack buildStack() {
    return Stack(
      children: [
        Positioned(
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (value) {
              setState(() {
                _current = value % widget.imageList.length +  1;
              });
            },
            itemBuilder: (BuildContext context, int index) {
              String url = widget.imageList[index % widget.imageList.length];
              return Image.network(
                url,
                fit: BoxFit.cover,
                headers: {},
              );
            },
          ),
        ),
        Positioned(
          right: 14,
          bottom: 14,
          child: buildContainer(),
        ),
      ],
    );
  }

  Container buildContainer() {
    return Container(
      alignment: Alignment.center,
      width: 50,
      height: 24,
      decoration: BoxDecoration(
          color: Colors.grey[200]?.withOpacity(0.5),
          //设置圆角
          borderRadius: BorderRadius.all(Radius.circular(12))),
      child: Text(
        "$_current/$_total",
        textAlign: TextAlign.center,
      ),
    );
  }
}
