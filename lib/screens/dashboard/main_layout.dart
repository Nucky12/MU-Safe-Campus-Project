import 'package:flutter/material.dart';
import 'home_screen.dart';
import '../report/hazard_reporter_screen.dart';
// import หน้าอื่นๆ เช่น safety_map.dart, profile.dart เข้ามาที่นี่

class MainLayout extends StatefulWidget {
  const MainLayout({Key? key}) : super(key: key);

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomeScreen(),
    const Center(child: Text('Emergency Page')), // Placeholder
    const Center(child: Text('Scores Page')), // Placeholder
    const Center(child: Text('Profile Page')), // Placeholder
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      // ปุ่มกล้องตรงกลาง (Hazard Reporter)
     
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const HazardReporterScreen()),
          );
        },
        shape: const CircleBorder(side: BorderSide(color: Colors.grey, width: 2)),
        child: const Icon(Icons.camera_alt_outlined, color: Colors.black, size: 30),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              _buildNavItem(Icons.home_outlined, 'หน้าแรก', 0),
              _buildNavItem(Icons.phone_outlined, 'Emergency', 1),
              const SizedBox(width: 40), // เว้นที่ให้ปุ่มกล้อง
              _buildNavItem(Icons.star_border, 'คะแนนของคุณ', 2),
              _buildNavItem(Icons.person_outline, 'โปรไฟล์', 3),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    return InkWell(
      onTap: () => _onItemTapped(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: _selectedIndex == index ? const Color(0xFF1D0A45) : Colors.black,
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: _selectedIndex == index ? const Color(0xFF1D0A45) : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}