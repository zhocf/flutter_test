import 'dart:math';

import 'package:flutte_test/component/animatedTranslate/index.dart';
import 'package:flutter/material.dart';

import '../../utils/util.dart';

enum _RefreshIndicatorMode {
  drag, //开始拖动
  armed, // 拖到足够距离时，准备刷新
  refresh, // 运行刷新回调
  success, // 刷新完成状态
  canceled, // 取消状态
}

double _dragHeight = 50;

class PullRefresh extends StatefulWidget {
  List<Widget> children; //列表子元素
  ScrollController controller; //滚动控制器
  Future<void> Function() onRefresh; //刷新请求

  PullRefresh({Key? key, required this.children, required this.controller, required this.onRefresh});

  @override
  State<PullRefresh> createState() => _PullRefreshState();
}

//列表逻辑
class _PullRefreshState extends State<PullRefresh> {
  _RefreshIndicatorMode _mode = _RefreshIndicatorMode.canceled;
  double _dragOffset = 0; //滚动距离
  double startY = 0; //开始时的距离
  bool touch = false; //是否触摸
  //开始拖拽
  void _startDrag(PointerDownEvent details) {
    final Offset position = details.localPosition;
    startY = position.dy;
  }

  //拖拽中
  void _drag(PointerMoveEvent details) {
    if (widget.controller.position.pixels == 0 && _mode != _RefreshIndicatorMode.refresh) {
      final Offset position = details.localPosition;
      double clientY = position.dy;
      //弹性计算
      _dragOffset = (clientY - startY) / 4;
      _dragOffset = max(_dragOffset, 0);
      setState(() {
        _dragOffset = _dragOffset;
        //已拖拽到可以加载的距离了
        if (_dragOffset > 50) {
          _mode = _RefreshIndicatorMode.armed;
        } else if (_dragOffset > 0) {
          _mode = _RefreshIndicatorMode.drag;
        }
      });
    }
  }

  //拖拽结束
  void _stopDrag(PointerUpEvent detail) async {
    //当拖钩足够距离时
    if (_mode == _RefreshIndicatorMode.armed) {
      setState(() {
        _dragOffset = _dragHeight;
        _mode = _RefreshIndicatorMode.refresh;
      });
      await widget.onRefresh();
      setState(() {
        _mode = _RefreshIndicatorMode.success;
        _dragOffset = 0;
      });
    } else {
      setState(() {
        _dragOffset = 0;
        _mode = _RefreshIndicatorMode.canceled;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    //当为取消或者成功后，或者拖到足够距离并且放手时
    bool autoRebound = _mode == _RefreshIndicatorMode.canceled || _mode == _RefreshIndicatorMode.success || (_mode == _RefreshIndicatorMode.refresh);
    final screen = MediaQuery.of(context).size;
    return SizedBox(
      width: screen.width,
      height: screen.height,
      child: ClipRect(
        child: AnimatedTranslate(
          x: 0,
          y: _dragOffset,
          duration: autoRebound ? Duration(milliseconds: 300) : Duration(milliseconds: 0),
          child: Stack(
            children: [
              Listener(
                onPointerDown: _startDrag,
                onPointerMove: _drag,
                onPointerUp: _stopDrag,
                child: ScrollConfiguration(
                  behavior: GlScrollBehavior(),
                  child: ListView(
                    controller: widget.controller,
                    physics: autoRebound ? AlwaysScrollableScrollPhysics() : NeverScrollableScrollPhysics(),
                    children: [...List.generate(
                      30,
                          (index) => ListTile(title: Text("$index+$_mode+$_dragOffset")),
                    ),SmartRefresherFooter()],
                  ),
                ),
              ),
              Positioned(
                child: SmartRefresherHeader(
                  mode: _mode,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

//头部
class SmartRefresherHeader extends StatelessWidget {
  _RefreshIndicatorMode mode;

  SmartRefresherHeader({Key? key, required this.mode}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget getHeader() {
      String title = '';
      Widget icon = SizedBox();
      Color color = const Color.fromRGBO(123, 124, 124, 1.0);
      if (mode == _RefreshIndicatorMode.drag || mode == _RefreshIndicatorMode.canceled) {
        icon = Icon(
          Icons.arrow_downward,
          color: color,
        );
        title = '下拉可刷新';
      } else if (mode == _RefreshIndicatorMode.armed) {
        icon = Icon(
          Icons.arrow_upward,
          color: color,
        );
        title = '放开就刷新';
      } else if (mode == _RefreshIndicatorMode.refresh) {
        icon = const SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
          ),
        );
        title = '加载中';
      } else if (mode == _RefreshIndicatorMode.success) {
        icon = Icon(
          Icons.supervised_user_circle,
          color: color,
        );
        title = '加载完毕';
      }
      return Transform.translate(
        offset: Offset(0, -50),
        child: SizedBox(
          height: 50,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon,
              Container(
                margin: EdgeInsets.only(left: 10),
                child: Text(title, style: TextStyle(fontSize: 14, color: color)),
              ),
            ],
          ),
        ),
      );
    }

    return getHeader();
  }
}

//尾部
class SmartRefresherFooter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      alignment: Alignment.center,
      child: Text("加载中"),
    );
  }
}
