import 'package:flutter/material.dart';
import '../../core/constants.dart';

class HazardReporterScreen extends StatelessWidget {
  const HazardReporterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryPurple,
        title: const Text('แจ้งจุดเสี่ยง/อุบัติเหตุ', style: TextStyle(color: AppColors.primaryGold, fontWeight: FontWeight.bold)),
        iconTheme: const IconThemeData(color: AppColors.primaryGold),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // กล่องถ่ายรูป
            InkWell(
              onTap: () {
                // TODO: โค้ดเรียกเปิดกล้อง
              },
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade400, style: BorderStyle.solid),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.camera_alt, size: 60, color: Colors.grey),
                    SizedBox(height: 10),
                    Text('แตะเพื่อถ่ายรูปจุดเกิดเหตุ', style: TextStyle(color: Colors.grey, fontSize: 16)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            
            // ฟอร์มกรอกข้อมูล
            const TextField(
              decoration: InputDecoration(
                labelText: 'หัวข้อการแจ้งเหตุ (เช่น ไฟดับ, งูเข้าตึก)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.warning_amber_rounded),
              ),
            ),
            const SizedBox(height: 16),
            const TextField(
              maxLines: 4,
              decoration: InputDecoration(
                labelText: 'รายละเอียดเพิ่มเติม / ระบุพิกัดที่ชัดเจน',
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
            ),
            const Spacer(),
            
            // ปุ่มส่งข้อมูล
            SizedBox(
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryPurple,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('ส่งรายงานสำเร็จ เจ้าหน้าที่ได้รับเรื่องแล้ว!'))
                  );
                  Navigator.pop(context); // ส่งเสร็จแล้วเด้งกลับหน้าเดิม
                },
                child: const Text('ส่งรายงานแจ้งเหตุ', style: TextStyle(color: AppColors.primaryGold, fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}