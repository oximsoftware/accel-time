import 'dart:ffi';

import 'package:acceltime/Home/home.dart';

import 'package:flutter/material.dart';

class AcceltimeBottomNaviagation extends StatefulWidget {
  List<BottomNavigationBarItem>? menus;
  AcceltimeBottomNaviagation({
    Key? key,
    this.menus,
  }) : super(key: key);

  @override
  State<AcceltimeBottomNaviagation> createState() =>
      _AcceltimeBottomNaviagationState();
}

class _AcceltimeBottomNaviagationState
    extends State<AcceltimeBottomNaviagation> {
  List<BottomNavigationBarItem> menus = [];

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Home.selectedIndexNotifier,
      builder: (BuildContext cxt, int index, Widget? _) {
        return BottomNavigationBar(
            showUnselectedLabels: true,
            selectedItemColor: Colors.red,
            unselectedItemColor: Colors.grey,
            onTap: (newIndex) {
              Home.selectedIndexNotifier.value = newIndex;
            },
            currentIndex: index,
            items: widget.menus!);
      },
    );
  }
}
