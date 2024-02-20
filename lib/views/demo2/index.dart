import 'package:flutter/material.dart';

class Demo2Page extends StatelessWidget {
  const Demo2Page({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverPersistentHeader(
              delegate: MySliverPersistentHeaderDelegate(),
              pinned: true,
            ),
          ];
        },
        body: ListView.builder(
          itemCount: 50,
          itemBuilder: (context, index) {
            return ListTile(title: Text('Item $index'));
          },
        ),
      ),
    );
  }
}

class MySliverPersistentHeaderDelegate extends SliverPersistentHeaderDelegate {
  @override
  double minExtent = 100;
  @override
  double maxExtent = 200;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.red,
      // child: Image.network(
      //   "https://taolive.top/api/pub_file/21/like/c1674211f0f2228b1ba4520707d6003f.jpg?size=500",
      //   fit: BoxFit.cover,
      // ),
    );
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
