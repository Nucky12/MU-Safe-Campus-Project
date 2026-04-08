import 'package:flutter/material.dart';

// ==========================================
// 1. คลาสโครงสร้างข้อมูลคะแนนแต่ละหมวดหมู่
// ==========================================
class QuizScore {
  final String title;
  final int score;
  final int total;
  final IconData icon;
  final Color color;

  QuizScore({
    required this.title,
    required this.score,
    required this.total,
    required this.icon,
    required this.color,
  });

  double get percentage => score / total;
  bool get isPerfect => score == total; // เช็คว่าได้คะแนนเต็มหรือไม่
}

// ==========================================
// 2. หน้าจอแสดงผลคะแนนและเหรียญรางวัล
// ==========================================
class ScoreAchievementScreen extends StatelessWidget {
  const ScoreAchievementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ข้อมูลจำลอง (Mock Data) - ในอนาคตสามารถดึงจาก Database มาใส่ตรงนี้ได้
    final List<QuizScore> myScores = [
      QuizScore(title: 'Quiz 1: การปฐมพยาบาล', score: 3, total: 3, icon: Icons.medical_services, color: Colors.green), // เต็ม (จะไม่แสดงในรายการทบทวน)
      QuizScore(title: 'Quiz 2: การรับมืออัคคีภัย', score: 5, total: 10, icon: Icons.fire_extinguisher, color: Colors.orange), // ไม่เต็ม
      QuizScore(title: 'Quiz 3: สัตว์มีพิษ', score: 4, total: 7, icon: Icons.pest_control, color: Colors.red), // ไม่เต็ม
    ];

    // คำนวณคะแนนรวม
    int totalScore = myScores.fold(0, (sum, item) => sum + item.score);
    int totalPossible = myScores.fold(0, (sum, item) => sum + item.total);
    double totalPercentage = totalPossible > 0 ? (totalScore / totalPossible) : 0.0;

    // คัดกรองเฉพาะควิซที่ยังได้คะแนนไม่เต็ม
    final List<QuizScore> needsReviewScores = myScores.where((quiz) => !quiz.isPerfect).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1D0A45),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFFFFD700)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Safety Badge', style: TextStyle(color: Color(0xFFFFD700), fontWeight: FontWeight.bold)),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4.0),
          child: Container(color: const Color(0xFFFFD700), height: 4.0),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // --- ส่วนที่ 1: กราฟวงกลมแสดงคะแนนรวม ---
            const Text('คะแนนรวมของฉัน', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1D0A45))),
            const SizedBox(height: 24),
            
            Stack(
              alignment: Alignment.center,
              children: [
                // วงกลม Progress Bar
                SizedBox(
                  width: 160,
                  height: 160,
                  child: CircularProgressIndicator(
                    value: totalPercentage,
                    strokeWidth: 16,
                    backgroundColor: Colors.grey[200],
                    color: const Color(0xFFFFD700), // สีเหลืองทอง
                  ),
                ),
                // ตัวหนังสือเปอร์เซ็นต์ตรงกลาง
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${(totalPercentage * 100).toInt()}%',
                      style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Color(0xFF1D0A45)),
                    ),
                    Text(
                      '$totalScore / $totalPossible',
                      style: const TextStyle(fontSize: 16, color: Colors.grey, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            // ข้อความให้กำลังใจตามเกณฑ์คะแนน
            Text(
              totalPercentage == 1.0 
                  ? 'ยอดเยี่ยมมาก! คุณคือผู้เชี่ยวชาญด้านความปลอดภัย'
                  : totalPercentage >= 0.6 
                      ? 'ทำได้ดีมาก! พยายามอีกนิดนะ'
                      : 'อย่าเพิ่งท้อ! ลองทบทวนความรู้ดูใหม่นะ',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: totalPercentage >= 0.6 ? Colors.green : Colors.orange),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 32),
            const Divider(thickness: 2),
            const SizedBox(height: 16),

            // --- ส่วนที่ 2: รายการหมวดหมู่ที่ต้องทบทวน (เฉพาะที่คะแนนไม่เต็ม) ---
            const Align(
              alignment: Alignment.centerLeft,
              child: Text('หมวดหมู่ที่ต้องทบทวน', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.redAccent)),
            ),
            const SizedBox(height: 16),

            if (needsReviewScores.isEmpty)
              const Padding(
                padding: EdgeInsets.all(24.0),
                child: Text('ยินดีด้วย! คุณทำคะแนนเต็มครบทุกหมวดหมู่แล้ว 🎉', style: TextStyle(fontSize: 16, color: Colors.green), textAlign: TextAlign.center),
              )
            else
              ...needsReviewScores.map((quiz) => _buildReviewCard(context, quiz)),

          ],
        ),
      ),
    );
  }

  // Widget สำหรับสร้างการ์ดแต่ละอัน
  Widget _buildReviewCard(BuildContext context, QuizScore quiz) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: quiz.color.withOpacity(0.2), shape: BoxShape.circle),
                child: Icon(quiz.icon, color: quiz.color, size: 30),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(quiz.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text('คะแนน: ${quiz.score} / ${quiz.total}', style: const TextStyle(fontSize: 14, color: Colors.grey)),
                  ],
                ),
              ),
              Text(
                '${(quiz.percentage * 100).toInt()}%',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: quiz.color),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // แถบหลอดคะแนนแนวนอน
          LinearProgressIndicator(
            value: quiz.percentage,
            minHeight: 8,
            backgroundColor: Colors.grey[200],
            color: quiz.color,
            borderRadius: BorderRadius.circular(4),
          ),
          const SizedBox(height: 16),
          // ปุ่มทำแบบทดสอบอีกครั้ง
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                // TODO: นำทางไปยังหน้า QuizScreen หรือ ActiveQuizScreen ที่ตรงกับหมวดหมู่นั้น
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('กำลังเปิด ${quiz.title}...')));
              },
              icon: const Icon(Icons.refresh, color: Color(0xFF1D0A45)),
              label: const Text('ทำแบบทดสอบอีกครั้ง', style: TextStyle(color: Color(0xFF1D0A45), fontWeight: FontWeight.bold)),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFF1D0A45)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}