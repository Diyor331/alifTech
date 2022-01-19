import 'dart:async';

import 'package:aliftech_test/ui/screens/screens.dart';
import 'package:aliftech_test/ui/styles/styles.dart';
import 'package:flutter/material.dart';

class BottomNavigation extends StatefulWidget {
  final currentNav;
  ValueChanged<int>? onTap;

  BottomNavigation({Key? key, this.currentNav,this.onTap}) : super(key: key);

  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      showSelectedLabels: true,
      showUnselectedLabels: false,
      type: BottomNavigationBarType.fixed,
      elevation: 0.0,
      currentIndex: widget.currentNav,
      backgroundColor: primaryColor,
      selectedItemColor: const Color(0xffE5E5E5),
      unselectedItemColor: Colors.white,
      selectedFontSize: 14,
      unselectedFontSize: 14,
      onTap: widget.onTap,
      items: const [
        BottomNavigationBarItem(
          label: 'Все',
          // icon: Image.asset('images/bottom_nav/main.png'),
          icon: Icon(
            Icons.format_list_bulleted,
          ),
        ),
        BottomNavigationBarItem(
          label: 'В прогрессе',
          // icon: Image.asset('images/bottom_nav/main.png'),
          icon: Icon(Icons.check),
        ),
        BottomNavigationBarItem(
          label: 'Завершенные',
          // icon: Image.asset('images/bottom_nav/main.png'),
          icon: Icon(Icons.crop_square_outlined),
        ),
      ],
    );
  }
}
