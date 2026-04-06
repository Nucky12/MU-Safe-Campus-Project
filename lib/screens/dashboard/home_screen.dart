import 'package:flutter/material.dart';
import '../emergency/medical_id_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1D0A45), // สีม่วงมหิดล
        title: const Text(
          'MU SAFE CAMPUS',
          style: TextStyle(
            color: Color(0xFFFFD700), // สีเหลืองทอง
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          // ส่วนที่ 1: รูปภาพ Banner และเส้นคาดสีทอง
          Column(
            children: [
              // ถ้ายังไม่ได้เอารูปลงโฟลเดอร์ ระบบจะขึ้น Error สีแดงตรงนี้ตอนรัน
              // แนะนำให้ใส่ไฟล์รูปชื่อ banner.png ไว้ใน assets/ ก่อนนะครับ
              Image.asset(
                'assets/banner.png', 
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover, // ทำให้รูปขยายเต็มพื้นที่อย่างสวยงาม
              ),
              
              /* // ถ้ายังไม่มีไฟล์รูปภาพ ให้คอมเมนต์ Image.asset ด้านบน 
              // แล้วเอาคอมเมนต์ของ Container สีเทาด้านล่างนี้ออกเพื่อใช้แทนชั่วคราวครับ
              Container(
                height: 180,
                width: double.infinity,
                color: Colors.grey[300],
                child: const Center(child: Text('ใส่รูปภาพ Banner ตรงนี้')),
              ),
              */

              // เส้นสีเหลืองทองใต้รูปภาพ
              Container(
                height: 6,
                width: double.infinity,
                color: const Color(0xFFFFD700),
              ),
            ],
          ),
          
          // ส่วนที่ 2: เมนูหลัก 6 ปุ่ม (Grid View)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.count(
                crossAxisCount: 2, // แบ่งเป็น 2 คอลัมน์
                crossAxisSpacing: 16, // ระยะห่างแนวนอน
                mainAxisSpacing: 16, // ระยะห่างแนวตั้ง
                childAspectRatio: 1.4, // สัดส่วนของการ์ด (กว้างต่อสูง)
                children: [
                  // สังเกตว่ามีการส่ง context เข้าไปเป็นค่าแรกแล้ว
                  _buildMenuCard(context, Icons.location_on_outlined, 'Safety Map', Colors.blue),
                  _buildMenuCard(context, Icons.phone_in_talk_outlined, 'External Emergency\nContacts', Colors.red),
                  _buildMenuCard(context, Icons.medical_information_outlined, 'Digital Medical\nCard', Colors.green),
                  _buildMenuCard(context, Icons.history_outlined, 'My Reporting\nHistory', Colors.grey[800]!),
                  _buildMenuCard(context, Icons.lightbulb_outline, 'Safety\nFAQ & Tips', Colors.orange),
                  _buildMenuCard(context, Icons.assignment_outlined, 'Safety Quiz', Colors.purple),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget Helper: สำหรับสร้างการ์ดเมนูแต่ละอันเพื่อลดการเขียนโค้ดซ้ำ
  Widget _buildMenuCard(BuildContext context, IconData icon, String title, Color iconColor) {
    return InkWell(
      onTap: () {
        if (title.contains('Medical')) {
          Navigator.push(
            context, 
            MaterialPageRoute(builder: (context) => const MedicalIdScreen())
          );
        }
      },
      borderRadius: BorderRadius.circular(12), // ทำให้เวลากดแล้วมี Effect โค้งตามการ์ด
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[300]!),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: iconColor),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13, 
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}