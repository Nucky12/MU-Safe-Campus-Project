import 'package:flutter/material.dart';

// --- Import หน้าทั้งหมดที่ใช้ในแถบเมนูด้านล่าง ---
import 'home_screen.dart';
import '../report/hazard_reporter_screen.dart';
import '../emergency/emergency_contact_screen.dart';
import '../achievement/score_achievement_screen.dart';
import '../profile/profile_screen.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _selectedIndex = 0;

  // นำหน้าที่เราสร้างเสร็จแล้วมาใส่ในลิสต์ให้ตรงกับเมนู
  final List<Widget> _pages = [
    const HomeScreen(),
    const EmergencyContactScreen(),   // เมนูที่ 2: เบอร์ฉุกเฉิน
    const ScoreAchievementScreen(),   // เมนูที่ 3: คะแนน/เหรียญรางวัล
    const ProfileScreen(),            // เมนูที่ 4: หน้า Profile ของเรา
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex], 
      
      // ปุ่มกล้องตรงกลาง (Hazard Reporter)
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        shape: const CircleBorder(side: BorderSide(color: Colors.grey, width: 2)),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const HazardReporterScreen()),
          );
        },
        child: const Icon(Icons.camera_alt_outlined, color: Colors.black, size: 30),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      
      // แถบเมนูด้านล่าง
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.home_outlined, 'หน้าแรก', 0),
              _buildNavItem(Icons.phone_outlined, 'Emergency', 1),
              const SizedBox(width: 40), // เว้นที่ว่างตรงกลางให้ปุ่มกล้อง
              _buildNavItem(Icons.star_outline, 'คะแนน', 2),
              _buildNavItem(Icons.person_outline, 'โปรไฟล์', 3),
            ],
          ),
        ),
      ),
    );
  }

  // ฟังก์ชันช่วยสร้างปุ่มเมนูด้านล่าง
  Widget _buildNavItem(IconData icon, String label, int index) {
    bool isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: isSelected ? const Color(0xFF1D0A45) : Colors.grey),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: isSelected ? const Color(0xFF1D0A45) : Colors.grey,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}