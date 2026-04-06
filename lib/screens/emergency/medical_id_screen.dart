import 'package:flutter/material.dart';
import '../../core/constants.dart';

class MedicalIdScreen extends StatelessWidget {
  const MedicalIdScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primaryPurple,
        title: const Text('Medical ID', style: TextStyle(color: AppColors.primaryGold, fontWeight: FontWeight.bold)),
        iconTheme: const IconThemeData(color: AppColors.primaryGold), // สีปุ่ม Back
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // ส่วนโปรไฟล์
            const CircleAvatar(
              radius: 50,
              backgroundColor: AppColors.primaryPurple,
              child: Icon(Icons.person, size: 50, color: AppColors.primaryGold),
            ),
            const SizedBox(height: 16),
            const Text('นายสิรวิชญ์ น้อยเจริญ', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const Text('อายุ: 19 ปี', style: TextStyle(fontSize: 16, color: AppColors.textSecondary)),
            const SizedBox(height: 24),

            // ส่วนข้อมูลการแพทย์
            _buildInfoCard('กรุ๊ปเลือด (Blood Type)', 'O+', Colors.red),
            _buildInfoCard('โรคประจำตัว', 'ไม่มี', AppColors.primaryPurple),
            _buildInfoCard('ประวัติแพ้ยา/อาหาร', 'ไม่มี', AppColors.primaryPurple),
            const SizedBox(height: 24),

            // ส่วนติดต่อฉุกเฉิน
            const Align(
              alignment: Alignment.centerLeft,
              child: Text('ผู้ติดต่อฉุกเฉิน (Emergency Contact)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 10),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                contentPadding: const EdgeInsets.all(12),
                leading: const CircleAvatar(
                  backgroundColor: AppColors.primaryGold,
                  child: Icon(Icons.person, color: AppColors.primaryPurple),
                ),
                title: const Text('คุณจิรพล (พี่ชาย)', style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: const Text('089-301-8212', style: TextStyle(fontSize: 16)),
                trailing: IconButton(
                  icon: const Icon(Icons.phone_in_talk, color: Colors.green, size: 36),
                  onPressed: () {
                    // TODO: ใส่โค้ดคำสั่งโทรออกตรงนี้
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('กำลังโทร...')));
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget ตัวช่วยสำหรับสร้างกล่องข้อมูล
  Widget _buildInfoCard(String title, String value, Color valueColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 16, color: AppColors.textPrimary)),
          Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: valueColor)),
        ],
      ),
    );
  }
}