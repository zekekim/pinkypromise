import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pinkypromise/main.dart';

import 'widgets/custom_tab_bar.dart';

class NavScreen extends StatefulWidget {
  const NavScreen({Key? key}) : super(key: key);

  @override
  _NavScreenState createState() => _NavScreenState();
}

class _NavScreenState extends State<NavScreen> {
  final List<Widget> _screens = [
    FriendsPage(),
    Scaffold(),
  ];

  final List<IconData> _icons = const [
    Icons.people,
    Icons.edit,
  ];
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _icons.length,
      child: Scaffold(
        body: _screens[_selectedIndex],
        bottomNavigationBar: Container(
          color: Colors.orange[50],
          child: Padding(
            padding: Platform.isIOS
                ? const EdgeInsets.only(bottom: 12.0)
                : const EdgeInsets.all(0.0),
            child: CustomTabBar(
              icons: _icons,
              selectedIndex: _selectedIndex,
              onTap: (index) => setState(() => _selectedIndex = index),
            ),
          ),
        ),
      ),
    );
  }
}
