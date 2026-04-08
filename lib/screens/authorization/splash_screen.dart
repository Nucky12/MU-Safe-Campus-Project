import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // หน่วงเวลา 2 วินาทีแล้วเปลี่ยนไปหน้า Login
    Future.delayed(const Duration(seconds: 2), () {
      // ใช้ pushReplacementNamed เพื่อไม่ให้ผู้ใช้กดย้อนกลับมาหน้าโหลดได้อีก
      Navigator.pushReplacementNamed(context, '/login');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1D0A45), // สีม่วงมหิดล
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // โลโก้แอป (อิงตามหน้า 12 ในเอกสาร Phase 1) [cite: 1753]
            // หากในอนาคตมีไฟล์รูปโลโก้ (โล่และกากบาท) สามารถนำคอมเมนต์ด้านล่างออกเพื่อใช้งานได้
            /*
            Image.asset(
              'assets/logo.png',
              height: 120,
            ),
            */
            // ใช้ Icon รูปโล่ด้านสุขภาพแทนชั่วคราว
            const Icon(Icons.health_and_safety, size: 100, color: Color(0xFFFFD700)),
            
            const SizedBox(height: 16),
            
            const Text(
              'MU SAFE CAMPUS',
              style: TextStyle(
                color: Color(0xFFFFD700), // สีเหลืองทอง
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            
            const SizedBox(height: 60),
            
            // วงกลม Loading [cite: 1755]
            const CircularProgressIndicator(
              color: Colors.white,
            ),
            
            const SizedBox(height: 20),
            
            const Text(
              'Loading...',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}