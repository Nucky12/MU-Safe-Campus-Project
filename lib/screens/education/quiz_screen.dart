import 'package:flutter/material.dart';

// ==========================================
// ข้อมูล Data Models & Mock Data
// ==========================================
class Question {
  final String questionText;
  final List<String> options;
  final int correctAnswerIndex;
  Question({required this.questionText, required this.options, required this.correctAnswerIndex});
}

class QuizSet {
  final String title;
  final List<Question> questions;
  QuizSet({required this.title, required this.questions});
}

class QuizCategory {
  final String titleEn;
  final String titleTh;
  final IconData icon;
  final Color color;
  final List<QuizSet> quizSets;
  QuizCategory({required this.titleEn, required this.titleTh, required this.icon, required this.color, required this.quizSets});
}

// ฐานข้อมูลข้อสอบ
final List<QuizCategory> quizCategories = [
  QuizCategory(
    titleEn: 'Basic First Aid',
    titleTh: 'การปฐมพยาบาลเบื้องต้น',
    icon: Icons.medical_services,
    color: const Color(0xFF00FF00),
    quizSets: [
      QuizSet(
        title: 'Quiz 1',
        questions: [
          Question(questionText: 'อัตราความเร็วในการกดหน้าอก (CPR) ที่เหมาะสมคือเท่าใด?', options: ['60 - 80 ครั้ง/นาที', '100 - 120 ครั้ง/นาที', '140 - 160 ครั้ง/นาที', 'เร็วที่สุดเท่าที่จะทำได้'], correctAnswerIndex: 1),
          Question(questionText: 'ความลึกในการกดหน้าอกผู้ใหญ่ที่ถูกต้องคือเท่าใด?', options: ['1 - 2 นิ้ว', '2 - 2.4 นิ้ว', '3 - 4 นิ้ว', 'กดให้ลึกที่สุด'], correctAnswerIndex: 1),
          Question(questionText: 'เมื่อพบผู้บาดเจ็บ สิ่งแรกที่ต้องประเมินคืออะไร?', options: ['ความปลอดภัยของสถานที่', 'การหายใจของผู้ป่วย', 'ชีพจรของผู้ป่วย', 'บาดแผลตามร่างกาย'], correctAnswerIndex: 0),
          Question(questionText: 'การปฐมพยาบาลแผลน้ำร้อนลวกเบื้องต้นควรทำอย่างไร?', options: ['ทายาสีฟัน', 'ล้างด้วยน้ำสะอาดอุณหภูมิห้อง', 'ประคบน้ำแข็ง', 'เจาะตุ่มน้ำใส'], correctAnswerIndex: 1),
          Question(questionText: 'หากมีสิ่งของแทงทะลุร่างกาย ควรทำอย่างไร?', options: ['รีบดึงออกทันที', 'ขยับสิ่งของให้เข้าที่', 'ใช้ผ้าพันยึดสิ่งของให้อยู่นิ่งและห้ามดึงออก', 'ตัดสิ่งของส่วนที่โผล่ออกมา'], correctAnswerIndex: 2),
        ],
      ),
      QuizSet(title: 'Quiz 2', questions: [
        Question(questionText: 'อาการใดบ่งบอกว่าผู้ป่วยมีภาวะอุดกั้นทางเดินหายใจรุนแรง?', options: ['ไอเสียงดัง', 'พูดคุยได้ปกติ', 'เอามือจับที่ลำคอ หน้าเขียว หายใจไม่ออก', 'ร้องไห้เสียงดัง'], correctAnswerIndex: 2),
        Question(questionText: 'การช่วยเหลือผู้ที่อาหารติดคอ (อุดกั้นทางเดินหายใจรุนแรง) ควรใช้วิธีใด?', options: ['Heimlich Maneuver', 'CPR', 'เป่าปาก', 'ให้นอนพัก'], correctAnswerIndex: 0),
      ]),
      QuizSet(title: 'Quiz 3', questions: []), QuizSet(title: 'Quiz 4', questions: []), QuizSet(title: 'Quiz 5', questions: []),
      QuizSet(title: 'Quiz 6', questions: []), QuizSet(title: 'Quiz 7', questions: []), QuizSet(title: 'Quiz 8', questions: []),
      QuizSet(title: 'Quiz 9', questions: []), QuizSet(title: 'Quiz 10', questions: []),
    ],
  ),
  QuizCategory(
    titleEn: 'CPR & AED',
    titleTh: 'การทำ CPR และใช้เครื่อง AED',
    icon: Icons.monitor_heart,
    color: const Color(0xFFFF00FF),
    quizSets: [
      QuizSet(
        title: 'Quiz 1',
        questions: [
          Question(questionText: 'ข้อใดคือขั้นตอนที่ถูกต้องเมื่อนำเครื่อง AED มาถึงผู้ป่วย?', options: ['แปะแผ่นทันที', 'เปิดเครื่องและทำตามคำแนะนำ', 'ปั๊มหัวใจต่อ', 'เช็ดตัวผู้ป่วย'], correctAnswerIndex: 1),
          Question(questionText: 'ห้ามสัมผัสตัวผู้ป่วยขณะที่เครื่อง AED กำลังทำอะไร?', options: ['กำลังเปิดเครื่อง', 'กำลังวิเคราะห์คลื่นหัวใจและทำการช็อก', 'กำลังแปะแผ่น', 'กำลังรอรถพยาบาล'], correctAnswerIndex: 1),
        ]
      )
    ],
  ),
  QuizCategory(titleEn: 'Fire Safety', titleTh: 'ความปลอดภัยจากอัคคีภัย', icon: Icons.fire_extinguisher, color: const Color(0xFFD4E157), quizSets: []),
  QuizCategory(titleEn: 'Campus Safety', titleTh: 'ความปลอดภัยในวิทยาเขต', icon: Icons.verified_user_outlined, color: const Color(0xFF5C6BC0), quizSets: []),
  QuizCategory(titleEn: 'Wildlife & Animal Safety', titleTh: 'ความปลอดภัยจากสัตว์', icon: Icons.park, color: const Color(0xFF2E7D32), quizSets: []),
  QuizCategory(titleEn: 'Emergency Protocols', titleTh: 'ขั้นตอนกรณีฉุกเฉิน', icon: Icons.emergency, color: const Color(0xFFFF0000), quizSets: []),
];

