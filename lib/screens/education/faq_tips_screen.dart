import 'package:flutter/material.dart';

class FaqTipsScreen extends StatelessWidget {
  const FaqTipsScreen({super.key});

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
        title: const Text('Safety FAQ & Tips', style: TextStyle(color: Color(0xFFFFD700), fontWeight: FontWeight.bold)),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4.0),
          child: Container(color: const Color(0xFFFFD700), height: 4.0),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: const [
          FaqItem(
            title: 'ถ้าเจองูในตึกจะทำยังไง?',
            content: '1. ห้ามเข้าใกล้\n2. สังเกตลักษณะของงู\n3. แจ้ง รปภ. หรือ ศูนย์ควบคุมสัตว์',
            emojiIcon: '🐍',
          ),
          FaqItem(
            title: 'วิธีใช้เครื่อง AED',
            content: '1. เปิดเครื่อง: กดปุ่มเปิด และทำตามเสียงแนะนำของเครื่องทันที\n2. ติดแผ่น: แปะแผ่นอิเล็กโทรดบนหน้าอกที่แห้งและเปลือยตามรูป\n3. วิเคราะห์: ห้ามสัมผัสตัวผู้ป่วย เพื่อให้เครื่องตรวจคลื่นหัวใจ\n4. ช็อก/CPR: กดปุ่มช็อกเมื่อเครื่องสั่ง และเริ่มปั๊มหัวใจ (CPR) ต่อทันที',
            icon: Icons.medical_information_outlined,
          ),
          FaqItem(
            title: 'AED ใช้กับ เด็ก ได้ไหม?',
            content: '1. ได้ (ถ้ามีโหมดเด็ก / แผ่นแปะเด็ก)\n2. ถ้าไม่มี : ปรับระดับพลังงานต่ำลง',
          ),
          // คุณสามารถเพิ่ม FaqItem เรื่องอื่นๆ ต่อตรงนี้ได้เลย
        ],
      ),
    );
  }
}

// ---------------------------------------------------------
// Custom Widget สำหรับสร้างกล่องข้อความที่กดเปิด-ปิดได้
// ---------------------------------------------------------
class FaqItem extends StatefulWidget {
  final String title;
  final String content;
  final IconData? icon;
  final String? emojiIcon;

  const FaqItem({
    super.key,
    required this.title,
    required this.content,
    this.icon,
    this.emojiIcon,
  });

  @override
  State<FaqItem> createState() => _FaqItemState();
}

class _FaqItemState extends State<FaqItem> {
  bool _isExpanded = true; // ค่าเริ่มต้นให้กางออกเหมือนในดีไซน์

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.black, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- ส่วนหัว (สีเหลืองมะนาว) ---
          GestureDetector(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFDCE775), // สีเหลืองมะนาวตามรูป
                borderRadius: _isExpanded
                    ? const BorderRadius.vertical(top: Radius.circular(6.5))
                    : BorderRadius.circular(6.5),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      widget.title,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Icon(
                    _isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                    size: 32,
                    color: Colors.black87,
                  ),
                ],
              ),
            ),
          ),
          
          // --- ส่วนเนื้อหา (สีขาว) ---
          if (_isExpanded)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: Colors.black, width: 1.5)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      widget.content,
                      style: const TextStyle(fontSize: 15, height: 1.5, color: Colors.black87),
                    ),
                  ),
                  
                  // แสดงรูปไอคอน หรือ อิโมจิ ด้านขวา (ถ้ามีการใส่ค่ามา)
                  if (widget.emojiIcon != null) ...[
                    const SizedBox(width: 12),
                    Text(widget.emojiIcon!, style: const TextStyle(fontSize: 40)),
                  ] else if (widget.icon != null) ...[
                    const SizedBox(width: 12),
                    Icon(widget.icon, size: 50, color: Colors.red[700]), // สีแดงสำหรับกล่องพยาบาล
                  ]
                ],
              ),
            ),
        ],
      ),
    );
  }
}