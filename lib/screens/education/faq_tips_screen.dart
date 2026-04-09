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
            content: '1. ห้ามเข้าใกล้ และอย่าพยายามตีหรือจับเองเด็ดขาด\n2. สังเกตลักษณะของงู (สี, ลาย, ขนาด) เพื่อเป็นข้อมูล\n3. คอยดูทิศทางที่งูหนีไปอยู่ห่างๆ\n4. แจ้ง รปภ. หรือ ศูนย์ควบคุมสัตว์ (199) ทันที',
            emojiIcon: '🐍',
          ),
          FaqItem(
            title: 'วิธีใช้เครื่อง AED',
            content: '1. เปิดเครื่อง: กดปุ่มเปิด และทำตามเสียงแนะนำของเครื่องทันที\n2. ติดแผ่น: แปะแผ่นอิเล็กโทรดบนหน้าอกที่แห้งและเปลือยตามรูป\n3. วิเคราะห์: ห้ามสัมผัสตัวผู้ป่วย เพื่อให้เครื่องตรวจคลื่นหัวใจ\n4. ช็อก/CPR: กดปุ่มช็อกเมื่อเครื่องสั่ง และเริ่มปั๊มหัวใจ (CPR) ต่อทันที',
            icon: Icons.medical_information_outlined,
          ),
          FaqItem(
            title: 'AED ใช้กับ เด็ก ได้ไหม?',
            content: '1. ได้ (ถ้ามีโหมดเด็ก หรือ แผ่นแปะสำหรับเด็กให้ใช้ก่อน)\n2. ถ้าไม่มี: สามารถใช้แผ่นแปะผู้ใหญ่ได้ โดยแปะที่กลางหน้าอก 1 แผ่น และกลางหลัง 1 แผ่น (ไม่ให้แผ่นสัมผัสกัน)',
          ),
          FaqItem(
            title: 'เมื่อเกิดเพลิงไหม้ (หลักการ PASS)',
            content: 'การใช้ถังดับเพลิงให้จำหลัก PASS:\n• P (Pull): ดึงสลักนิรภัยออก\n• A (Aim): เล็งหัวฉีดไปที่ฐานของไฟ\n• S (Squeeze): กดบีบไกฉีด\n• S (Sweep): ส่ายหัวฉีดไปมาซ้ายขวาจนไฟดับ',
            emojiIcon: '🧯',
          ),
          FaqItem(
            title: 'เมื่อสารเคมีหกใส่ร่างกาย',
            content: '1. ถอดเสื้อผ้าส่วนที่เปื้อนสารเคมีออกทันที\n2. ล้างบริเวณที่สัมผัสด้วยน้ำสะอาดที่ไหลผ่านอย่างต่อเนื่อง (อย่างน้อย 15-20 นาที)\n3. ห้ามใช้สารแก้ล้าง (Neutralizer) หากไม่ทราบชนิดสารเคมีที่ชัดเจน\n4. รีบไปพบแพทย์พร้อมนำฉลากสารเคมีไปด้วย',
            emojiIcon: '🧪',
          ),
          FaqItem(
            title: 'หากลิฟต์ค้างต้องทำอย่างไร?',
            content: '1. ตั้งสติ อย่าตกใจ ลิฟต์มีระบบระบายอากาศ\n2. กดปุ่มกระดิ่งฉุกเฉิน (Emergency Bell) หรือปุ่ม Intercom เพื่อติดต่อเจ้าหน้าที่\n3. ห้ามพยายามงัดประตูลิฟต์หรือปีนออกทางเพดานเด็ดขาด\n4. รอคอยการช่วยเหลือจากช่างผู้เชี่ยวชาญ',
            icon: Icons.elevator,
          ),
          FaqItem(
            title: 'การปฐมพยาบาลคนเป็นลมแดด (Heatstroke)',
            content: '1. รีบพาผู้ป่วยเข้าที่ร่มและมีอากาศถ่ายเท\n2. ให้นอนราบ ยกเท้าสูง คลายเสื้อผ้าให้หลวม\n3. ใช้ผ้าชุบน้ำเย็นเช็ดตัว โดยเฉพาะข้อพับ ขาหนีบ รักแร้ คอ เพื่อระบายความร้อน\n4. หากหมดสติให้รีบโทร 1669 ทันที',
            emojiIcon: '🥵',
          ),
        ],
      ),
    );
  }
}

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
  bool _isExpanded = false;

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
          GestureDetector(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFDCE775),
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
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                      style: const TextStyle(fontSize: 14, height: 1.5, color: Colors.black87),
                    ),
                  ),
                  if (widget.emojiIcon != null) ...[
                    const SizedBox(width: 12),
                    Text(widget.emojiIcon!, style: const TextStyle(fontSize: 40)),
                  ] else if (widget.icon != null) ...[
                    const SizedBox(width: 12),
                    Icon(widget.icon, size: 50, color: Colors.red[700]),
                  ]
                ],
              ),
            ),
        ],
      ),
    );
  }
}