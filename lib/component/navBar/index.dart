import 'package:flutter/material.dart';

class NavBar extends StatelessWidget {
  //左边菜单点击事件
  // final VoidCallback? onMenuPressed;
  final Widget? rightMenu;
  final String title;

  const NavBar({Key? key,  required this.title, this.rightMenu}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 20,fontFamily: "pingFang-bold")),
          Container(
            child: rightMenu,
          ),
        ],
      ),
    );
  }
}