// ==========================================
// 1. หน้าเลือกหมวดหมู่ (Category List)
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
        bottom: PreferredSize(preferredSize: const Size.fromHeight(4.0), child: Container(color: const Color(0xFFFFD700), height: 4.0)),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.75,
        ),
        itemCount: quizCategories.length,
        itemBuilder: (context, index) {
          final category = quizCategories[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => QuizListScreen(category: category)));
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.black, width: 1.5),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(category.icon, size: 80, color: category.color),
                  const SizedBox(height: 16),
                  Text(category.titleEn, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 4),
                  Text(category.titleTh, textAlign: TextAlign.center, style: const TextStyle(fontSize: 12)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// ==========================================
// 2. หน้าเลือกชุดข้อสอบ (Quiz 1 - 10)
// ==========================================
class QuizListScreen extends StatelessWidget {
  final QuizCategory category;
  const QuizListScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1D0A45),
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios, color: Color(0xFFFFD700)), onPressed: () => Navigator.pop(context)),
        title: const Text('Safety Quiz', style: TextStyle(color: Color(0xFFFFD700), fontWeight: FontWeight.bold)),
        bottom: PreferredSize(preferredSize: const Size.fromHeight(4.0), child: Container(color: const Color(0xFFFFD700), height: 4.0)),
      ),
      body: Column(
        children: [
          // Header ส่วนบน
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Icon(category.icon, size: 40, color: category.color),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(category.titleEn, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                      Text('${category.titleTh} Quiz', style: const TextStyle(fontSize: 14)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // รายการ Quiz
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              itemCount: category.quizSets.isEmpty ? 10 : category.quizSets.length, // จำลอง 10 อันถ้าว่าง
              itemBuilder: (context, index) {
                final quizTitle = category.quizSets.isNotEmpty ? category.quizSets[index].title : 'Quiz ${index + 1}';
                final hasQuestions = category.quizSets.isNotEmpty && category.quizSets[index].questions.isNotEmpty;

                return GestureDetector(
                  onTap: () {
                    if (!hasQuestions) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('ข้อสอบชุดนี้ยังไม่พร้อมใช้งาน')));
                      return;
                    }
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ActiveQuizScreen(
                      category: category, 
                      quizSet: category.quizSets[index]
                    )));
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDCE775), // สีเหลืองมะนาว
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.black, width: 1.5),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(quizTitle, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        const Icon(Icons.arrow_circle_right_outlined, color: Colors.black),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ==========================================
// 3. หน้าทำข้อสอบ (Active Quiz Screen)
// ==========================================
class ActiveQuizScreen extends StatefulWidget {
  final QuizCategory category;
  final QuizSet quizSet;
  const ActiveQuizScreen({super.key, required this.category, required this.quizSet});

  @override
  State<ActiveQuizScreen> createState() => _ActiveQuizScreenState();
}

class _ActiveQuizScreenState extends State<ActiveQuizScreen> {
  int _currentIndex = 0;
  int _score = 0;
  int? _selectedOptionIndex;
  final List<String> _optionPrefixes = ['ก.', 'ข.', 'ค.', 'ง.'];

  void _nextQuestion() {
    if (_selectedOptionIndex == null) return;
    
    if (_selectedOptionIndex == widget.quizSet.questions[_currentIndex].correctAnswerIndex) {
      _score++;
    }

    if (_currentIndex < widget.quizSet.questions.length - 1) {
      setState(() {
        _currentIndex++;
        _selectedOptionIndex = null;
      });
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => QuizResultScreen(category: widget.category, quizSet: widget.quizSet, score: _score, total: widget.quizSet.questions.length)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestion = widget.quizSet.questions[_currentIndex];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1D0A45),
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios, color: Color(0xFFFFD700)), onPressed: () => Navigator.pop(context)),
        title: const Text('Safety Quiz', style: TextStyle(color: Color(0xFFFFD700), fontWeight: FontWeight.bold)),
        bottom: PreferredSize(preferredSize: const Size.fromHeight(4.0), child: Container(color: const Color(0xFFFFD700), height: 4.0)),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Icon(widget.category.icon, size: 40, color: widget.category.color),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.category.titleEn, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                      Text('${widget.category.titleTh} ${widget.quizSet.title}', style: const TextStyle(fontSize: 14)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // กล่องคำถาม
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.black, width: 1.5),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: Color(0xFFDCE775),
                            borderRadius: BorderRadius.vertical(top: Radius.circular(6.5)),
                            border: Border(bottom: BorderSide(color: Colors.black, width: 1.5)),
                          ),
                          child: Text('คำถามข้อที่ ${_currentIndex + 1}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.vertical(bottom: Radius.circular(6.5)),
                          ),
                          child: Text(
                            currentQuestion.questionText,
                            style: const TextStyle(fontSize: 20),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // กริดตัวเลือก 2x2
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1.0,
                    ),
                    itemCount: currentQuestion.options.length,
                    itemBuilder: (context, index) {
                      final isSelected = _selectedOptionIndex == index;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedOptionIndex = index;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isSelected ? const Color(0xFFE8EAF6) : Colors.white, // สีม่วงอ่อนเมื่อเลือก
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: isSelected ? const Color(0xFF1D0A45) : Colors.black, width: isSelected ? 2.5 : 1.5),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(_optionPrefixes[index], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                              const SizedBox(height: 8),
                              Text(currentQuestion.options[index], textAlign: TextAlign.center, style: const TextStyle(fontSize: 16)),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          
          // ปุ่ม Next ด้านล่างขวา
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                onPressed: _selectedOptionIndex != null ? _nextQuestion : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4A00E0),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                ),
                icon: const Icon(Icons.arrow_forward, color: Colors.white),
                label: const Text('Next', style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ==========================================
// 4. หน้าสรุปผลคะแนน (Result Screen)
// ==========================================
class QuizResultScreen extends StatelessWidget {
  final QuizCategory category;
  final QuizSet quizSet;
  final int score;
  final int total;

  const QuizResultScreen({super.key, required this.category, required this.quizSet, required this.score, required this.total});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1D0A45),
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios, color: Color(0xFFFFD700)), onPressed: () => Navigator.pop(context)),
        title: const Text('Safety Quiz', style: TextStyle(color: Color(0xFFFFD700), fontWeight: FontWeight.bold)),
        bottom: PreferredSize(preferredSize: const Size.fromHeight(4.0), child: Container(color: const Color(0xFFFFD700), height: 4.0)),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(category.icon, size: 80, color: const Color(0xFF00FF00)), // สีเขียวตามรูป
            const SizedBox(height: 16),
            Text(category.titleEn, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            Text('${category.titleTh}\n${quizSet.title}', textAlign: TextAlign.center, style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 24),
            const Text('คะแนนที่คุณทำได้ใน Quiz นี้', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            const Text('Total Score', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            Text('$score/$total', style: const TextStyle(fontSize: 60, fontWeight: FontWeight.bold)),
            Text(score >= (total / 2) ? 'เก่งมาก!!' : 'พยายามอีกนิด!!', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            
            const SizedBox(height: 40),
            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    // กลับไปหน้าเลือก Quiz List
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1D0A45),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Continue To Quizzes', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFFFFD700))),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}