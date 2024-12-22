import 'package:clothes_app/screens/add_product_screen.dart';
import 'package:clothes_app/screens/clothes_screen.dart';
import 'package:clothes_app/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';


class Squelleton extends StatefulWidget {
  const Squelleton({super.key});

  @override
  _SquelletonState createState() => _SquelletonState();
}

class _SquelletonState extends State<Squelleton> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const ClothesScreen(),
    const AddProductScreen(),
    const ProfileScreen(),
  ];

  final List<String> _titles = [
    "Home",
    "Add Product",
    "Profile",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: Text(_titles[_currentIndex]),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 5,
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          backgroundColor: Colors.transparent,
          selectedItemColor: const Color(0xFF00396f),
          unselectedItemColor: const Color(0xFF00396f).withOpacity(0.5),
          currentIndex: _currentIndex,
          onTap: _onBottomNavTapped,
          items: [
            _buildNavItem(LucideIcons.home, "Home"),
            _buildNavItem(LucideIcons.plusCircle, "Add Product"),
            _buildNavItem(LucideIcons.user, "Profile"),
          ],
        ),
      ),
    );
  }

  void _onBottomNavTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  BottomNavigationBarItem _buildNavItem(IconData icon, String label) {
    return BottomNavigationBarItem(
      icon: Icon(icon, size: 18),
      label: label,
    );
  }
}
