import 'package:flutter/material.dart';

// 1. ตรวจสอบให้แน่ใจว่า Import path ตรงกับโฟลเดอร์ของคุณ
import 'screens/authorization/login_screen.dart';
import 'screens/dashboard/main_layout.dart';

void main() {
  runApp(const MuSafeCampusApp());
}

class MuSafeCampusApp extends StatelessWidget {
  const MuSafeCampusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MU Safe Campus',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF1D0A45),
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1D0A45),
          foregroundColor: Color(0xFFFFD700), 
          centerTitle: true,
          elevation: 0,
        ),
      ),
      // 2. กำหนดหน้าแรกเมื่อเปิดแอป
      initialRoute: '/login', 
      
      // 3. ทะเบียนเส้นทาง (Routes) ทั้งหมดของแอปอยู่ที่นี่
      routes: {
        '/login': (context) => const LoginScreen(),
        '/main': (context) => const MainLayout(), // ตรงนี้คือจุดที่ทำให้กดปุ่ม Login แล้วมาหน้าหลักได้ครับ
      },
    );
  }
}