import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart'; // นำเข้า Firebase Auth
import 'package:cloud_firestore/cloud_firestore.dart'; // นำเข้า Firestore

class ScoreAchievementScreen extends StatefulWidget {
  const ScoreAchievementScreen({super.key});

  @override
  State<ScoreAchievementScreen> createState() => _ScoreAchievementScreenState();
}

class _ScoreAchievementScreenState extends State<ScoreAchievementScreen> {
  String _userName = 'ยังไม่ได้ระบุชื่อ';
  Uint8List? _userImage;

  int totalUserScore = 0;
  int totalPossibleScore = 0;
  List<Map<String, dynamic>> categoryStats = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAllData();
  }

  // --- โหลดข้อมูลจาก Firebase และ Local ---
  Future<void> _loadAllData() async {
    final prefs = await SharedPreferences.getInstance();
    
    // 1. พยายามดึงคะแนนล่าสุดจาก Firebase ก่อน (ถ้ามีเน็ต)
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        DocumentSnapshot doc = await FirebaseFirestore.instance.collection('users').doc(currentUser.uid).get();
        if (doc.exists) {
          var data = doc.data() as Map<String, dynamic>;

          // อัปเดตชื่อและรูปในเครื่อง
          if (data['name'] != null) await prefs.setString('med_name', data['name']);
          if (data['med_imageBytes'] != null) await prefs.setString('med_imageBytes', data['med_imageBytes']);

          // ดึงคะแนน Quiz จาก Map มาอัปเดตลงเครื่อง
          if (data['quizScores'] != null) {
            Map<String, dynamic> scores = data['quizScores'];
            scores.forEach((key, value) async {
              await prefs.setInt(key, value as int);
            });
          }
        }
      }
    } catch (e) {
      print("Error fetching scores from Firebase: $e"); // ถ้าพังให้ปล่อยผ่านไปใช้ข้อมูลที่เคยเซฟไว้
    }

    // 2. โหลดและคำนวณจาก SharedPreferences (เพื่อแสดงผล)
    String? name = prefs.getString('med_name');
    String? base64Image = prefs.getString('med_imageBytes');
    
    int tempTotal = 0;
    int tempMax = 0;
    List<Map<String, dynamic>> tempStats = [];

    List<String> categories = [
      'Basic First Aid', 
      'CPR & AED', 
      'Fire Safety', 
      'Campus Safety', 
      'Wildlife & Animal', 
      'Emergency Protocols'
    ];
    
    for (String cat in categories) {
      int catScore = 0;
      int catMax = 0;
      
      for (int i = 1; i <= 5; i++) {
        String key = "score_${cat}_Quiz $i";
        catScore += prefs.getInt(key) ?? 0;
        catMax += prefs.getInt("${key}_total") ?? 0;
      }

      tempTotal += catScore;
      tempMax += catMax;

      tempStats.add({
        'title': cat,
        'score': catScore,
        'total': catMax,
        'percentage': catMax > 0 ? catScore / catMax : 0.0,
      });
    }

    setState(() {
      _userName = (name == null || name.isEmpty) ? 'ยังไม่ได้ระบุชื่อ' : name;
      if (base64Image != null && base64Image.isNotEmpty) {
        _userImage = base64Decode(base64Image);
      }
      
      totalUserScore = tempTotal;
      totalPossibleScore = tempMax;
      categoryStats = tempStats;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    double totalPercentage = totalPossibleScore > 0 ? totalUserScore / totalPossibleScore : 0.0;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1D0A45),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFFFFD700)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Safety Badge', style: TextStyle(color: Color(0xFFFFD700), fontWeight: FontWeight.bold)),
        elevation: 0,
      ),
      body: isLoading 
        ? const Center(child: CircularProgressIndicator(color: Color(0xFF1D0A45)))
        : RefreshIndicator(
            onRefresh: _loadAllData, // ดึงจอลงเพื่อโหลดข้อมูลจากเซิร์ฟเวอร์ใหม่
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  _buildProfileHeader(),
                  
                  const SizedBox(height: 32),
                  const Text('ความแม่นยำโดยรวม', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  
                  _buildCircularScore(totalPercentage),
                  
                  const SizedBox(height: 40),
                  const Divider(thickness: 1.5),
                  const SizedBox(height: 16),
                  
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('สรุปความแม่นยำรายหมวดหมู่', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1D0A45))),
                  ),
                  const SizedBox(height: 16),
                  
                  ...categoryStats.map((stat) => _buildCategoryStatCard(stat)),
                  
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
    );
  }

  Widget _buildProfileHeader() {
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundColor: Colors.grey[200],
          backgroundImage: _userImage != null ? MemoryImage(_userImage!) : null,
          child: _userImage == null ? const Icon(Icons.person, size: 50, color: Colors.grey) : null,
        ),
        const SizedBox(height: 12),
        Text(
          _userName, 
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1D0A45)),
        ),
        const Text('ผู้พิทักษ์ความปลอดภัยในวิทยาเขต', style: TextStyle(color: Colors.grey, fontSize: 14)),
      ],
    );
  }

  Widget _buildCircularScore(double percent) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 170, 
          height: 170, 
          child: CircularProgressIndicator(
            value: percent, 
            strokeWidth: 15, 
            backgroundColor: Colors.grey[200], 
            color: const Color(0xFFFFD700),
          )
        ),
        Column(
          children: [
            Text('${(percent * 100).toInt()}%', style: const TextStyle(fontSize: 45, fontWeight: FontWeight.bold, color: Color(0xFF1D0A45))),
            if (totalPossibleScore > 0)
              Text('ทำถูก $totalUserScore / $totalPossibleScore', style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
            if (totalPossibleScore == 0)
              const Text('ยังไม่มีประวัติการทำควิซ', style: TextStyle(color: Colors.grey, fontSize: 12)),
          ],
        ),
      ],
    );
  }

  Widget _buildCategoryStatCard(Map<String, dynamic> stat) {
    int percent = (stat['percentage'] * 100).toInt();
    bool hasPlayed = stat['total'] > 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey[300]!),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(stat['title'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              Text(
                hasPlayed ? '$percent%' : '0%', 
                style: TextStyle(fontWeight: FontWeight.bold, color: hasPlayed ? const Color(0xFF4A00E0) : Colors.grey, fontSize: 18)
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: stat['percentage'], 
            minHeight: 10, 
            borderRadius: BorderRadius.circular(5), 
            color: const Color(0xFF4A00E0),
            backgroundColor: Colors.grey[200],
          ),
          if (hasPlayed)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Align(
                alignment: Alignment.centerRight,
                child: Text('ทำถูก ${stat['score']} จาก ${stat['total']} ข้อ', style: const TextStyle(fontSize: 11, color: Colors.grey)),
              ),
            ),
        ],
      ),
    );
  }
}