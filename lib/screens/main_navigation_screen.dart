import 'package:flutter/material.dart';

import 'components/main/main_bottom_nav_bar.dart';
import 'tabs/add_tab.dart';
import 'tabs/home_tab.dart';
import 'tabs/inventory_tab.dart';
import 'tabs/notification_tab.dart';
import 'tabs/profile_tab.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _screens = <Widget>[
    HomeTab(),
    InventoryTab(),
    AddTab(),
    NotificationTab(),
    ProfileTab(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens.elementAt(_selectedIndex),
      bottomNavigationBar: MainBottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
