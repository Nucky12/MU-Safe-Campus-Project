import 'package:flutter/material.dart';

// ==========================================
// 1. คลาสจำลองโครงสร้างข้อมูลข้อสอบ
// ==========================================
class Question {
  final String questionText;
  final List<String> options;
  final int correctAnswerIndex;

  Question({
    required this.questionText,
    required this.options,
    required this.correctAnswerIndex,
  });
}

// ==========================================
// 2. หน้าหลัก: หน้าเลือกหมวดหมู่และชุดแบบทดสอบ
// ==========================================
class QuizScreen extends StatelessWidget {
  const QuizScreen({super.key});

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
        title: const Text('Safety Quiz', style: TextStyle(color: Color(0xFFFFD700), fontWeight: FontWeight.bold)),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4.0),
          child: Container(color: const Color(0xFFFFD700), height: 4.0),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const Text('เลือกหมวดหมู่แบบทดสอบ', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          
          // การ์ดชุดแบบทดสอบ
          _buildQuizCategoryCard(
            context,
            title: 'Quiz 1: การปฐมพยาบาลเบื้องต้น',
            description: 'ทดสอบความรู้เกี่ยวกับการ CPR, การใช้ AED และการปฐมพยาบาลเมื่อเกิดอุบัติเหตุ',
            icon: Icons.medical_services,
            color: Colors.red,
            // ข้อมูลข้อสอบจำลอง
            questions: [
              Question(
                questionText: 'หากพบผู้ป่วยหมดสติ ไม่หายใจ สิ่งแรกที่ควรทำคืออะไร?',
                options: ['โทร 1669 ทันที', 'ปั๊มหัวใจ (CPR)', 'หาน้ำให้ดื่ม', 'เขย่าตัวแรงๆ'],
                correctAnswerIndex: 0,
              ),
              Question(
                questionText: 'เครื่อง AED มีหน้าที่หลักคืออะไร?',
                options: ['วัดความดันโลหิต', 'กระตุกหัวใจด้วยไฟฟ้า', 'ช่วยหายใจอัตโนมัติ', 'วัดอัตราการเต้นของหัวใจ'],
                correctAnswerIndex: 1,
              ),
              Question(
                questionText: 'เมื่อถูกงูกัด ควรปฐมพยาบาลเบื้องต้นอย่างไร?',
                options: ['ใช้ปากดูดพิษออก', 'รัดเชือกเหนือแผลให้แน่นที่สุด', 'ล้างแผลด้วยน้ำสะอาดและดามอวัยวะให้นิ่ง', 'กรีดแผลให้เลือดไหลออก'],
                correctAnswerIndex: 2,
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          _buildQuizCategoryCard(
            context,
            title: 'Quiz 2: การรับมืออัคคีภัย',
            description: 'การเอาตัวรอดเมื่อเกิดเหตุไฟไหม้และการใช้ถังดับเพลิง',
            icon: Icons.fire_extinguisher,
            color: Colors.orange,
            questions: [], // ใส่ข้อสอบเพิ่มได้ในอนาคต
          ),
        ],
      ),
    );
  }

  Widget _buildQuizCategoryCard(BuildContext context, {required String title, required String description, required IconData icon, required Color color, required List<Question> questions}) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          if (questions.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('แบบทดสอบนี้ยังไม่พร้อมใช้งาน')));
            return;
          }
          // นำเข้าสู่หน้าทำข้อสอบ
          Navigator.push(context, MaterialPageRoute(builder: (context) => ActiveQuizScreen(quizTitle: title, questions: questions)));
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: color.withOpacity(0.2), shape: BoxShape.circle),
                child: Icon(icon, size: 40, color: color),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(description, style: TextStyle(fontSize: 14, color: Colors.grey[700])),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==========================================
// 3. หน้าทำข้อสอบ (Active Quiz Screen)
// ==========================================
class ActiveQuizScreen extends StatefulWidget {
  final String quizTitle;
  final List<Question> questions;

  const ActiveQuizScreen({super.key, required this.quizTitle, required this.questions});

  @override
  State<ActiveQuizScreen> createState() => _ActiveQuizScreenState();
}

class _ActiveQuizScreenState extends State<ActiveQuizScreen> {
  int _currentIndex = 0;
  int _score = 0;
  int? _selectedOptionIndex; // เก็บค่าตัวเลือกที่ผู้ใช้เลือก

