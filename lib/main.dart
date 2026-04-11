import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // <--- 1. เพิ่ม Import สำหรับ Firebase
import 'firebase_options.dart'; // <--- 2. เพิ่ม Import สำหรับไฟล์ตั้งค่า Firebase

// ตรวจสอบให้แน่ใจว่า Import path ตรงกับโฟลเดอร์ของคุณ
import 'screens/authorization/login_screen.dart';
import 'screens/dashboard/main_layout.dart';

// 3. เปลี่ยนจาก void main() ธรรมดา เป็น void main() async
void main() async {
  // 4. ต้องมีบรรทัดนี้เพื่อให้ Flutter เตรียมความพร้อมก่อนรัน Firebase
  WidgetsFlutterBinding.ensureInitialized(); 
  
  // 5. เริ่มต้นการเชื่อมต่อ Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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
      // กำหนดหน้าแรกเมื่อเปิดแอป
      initialRoute: '/login', 
      
      // ทะเบียนเส้นทาง (Routes) ทั้งหมดของแอปอยู่ที่นี่
      routes: {
        '/login': (context) => const LoginScreen(),
        '/main': (context) => const MainLayout(), // ตรงนี้คือจุดที่ทำให้กดปุ่ม Login แล้วมาหน้าหลัก
      },
    );
  }
}