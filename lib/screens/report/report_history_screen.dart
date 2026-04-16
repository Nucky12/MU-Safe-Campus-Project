import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // นำเข้า Firebase Auth
import 'package:cloud_firestore/cloud_firestore.dart'; // นำเข้า Firestore

class ReportHistoryScreen extends StatefulWidget {
  const ReportHistoryScreen({super.key});

  @override
  State<ReportHistoryScreen> createState() => _ReportHistoryScreenState();
}

class _ReportHistoryScreenState extends State<ReportHistoryScreen> {
  List<Map<String, dynamic>> _reports = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadHistoryFromFirebase();
  }

  // --- ฟังก์ชันดึงประวัติจาก Firebase ---
  Future<void> _loadHistoryFromFirebase() async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        setState(() => _isLoading = false);
        return;
      }

      // ดึงข้อมูลจาก Collection 'reports' เฉพาะที่ userId ตรงกับคนที่ล็อกอินอยู่
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('reports')
          .where('userId', isEqualTo: currentUser.uid)
          .get();

      List<Map<String, dynamic>> fetchedReports = [];

      for (var doc in snapshot.docs) {
        var data = doc.data() as Map<String, dynamic>;
        
        // เก็บ Timestamp ไว้ใช้สำหรับเรียงลำดับเวลา (อันใหม่สุดขึ้นก่อน)
        data['sortTime'] = data['createdAt'] != null 
            ? (data['createdAt'] as Timestamp).millisecondsSinceEpoch 
            : 0;
            
        fetchedReports.add(data);
      }

      // เรียงลำดับจากเหตุการณ์ล่าสุดไปเก่าสุด
      fetchedReports.sort((a, b) => b['sortTime'].compareTo(a['sortTime']));

      setState(() {
        _reports = fetchedReports;
        _isLoading = false;
      });

    } catch (e) {
      print("Error loading history: $e");
      setState(() => _isLoading = false);
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
        title: const Text('My Reporting History', style: TextStyle(color: Color(0xFFFFD700), fontWeight: FontWeight.bold)),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4.0),
          child: Container(color: const Color(0xFFFFD700), height: 4.0),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF1D0A45)))
          : _reports.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: _reports.length,
                  itemBuilder: (context, index) {
                    final report = _reports[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: _buildReportCard(report),
                    );
                  },
                ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.history_edu, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'ยังไม่มีประวัติการแจ้งเหตุ',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildReportCard(Map<String, dynamic> report) {
    final imageBase64 = report['image'] as String? ?? '';
    final hasImage = imageBase64.isNotEmpty;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black87),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 120,
              height: 90,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.black54),
              ),
              child: hasImage
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(7),
                      child: Image.memory(
                        base64Decode(imageBase64),
                        fit: BoxFit.cover,
                      ),
                    )
                  : Icon(Icons.image_not_supported, size: 40, color: Colors.grey[600]),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    report['title'] ?? 'ไม่ระบุชื่อ',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFFD700),
                      shadows: [
                        Shadow(offset: Offset(-1, -1), color: Colors.black),
                        Shadow(offset: Offset(1, -1), color: Colors.black),
                        Shadow(offset: Offset(1, 1), color: Colors.black),
                        Shadow(offset: Offset(-1, 1), color: Colors.black),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: Colors.red, size: 16),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          report['location'] ?? '-',
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    report['date'] ?? '-',
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade500, 
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.black54),
                    ),
                    child: Column(
                      children: [
                        Text(report['statusEn'] ?? 'Received', textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                        Text(report['statusTh'] ?? 'รับเรื่องแล้ว', textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 10)),
                      ],
                    ),
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