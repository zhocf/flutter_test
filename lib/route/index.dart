import 'dart:async';

import 'package:flutte_test/views/home/index.dart';
import 'package:flutte_test/views/pull/pull_demo2.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

import '../views/banner/index.dart';
import '../views/imageScan/index.dart';
import '../views/img/index.dart';
import '../views/pull/pull_demo1.dart';
import '../views/snow/index.dart';
import '../views/testDemo/index.dart';

// 导出 _routes 变量
export 'package:go_router/go_router.dart';
export 'package:flutte_test/route/index.dart';

class RouteType {
  String path;
  Widget child;
  FutureOr<String?> Function(BuildContext, GoRouterState)? redirect;

  RouteType({required this.path, required this.child, this.redirect});
}

List<RouteType> _routeOptions = [
  RouteType(path: "/home", child: Home()),
  RouteType(path: "/banner", child: BannerPage()),
  RouteType(path: "/image_scan", child: ImageScanPage()),
  RouteType(path: "/snow", child: SnowPage()),
  RouteType(path: "/pull_list", child: PullDemo2()),
  RouteType(path: "/test", child: Demo2Page()),
  RouteType(path: "/img", child: ImgPage()),
];

List<RouteBase> routes = _routeOptions.map((item) {
  return GoRoute(
    path: item.path,
    redirect: (context, state) {
      if (item.redirect != null) {
        return item.redirect!(context, state);
      }
    },
    pageBuilder: (context, state) {
      return CustomTransitionPage(
        child: item.child,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;
          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);
          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
      );
    },
  );
}).toList();