  void _nextQuestion() {
    if (_selectedOptionIndex == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('กรุณาเลือกคำตอบก่อนไปข้อถัดไป'), backgroundColor: Colors.orange));
      return;
    }

    // ตรวจคำตอบและบวกคะแนน
    if (_selectedOptionIndex == widget.questions[_currentIndex].correctAnswerIndex) {
      _score++;
    }

    if (_currentIndex < widget.questions.length - 1) {
      setState(() {
        _currentIndex++;
        _selectedOptionIndex = null; // รีเซ็ตการเลือกสำหรับข้อใหม่
      });
    } else {
      // ทำข้อสอบเสร็จแล้ว นำไปหน้าสรุปผล
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => QuizResultScreen(score: _score, total: widget.questions.length)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestion = widget.questions[_currentIndex];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1D0A45),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFFFFD700)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(widget.quizTitle, style: const TextStyle(color: Color(0xFFFFD700), fontSize: 16, fontWeight: FontWeight.bold)),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4.0),
          child: Container(color: const Color(0xFFFFD700), height: 4.0),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // แสดงเลขข้อ
            Text(
              'ข้อที่ ${_currentIndex + 1} / ${widget.questions.length}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            
            // แสดงคำถาม
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFF0EFFF), // สีม่วงอ่อนๆ
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF1D0A45), width: 1),
              ),
              child: Text(
                currentQuestion.questionText,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 32),

            // แสดงตัวเลือก
            ...List.generate(currentQuestion.options.length, (index) {
              final isSelected = _selectedOptionIndex == index;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedOptionIndex = index;
                  });
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF1D0A45) : Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: isSelected ? const Color(0xFF1D0A45) : Colors.grey.shade400, width: 2),
                    boxShadow: isSelected ? [const BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2))] : [],
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                        color: isSelected ? const Color(0xFFFFD700) : Colors.grey,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          currentQuestion.options[index],
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            color: isSelected ? Colors.white : Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),

            const Spacer(),
            
            // ปุ่มไปข้อถัดไป
            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: _nextQuestion,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1D0A45),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: Text(
                  _currentIndex == widget.questions.length - 1 ? 'ส่งคำตอบ' : 'ข้อถัดไป',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFFFFD700)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// 4. หน้าสรุปผลคะแนน (Result Screen)
// ==========================================
class QuizResultScreen extends StatelessWidget {
  final int score;
  final int total;

  const QuizResultScreen({super.key, required this.score, required this.total});

  @override
  Widget build(BuildContext context) {
    // คำนวณเปอร์เซ็นต์เพื่อกำหนดข้อความแสดงความยินดี
    double percentage = score / total;
    String resultMessage;
    Color resultColor;

    if (percentage == 1.0) {
      resultMessage = 'ยอดเยี่ยมมาก! คุณมีความรู้ครบถ้วน';
      resultColor = Colors.green;
    } else if (percentage >= 0.5) {
      resultMessage = 'เก่งมาก! แต่ยังสามารถเรียนรู้เพิ่มได้อีกนะ';
      resultColor = Colors.orange;
    } else {
      resultMessage = 'พยายามอีกนิด! ลองอ่านหน้า FAQ & Tips เพิ่มเติมนะ';
      resultColor = Colors.red;
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1D0A45),
        automaticallyImplyLeading: false, // เอาปุ่ม back ด้านบนออก บังคับให้กดปุ่มด้านล่าง
        title: const Text('Quiz Result', style: TextStyle(color: Color(0xFFFFD700), fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.emoji_events, size: 120, color: const Color(0xFFFFD700).withOpacity(0.9)),
              const SizedBox(height: 24),
              const Text('คะแนนของคุณคือ', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.grey)),
              const SizedBox(height: 8),
              
              Text(
                '$score / $total',
                style: const TextStyle(fontSize: 60, fontWeight: FontWeight.bold, color: Color(0xFF1D0A45)),
              ),
              const SizedBox(height: 16),
              
              Text(
                resultMessage,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: resultColor),
              ),
              
              const SizedBox(height: 40),
              
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    // ปิดหน้า Result กลับไปหน้าแรกของ Quiz
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1D0A45),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('กลับสู่หน้าหลัก', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFFFFD700))),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}