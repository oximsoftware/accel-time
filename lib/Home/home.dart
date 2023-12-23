import 'dart:ui';

import 'package:acceltime/Home/bottom_navigation.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  List<BottomNavigationBarItem>? menus;
  List<Widget>? pages;
  Home({Key? key, required this.menus, required this.pages}) : super(key: key);
  static ValueNotifier<int> selectedIndexNotifier = ValueNotifier(0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      bottomNavigationBar: AcceltimeBottomNaviagation(menus: menus!),
      body: Stack(
        children: [
          ValueListenableBuilder(
            valueListenable: selectedIndexNotifier,
            builder: (BuildContext context, int updatedIndex, child) {
              return pages![updatedIndex];
            },
          ),
        ],
      ),
    );
  }
}
