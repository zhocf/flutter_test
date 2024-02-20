import 'package:flutter/cupertino.dart';

class MyData with ChangeNotifier {
  int _count = 0;

  int get count => _count;

  void incrementCount() {
    _count++;
    notifyListeners(); // 通知依赖项状态变化
  }
}