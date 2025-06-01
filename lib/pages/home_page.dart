import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:travel_and_food/tabs/add_feed_tab.dart';
import 'package:travel_and_food/tabs/setting_tab.dart';

import '../tabs/home_tab.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late PersistentTabController _controller;

  List<PersistentBottomNavBarItem> _navBarItems() {
    return [
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.home, size: 28),
        inactiveIcon: const Icon(Icons.home_outlined, size: 28),
        title: "Feed",
        activeColorPrimary: Colors.black,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(
          Icons.add,
          size: 28,
          color: Colors.white,
        ),
        inactiveIcon: const Icon(
          Icons.add,
          size: 28,
          color: Colors.white,
        ),
        title: "เพิ่ม Feed",
        activeColorPrimary: Colors.black,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.settings, size: 28),
        inactiveIcon: const Icon(Icons.settings_outlined, size: 28),
        title: "การตั้งค่า",
        activeColorPrimary: Colors.black,
        inactiveColorPrimary: Colors.grey,
      ),
    ];
  }

  @override
  void initState() {
    super.initState();
    // เริ่มที่ index 0 (Feed)
    _controller = PersistentTabController(initialIndex: 0);
  }

  List<Widget> _buildScreens() {
    return [
      const HomeTab(),
      const AddFeedTab(),
      const SettingTab(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(context,
        controller: _controller,
        screens: _buildScreens(),
        items: _navBarItems(),
        backgroundColor: Colors.white,
        animationSettings: const NavBarAnimationSettings(
          navBarItemAnimation: ItemAnimationSettings(
            duration: Duration(milliseconds: 400),
            curve: Curves.ease,
          ),
          screenTransitionAnimation: ScreenTransitionAnimationSettings(
            animateTabTransition: true,
            duration: Duration(milliseconds: 200),
            screenTransitionAnimationType: ScreenTransitionAnimationType.slide,
          ),
        ),
        navBarStyle: NavBarStyle.style16);
  }
}
