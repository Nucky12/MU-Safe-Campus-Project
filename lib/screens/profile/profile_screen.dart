import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // เพิ่มตัวนี้

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // ข้อมูลจำลอง
  String _name = 'นายสิรวิชญ์ น้อยเจริญ';
  String _phone = '089-300-8212';
  String _email = 'sirawit.noy@student.mahidol.ac.th';
  String _studentId = '6787082';
  String _faculty = 'ICT';
  final String _score = '214'; 
  
  bool _showEmergencyInfo = true;

  @override
  void initState() {
    super.initState();
    _loadEmergencySetting(); // โหลดสถานะสวิตช์ตอนเข้ามาหน้าโปรไฟล์
  }

  // ฟังก์ชันดึงค่าปัจจุบัน
  Future<void> _loadEmergencySetting() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _showEmergencyInfo = prefs.getBool('showEmergencyInfo') ?? true;
    });
  }

  // ฟังก์ชันบันทึกค่าลงเครื่อง
  Future<void> _toggleEmergencyInfo(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('showEmergencyInfo', value); // เซฟค่า
    setState(() {
      _showEmergencyInfo = value;
    });
  }

  // ฟังก์ชันไปหน้าแก้ไขข้อมูล
  void _navigateToEditProfile() async {
    final updatedData = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfileScreen(
          currentName: _name, currentPhone: _phone, currentEmail: _email, currentStudentId: _studentId, currentFaculty: _faculty,
        ),
      ),
    );

    if (updatedData != null && updatedData is Map<String, String>) {
      setState(() {
        _name = updatedData['name'] ?? _name;
        _phone = updatedData['phone'] ?? _phone;
        _email = updatedData['email'] ?? _email;
        _studentId = updatedData['studentId'] ?? _studentId;
        _faculty = updatedData['faculty'] ?? _faculty;
      });
    }
  }

  void _logout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('ยืนยันการออกจากระบบ'),
        content: const Text('คุณต้องการออกจากระบบใช่หรือไม่?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('ยกเลิก', style: TextStyle(color: Colors.grey))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
            },
            child: const Text('ออกจากระบบ', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1D0A45),
        automaticallyImplyLeading: false,
        title: const Text('Profile', style: TextStyle(color: Color(0xFFFFD700), fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ส่วนหัวโปรไฟล์ (รูปภาพ, ชื่อ, คะแนน)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 24),
              decoration: const BoxDecoration(
                color: Color(0xFF1D0A45),
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
              ),
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      const CircleAvatar(radius: 50, backgroundColor: Colors.white, child: Icon(Icons.person, size: 60, color: Colors.grey)),
                      Container(
                        decoration: const BoxDecoration(color: Color(0xFFFFD700), shape: BoxShape.circle),
                        padding: const EdgeInsets.all(6),
                        child: const Icon(Icons.camera_alt, size: 20, color: Colors.black),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(_name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(color: const Color(0xFFFFD700), borderRadius: BorderRadius.circular(20)),
                    child: Text('Score: $_score', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                  ),
                ],
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  _buildInfoRow(Icons.phone, 'เบอร์โทรศัพท์', _phone),
                  const Divider(),
                  _buildInfoRow(Icons.email, 'อีเมล์มหาวิทยาลัย', _email),
                  const Divider(),
                  _buildInfoRow(Icons.badge, 'รหัสนักศึกษา/บุคลากร', _studentId),
                  const Divider(),
                  _buildInfoRow(Icons.school, 'คณะ/หน่วยงาน', _faculty),
                  
                  const SizedBox(height: 24),
                  
                  // ส่วนตั้งค่า เปิด-ปิด ข้อมูลฉุกเฉิน (ผูกกับฟังก์ชันเซฟ)
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: SwitchListTile(
                      activeThumbColor: const Color(0xFF1D0A45),
                      title: const Text('Emergency Info', style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: const Text('แสดง Medical ID บนหน้าจอเมื่อเกิดเหตุฉุกเฉิน (ไม่ต้องล็อกอิน)', style: TextStyle(fontSize: 12)),
                      value: _showEmergencyInfo,
                      onChanged: _toggleEmergencyInfo, // เปลี่ยนไปเรียกฟังก์ชันเซฟที่เราสร้างไว้
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: OutlinedButton.icon(
                      onPressed: _navigateToEditProfile,
                      icon: const Icon(Icons.edit, color: Color(0xFF1D0A45)),
                      label: const Text('Edit Profile', style: TextStyle(fontSize: 16, color: Color(0xFF1D0A45), fontWeight: FontWeight.bold)),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFF1D0A45), width: 2),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: _logout,
                      icon: const Icon(Icons.logout, color: Colors.white),
                      label: const Text('Logout', style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey[600]),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------
// หน้าจอสำหรับแก้ไขข้อมูล (Edit Profile) - โค้ดเดิม ไม่มีการเปลี่ยนแปลง
// ---------------------------------------------------------
class EditProfileScreen extends StatefulWidget {
  final String currentName;
  final String currentPhone;
  final String currentEmail;
  final String currentStudentId;
  final String currentFaculty;

  const EditProfileScreen({
    super.key,
    required this.currentName,
    required this.currentPhone,
    required this.currentEmail,
    required this.currentStudentId,
    required this.currentFaculty,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _studentIdController;
  late TextEditingController _facultyController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.currentName);
    _phoneController = TextEditingController(text: widget.currentPhone);
    _emailController = TextEditingController(text: widget.currentEmail);
    _studentIdController = TextEditingController(text: widget.currentStudentId);
    _facultyController = TextEditingController(text: widget.currentFaculty);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _studentIdController.dispose();
    _facultyController.dispose();
    super.dispose();
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
        title: const Text('Edit Profile', style: TextStyle(color: Color(0xFFFFD700), fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            _buildEditField('ชื่อ-นามสกุล', _nameController),
            _buildEditField('เบอร์โทรศัพท์', _phoneController, isNumber: true),
            _buildEditField('อีเมล์มหาวิทยาลัย', _emailController),
            _buildEditField('รหัสนักศึกษา/บุคลากร', _studentIdController),
            _buildEditField('คณะ/หน่วยงาน', _facultyController),
            
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1D0A45),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () {
                  Navigator.pop(context, {
                    'name': _nameController.text,
                    'phone': _phoneController.text,
                    'email': _emailController.text,
                    'studentId': _studentIdController.text,
                    'faculty': _facultyController.text,
                  });
                },
                child: const Text('บันทึกข้อมูล', style: TextStyle(fontSize: 18, color: Color(0xFFFFD700), fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditField(String label, TextEditingController controller, {bool isNumber = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black54)),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            keyboardType: isNumber ? TextInputType.phone : TextInputType.text,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey[200],
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
            ),
          ),
        ],
      ),
    );
  }
}