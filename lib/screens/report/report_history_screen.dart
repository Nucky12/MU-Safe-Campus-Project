import 'package:flutter/material.dart';

class ReportHistoryScreen extends StatelessWidget {
  const ReportHistoryScreen({super.key});

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
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildReportCard(
            title: 'ถนนชำรุด',
            location: 'พื้นถนนบริเวณประตู 4',
            date: '10 March 2026, 14:30 AM',
            statusEn: 'Received',
            statusTh: 'รับเรื่องแล้ว',
            statusColor: Colors.grey.shade500,
            iconData: Icons.broken_image,
          ),
          const SizedBox(height: 16),
          _buildReportCard(
            title: 'ท่อน้ำประปารั่ว',
            location: 'MLC',
            date: '5 March 2026, 10:02 AM',
            statusEn: 'In Progress',
            statusTh: 'กำลังแก้ไข',
            statusColor: const Color(0xFFDCE775), // สีเหลือง
            iconData: Icons.water_drop,
          ),
          const SizedBox(height: 16),
          _buildReportCard(
            title: 'พบคราบงู',
            location: 'สวนสิรีรุกขชาติ',
            date: '9 March 2026, 16:47 AM',
            statusEn: 'Resolved',
            statusTh: 'แก้ไขแล้ว',
            statusColor: const Color(0xFF00E676), // สีเขียว
            iconData: Icons.pest_control,
          ),
        ],
      ),
    );
  }

  Widget _buildReportCard({
    required String title,
    required String location,
    required String date,
    required String statusEn,
    required String statusTh,
    required Color statusColor,
    required IconData iconData,
  }) {
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
            // ช่องใส่รูปภาพ (ใช้ Icon สีเทาแทนชั่วคราว)
            Container(
              width: 120,
              height: 90,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.black54),
              ),
              child: Icon(iconData, size: 40, color: Colors.grey[600]),
            ),
            const SizedBox(width: 12),
            // ข้อมูลด้านขวา
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
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
                          location,
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    date,
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  // ป้ายสถานะ
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.black54),
                    ),
                    child: Column(
                      children: [
                        Text(statusEn, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                        Text(statusTh, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 10)),
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