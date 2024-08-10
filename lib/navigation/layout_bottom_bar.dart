import 'package:flutter/material.dart';
import 'package:flutter1/menu/menu1.dart';
import 'package:flutter1/menu/menu2.dart';
import 'package:flutter1/menu/menu3.dart';
import 'package:flutter1/menu/menu4.dart';
import 'package:flutter1/menu/menu5.dart';

class LayoutBottomBar extends StatefulWidget {
  const LayoutBottomBar({super.key});
  @override
  State<LayoutBottomBar> createState() => _LayoutBottomBarState();
}

class _LayoutBottomBarState extends State<LayoutBottomBar> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    const Menu1(),
    const Menu2(),
    const Menu3(),
    const Menu4(),
    const Menu5()
  ];

  void onBarTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: _children[_currentIndex],
        bottomNavigationBar: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(30),
              topLeft: Radius.circular(30),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black38,
                spreadRadius: 0,
                blurRadius: 10,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30.0),
              topRight: Radius.circular(30.0),
            ),
            child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              backgroundColor: const Color(0xFFDBA688),
              currentIndex: _currentIndex,
              onTap: (index) {
                onBarTapped(index);
              },
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.point_of_sale),
                  label: 'Point of Sale',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.menu_book_rounded),
                  label: 'Menu',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.people_alt_sharp),
                  label: 'Staff',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.dashboard_rounded),
                  label: 'Dashboard',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.perm_contact_calendar_sharp),
                  label: 'Profile',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
