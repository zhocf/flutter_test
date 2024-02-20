import 'package:flutter/material.dart';

class ImageScanPage extends StatefulWidget {
  const ImageScanPage({Key? key}) : super(key: key);

  @override
  State<ImageScanPage> createState() => _ImageScanPageState();
}

class _ImageScanPageState extends State<ImageScanPage> {
  List<String> _imgList = [
    "https://taolive.top/api/pub_file/1/acg/a5f355bc733d96d850a5ae1170783e5a.png?size=1000",
    "https://taolive.top/api/pub_file/1/acg/c936a22451449bd03c4a0f9bd184746f.jpg?size=1000",
    "https://taolive.top/api/pub_file/1/acg/70ded6e1866aabbd89c84112a669ee90.png?size=1000",
    "https://taolive.top/api/pub_file/1/acg/e7c30e70038a0e89fb1817315a23c3f6.jpg?size=1000"
  ];

  int _current = 0;
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("图片预览"),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [buildShowBigImage(), buildScrollImge()],
        ),
      ),
    );
  }

  buildShowBigImage() {
    return Expanded(
      flex: 3,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        child: Container(
          key: UniqueKey(),
          height: double.infinity,
          width: MediaQuery.of(context).size.width,
          child: Image.network(
            _imgList[_current],
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  buildScrollImge() {
    return Expanded(
      flex: 1,
      child: Container(
        child: ListView.builder(
          itemCount: _imgList.length,
          scrollDirection: Axis.horizontal,
          controller: _scrollController,
          itemBuilder: (BuildContext context, int index) {
            return Align(
              alignment: Alignment.center,
              child: InkWell(
                onTap: () {
                  if (index > 1) {
                    // 向左滑动
                    _scrollController.animateTo(
                      140.0 * index,
                      duration: Duration(milliseconds: 200),
                      curve: Curves.linear,
                    );
                  } else if (index < _current) {
                    _scrollController.animateTo(
                      140.0 * (index - 1),
                      duration: Duration(milliseconds: 200),
                      curve: Curves.linear,
                    );
                  }
                  setState(() {
                    _current = index;
                  });
                },
                child: Container(
                  margin: EdgeInsets.only(left: 8, right: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(width: 4, color: _current == index ? Colors.redAccent : Colors.white),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      _imgList[index],
                      width: 140,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
