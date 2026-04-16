import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// นำเข้าหน้าจอต่างๆ
import 'screens/authorization/splash_screen.dart'; // <--- เพิ่มบรรทัดนี้
import 'screens/authorization/login_screen.dart';
import 'screens/dashboard/main_layout.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); 
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
      // 1. เปลี่ยนหน้าแรกจาก /login เป็น /splash
      initialRoute: '/splash', 
      
      routes: {
        // 2. เพิ่ม Route สำหรับหน้าโหลด
        '/splash': (context) => const SplashScreen(), 
        '/login': (context) => const LoginScreen(),
        '/main': (context) => const MainLayout(),
      },
    );
  }
}