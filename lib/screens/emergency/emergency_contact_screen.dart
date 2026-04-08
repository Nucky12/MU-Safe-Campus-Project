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
            _buildContactBox(context, Icons.airport_shuttle, '1669', 'Ambulance'),
            _buildContactBox(context, Icons.local_police, '191', 'Police'),
            _buildContactBox(context, Icons.fire_truck, '199', 'Fire Dept.'),
            _buildContactBox(context, Icons.add_circle, '1554', 'Vajira Foundation'),
          ],
        ),
      ),
    );
  }

  Widget _buildContactBox(BuildContext context, IconData icon, String number, String name) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EmergencyDetailScreen(number: number, name: name),
          ),
        );
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFFFE066), // สีเหลืองตามดีไซน์
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: Colors.black),
            const SizedBox(height: 8),
            Text(number, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text(name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
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

  const EmergencyDetailScreen({super.key, required this.number, required this.name});

  // ฟังก์ชันสำหรับเชื่อมต่อไปยังแอปโทรศัพท์ของเครื่อง
  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
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
                  const Text(
                    'เบอร์ 1669 คือสายด่วนสถาบันการแพทย์ฉุกเฉินแห่งชาติ\n(สพฉ.) ให้บริการ "เจ็บป่วยฉุกเฉินวิกฤต"\nฟรีตลอด 24 ชั่วโมง ทั่วไทย\nเมื่อเกิดอุบัติเหตุหรือผู้ป่วยวิกฤต (สีแดง/เหลือง)\nให้ตั้งสติ โทร 1669 แจ้งอาการ สถานที่เกิดเหตุชัดเจน\nเจ้าหน้าที่จะประเมินและส่งทีมกู้ชีพเข้าช่วยเหลือทันที',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14),
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
                  const Icon(Icons.phone_in_talk, size: 80, color: Colors.black87),
                  const SizedBox(width: 16),
                  Container(
                    decoration: const BoxDecoration(
                      border: Border(bottom: BorderSide(color: Colors.blue, width: 4)),
                    ),
                    child: Text(
                      number,
                      style: const TextStyle(fontSize: 80, fontWeight: FontWeight.bold, color: Colors.blue),
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
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('ข้อควรรู้เมื่อโทร $number', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  SizedBox(height: 8),
                  Text(
                    'ใช้เมื่อฉุกเฉินจริง: เจ็บแน่นหน้าอก, หายใจไม่ออก, หมดสติ,\nเลือดออกมาก, อุบัติเหตุรุนแรง\nสิ่งที่ต้องทำในสถานการณ์จริง: 1. ตั้งสติ บอกสถานที่เกิดเหตุ/จุดสังเกตที่ชัดเจน\n2. แจ้งอาการเจ็บป่วย/บาดเจ็บ ระดับความรู้สึกตัว\n3. แจ้งจำนวนผู้ป่วย/เพศ/อายุ\n4. บอกชื่อและเบอร์โทรที่ติดต่อได้\n5. ทำตามคำแนะนำเจ้าหน้าที่และรอทีมกู้ชีพ\nหมายเหตุ: ไม่ควรโทรเล่น เพราะเป็นการตัดโอกาสผู้ป่วยวิกฤตรายอื่น',
                    style: TextStyle(fontSize: 12),
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