import 'dart:async';

import 'package:flutte_test/component/refresher/pull_refresh.dart';
import 'package:flutter/material.dart';

class PullPage extends StatefulWidget {
  const PullPage({Key? key}) : super(key: key);

  @override
  State<PullPage> createState() => _PullPageState();
}

class _PullPageState extends State<PullPage> {
  ScrollController _scrollController = ScrollController();

  Future<void> _getData() async {
    await Future.delayed(Duration(seconds: 10));
    print('请求ok');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("可下拉列表")),
      body: Column(
        children: [
          Container(
            color: Color.fromRGBO(71, 133, 213, 0.5),
            height: 150,
            alignment: Alignment.center,
            width: double.infinity,
            child: Text('测试banner'),
          ),
          Expanded(
            child: PullRefresh(
              controller: _scrollController,
              onRefresh: _getData,
              children: List.generate(
                30,
                (index) => ListTile(title: Text(index.toString())),
              ),
            ),
          )
        ],
      ),
    );
  }
}
