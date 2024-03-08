import 'dart:async';
import 'dart:math';
import 'package:flutte_test/views/pull/refresh_sliver.dart';
import 'package:flutter/cupertino.dart' as IOS;
import 'package:flutter/material.dart';

class PullDemo2 extends StatefulWidget {
  const PullDemo2({Key? key}) : super(key: key);

  @override
  State<PullDemo2> createState() => _PullDemo2State();
}

class _PullDemo2State extends State<PullDemo2> {
  final GlobalKey<CupertinoSliverRefreshControlState> sliverRefreshKey = GlobalKey<CupertinoSliverRefreshControlState>();

  ScrollController _scrollController = ScrollController();

  Future<void> onRefresh() async {
    await Future.delayed(Duration(seconds: 3));
    print('请求ok');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("可下拉列表2")),
      body: Container(
        child: NotificationListener(
          onNotification: (ScrollNotification notification) {
            sliverRefreshKey.currentState!.notifyScrollNotification(notification);
            return false;
          },
          child: CustomScrollView(
            controller: _scrollController,
            physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            slivers: <Widget>[
              CupertinoSliverRefreshControl(
                key: sliverRefreshKey,
                refreshIndicatorExtent: 100,
                refreshTriggerPullDistance: 140,
                onRefresh: onRefresh,
                builder: buildSimpleRefreshIndicator,
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
      ),
    );
  }
}

Widget buildSimpleRefreshIndicator(
  BuildContext context,
  RefreshIndicatorMode? refreshState,
  double pulledExtent,
  double refreshTriggerPullDistance,
  double refreshIndicatorExtent,
) {
  const Curve opacityCurve = Interval(0.4, 0.8, curve: Curves.easeInOut);
  return Align(
    alignment: Alignment.bottomCenter,
    child: Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: refreshState != RefreshIndicatorMode.refresh
          ? Opacity(
              opacity: opacityCurve.transform(min(pulledExtent / refreshTriggerPullDistance, 1.0)),
              child: const Icon(
                IOS.CupertinoIcons.down_arrow,
                color: IOS.CupertinoColors.inactiveGray,
                size: 36.0,
              ),
            )
          : Opacity(
              opacity: opacityCurve.transform(min(pulledExtent / refreshIndicatorExtent, 1.0)),
              child: const IOS.CupertinoActivityIndicator(radius: 14.0),
            ),
    ),
  );
}
