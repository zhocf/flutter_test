import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PullDemo1 extends StatefulWidget {
  const PullDemo1({Key? key}) : super(key: key);

  @override
  State<PullDemo1> createState() => _PullDemo1State();
}

class _PullDemo1State extends State<PullDemo1> {
  ScrollController _scrollController = ScrollController();

  Future<void> onRefresh() async {
    await Future.delayed(Duration(seconds: 3));
    print('请求ok');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("可下拉列表")),
        body: Container(
          child: NotificationListener(
            onNotification: (notification) {
              return false;
            },
            child: CustomScrollView(
              controller: _scrollController,
              physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
              slivers: [
                CupertinoSliverRefreshControl(
                  refreshIndicatorExtent: 100,
                  refreshTriggerPullDistance: 140,
                  onRefresh: onRefresh,
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return ListTile(
                        title: Text('Item $index'),
                      );
                    },
                    childCount: 30,
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
