import 'package:flutter/material.dart';
import 'package:gym_app/app/modules/dashboard/screens/dashboard_page.dart';
import 'package:gym_app/app/modules/gym_classes/screens/gym_classes_page.dart';
import 'package:gym_app/app/modules/membership/screens/membership_page.dart';
import 'package:gym_app/app/modules/profile/screens/profile_page.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    DashboardPage(),
    GymClassesPage(),
    MembershipPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center),
            label: 'Classes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.card_membership),
            label: 'Membership',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
