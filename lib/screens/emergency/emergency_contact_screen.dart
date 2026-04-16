import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class EmergencyContactScreen extends StatelessWidget {
  const EmergencyContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1D0A45),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFFFFD700)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Emergency Contact', style: TextStyle(color: Color(0xFFFFD700), fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
          childAspectRatio: 1.0,
          children: [
            _buildContactBox(
              context, 
              Icons.airport_shuttle, '1669', 'Ambulance',
              'สายด่วนสถาบันการแพทย์ฉุกเฉินแห่งชาติ (สพฉ.) ให้บริการ "เจ็บป่วยฉุกเฉินวิกฤต" ฟรีตลอด 24 ชั่วโมง ทั่วไทย เมื่อเกิดอุบัติเหตุหรือผู้ป่วยวิกฤต (สีแดง/เหลือง) ให้ตั้งสติ โทร 1669 แจ้งอาการและสถานที่เกิดเหตุให้ชัดเจน',
              'ใช้เมื่อฉุกเฉินจริง: เจ็บแน่นหน้าอก, หายใจไม่ออก, หมดสติ, เลือดออกมาก, อุบัติเหตุรุนแรง\n\nสิ่งที่ต้องทำ:\n1. ตั้งสติ บอกสถานที่เกิดเหตุ\n2. แจ้งอาการบาดเจ็บ\n3. บอกชื่อและเบอร์โทรที่ติดต่อได้\n4. ทำตามคำแนะนำเจ้าหน้าที่'
            ),
            _buildContactBox(
              context, 
              Icons.local_police, '191', 'Police',
              'สายด่วนศูนย์รับแจ้งเหตุตำรวจแห่งชาติ ให้บริการตลอด 24 ชั่วโมง ใช้สำหรับแจ้งเหตุด่วนเหตุร้าย อาชญากรรม ทะเลาะวิวาท หรือพบเห็นเหตุการณ์ที่อาจเป็นอันตรายต่อชีวิตและทรัพย์สิน',
              'ใช้เมื่อ: เกิดเหตุอาชญากรรม, โจรผู้ร้าย, ทะเลาะวิวาท, หรือเหตุที่ต้องใช้กำลังตำรวจ\n\nสิ่งที่ต้องทำ:\n1. บอกลักษณะเหตุการณ์\n2. สถานที่เกิดเหตุและจุดสังเกต\n3. ลักษณะคนร้าย (รูปพรรณ, ยานพาหนะ)\n4. ระมัดระวังความปลอดภัยของตนเอง'
            ),
            _buildContactBox(
              context, 
              Icons.fire_truck, '199', 'Fire Dept.',
              'สายด่วนศูนย์วิทยุพระราม แจ้งเหตุอัคคีภัยและกู้ภัย ให้บริการ 24 ชั่วโมง ใช้สำหรับแจ้งเหตุไฟไหม้ สัตว์มีพิษเข้าบ้าน หรือขอความช่วยเหลือด้านกู้ภัยต่างๆ',
              'ใช้เมื่อ: เกิดเพลิงไหม้, พบสัตว์มีพิษ (งู, ตัวเงินตัวทอง), หรือภัยพิบัติต่างๆ\n\nสิ่งที่ต้องทำ:\n1. แจ้งประเภทของเหตุ (ไฟไหม้/จับสัตว์)\n2. สถานที่เกิดเหตุอย่างละเอียด\n3. มีผู้ติดอยู่ภายในอาคารหรือไม่\n4. รีบออกจากพื้นที่อันตรายทันที'
            ),
            _buildContactBox(
              context, 
              Icons.add_circle, '1554', 'Vajira Foundation',
              'สายด่วนหน่วยกู้ชีพ คณะแพทยศาสตร์วชิรพยาบาล ให้บริการแพทย์ฉุกเฉินและกู้ชีพขั้นสูง พร้อมทีมแพทย์และพยาบาลเฉพาะทาง',
              'ใช้เมื่อ: เกิดอุบัติเหตุรุนแรง, ผู้ป่วยฉุกเฉินวิกฤตที่ต้องการทีมแพทย์กู้ชีพขั้นสูง\n\nสิ่งที่ต้องทำ:\n1. แจ้งลักษณะอุบัติเหตุและอาการผู้ป่วย\n2. บอกพิกัดให้ชัดเจน\n3. ห้ามเคลื่อนย้ายผู้ป่วยเองหากไม่จำเป็น (โดยเฉพาะผู้บาดเจ็บที่คอหรือกระดูก)'
            ),
            _buildContactBox(
              context, 
              Icons.directions_car, '1137', 'JS100 Radio',
              'จส.100 (คลื่นวิทยุข่าวสารและการจราจร) รับแจ้งอุบัติเหตุบนท้องถนน ขอความช่วยเหลือกรณีรถเสีย แจ้งของหาย/เก็บของได้ หรือสอบถามเส้นทางจราจร',
              'ใช้เมื่อ: รถเสีย, อุบัติเหตุบนถนน, ลืมของบนแท็กซี่, หรือพบสิ่งกีดขวางจราจร\n\nสิ่งที่ต้องทำ:\n1. แจ้งพิกัดถนน/กิโลเมตร/จุดสังเกต\n2. กรณีของหาย: แจ้งสีรถ ทะเบียน และเวลาเกิดเหตุ\n3. หากรถเสีย ให้เปิดไฟฉุกเฉินและหลบเข้าข้างทาง'
            ),
          ],
        ),
      ),
    );
  }

  // ปรับฟังก์ชันให้รับค่ารายละเอียดต่างๆ ส่งไปหน้า Detail ด้วย
  Widget _buildContactBox(BuildContext context, IconData icon, String number, String name, String description, String tips) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EmergencyDetailScreen(
              number: number, 
              name: name,
              description: description,
              tips: tips,
            ),
          ),
        );
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFFFE066),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 45, color: Colors.black),
            const SizedBox(height: 8),
            Text(number, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text(name, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------
// หน้ารายละเอียดเมื่อกดเข้ามาที่แต่ละเบอร์
// ---------------------------------------------------------
class EmergencyDetailScreen extends StatelessWidget {
  final String number;
  final String name;
  final String description; // รับคำอธิบายหน่วยงาน
  final String tips;        // รับข้อควรรู้

  const EmergencyDetailScreen({
    super.key, 
    required this.number, 
    required this.name,
    required this.description,
    required this.tips,
  });

  // แก้ไขฟังก์ชันโทรออก: เอา canLaunchUrl ออก เพื่อบังคับข้ามระบบความปลอดภัยใน Emulator
  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    try {
      await launchUrl(launchUri); // บังคับให้มือถือพยายามเปิดแอปโทรศัพท์ทันที
    } catch (e) {
      debugPrint('ไม่สามารถโทรออกได้: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1D0A45),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFFFFD700)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Emergency Contact', style: TextStyle(color: Color(0xFFFFD700), fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // ส่วนกล่องข้อความอธิบายหน่วยงานด้านบน
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFE066),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '$number $name',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // แสดงคำอธิบายเฉพาะของเบอร์นั้นๆ
                  Text(
                    description,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            
            // ส่วนตัวเลขใหญ่ที่สามารถกดโทรออกได้
            GestureDetector(
              onTap: () => _makePhoneCall(number),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.phone_in_talk, size: 60, color: Colors.black87),
                  const SizedBox(width: 16),
                  Container(
                    decoration: const BoxDecoration(
                      border: Border(bottom: BorderSide(color: Colors.blue, width: 4)),
                    ),
                    child: Text(
                      number,
                      style: const TextStyle(fontSize: 60, fontWeight: FontWeight.bold, color: Colors.blue),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 40),
            
            // กล่องข้อควรรู้เมื่อโทรด้านล่าง
            Container(
              padding: const EdgeInsets.all(16),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('ข้อควรรู้เมื่อโทร $number', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 8),
                  // แสดงข้อควรรู้เฉพาะของเบอร์นั้นๆ
                  Text(
                    tips,
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}