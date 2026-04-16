import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
<<<<<<< HEAD
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
=======
import 'package:firebase_auth/firebase_auth.dart'; // นำเข้า Firebase Auth
import 'package:cloud_firestore/cloud_firestore.dart'; // นำเข้า Firestore
>>>>>>> 474e6246fff97eb4768d1411943f8974ff2db20f

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _name = '';
  String _phone = '-';
  String _email = '-';
  String _studentId = '-';
  String _faculty = '-';
  int _totalScore = 0;
  bool _showEmergencyInfo = false;
<<<<<<< HEAD
  bool _isLoadingAPI = true;
=======
  bool _isLoadingAPI = true; // แอนิเมชันโหลดข้อมูล
>>>>>>> 474e6246fff97eb4768d1411943f8974ff2db20f
  
  Uint8List? _imageBytes;
  final ImagePicker _picker = ImagePicker();
  final Color _iconYellow = const Color(0xFFD4E157);

  @override
  void initState() {
    super.initState();
<<<<<<< HEAD
    _fetchProfileFromFirebase();
=======
    _fetchProfileFromFirebase(); // เรียกใช้ฟังก์ชันโหลดข้อมูลจาก Firebase
>>>>>>> 474e6246fff97eb4768d1411943f8974ff2db20f
  }

  // --- โหลดข้อมูลจาก Firebase ---
  Future<void> _fetchProfileFromFirebase() async {
    setState(() => _isLoadingAPI = true);
    final prefs = await SharedPreferences.getInstance();

    try {
<<<<<<< HEAD
      User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
=======
      // 1. ดึง UID ของผู้ใช้ที่กำลังล็อกอินอยู่
      User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        // 2. ดึงข้อมูลจากกล่อง (Document) ของผู้ใช้คนนั้นใน Firestore
>>>>>>> 474e6246fff97eb4768d1411943f8974ff2db20f
        DocumentSnapshot doc = await FirebaseFirestore.instance.collection('users').doc(currentUser.uid).get();

        if (doc.exists) {
          var data = doc.data() as Map<String, dynamic>;
          setState(() {
            _name = data['name'] ?? '';
            _phone = data['phone'] ?? '-';
            _email = data['email'] ?? '-';
            _studentId = data['studentId'] ?? '-';
            _faculty = data['faculty'] ?? '-';
          });

          // แบ็คอัปข้อมูลลงเครื่องเผื่อโหมด Offline
          await prefs.setString('med_name', _name);
          await prefs.setString('med_phone', _phone);
          await prefs.setString('med_email', _email);
          await prefs.setString('med_studentId', _studentId);
          await prefs.setString('med_faculty', _faculty);
<<<<<<< HEAD
        } else {
          // 🛑 [ส่วนที่แก้] ถ้าเป็นผู้ใช้ใหม่ ไม่มีข้อมูลในเน็ต ให้ลบข้อมูลเก่าในเครื่องทิ้ง 🛑
          await prefs.remove('med_name');
          await prefs.remove('med_phone');
          await prefs.remove('med_email');
          await prefs.remove('med_studentId');
          await prefs.remove('med_faculty');
          await prefs.remove('med_imageBytes');
          
          setState(() {
            _name = 'ผู้ใช้งานใหม่';
            _phone = '-';
            _email = currentUser.email ?? '-';
            _studentId = '-';
            _faculty = '-';
            _imageBytes = null;
          });
=======
>>>>>>> 474e6246fff97eb4768d1411943f8974ff2db20f
        }
      }
    } catch (e) {
      // หากเน็ตหลุดหรือมีปัญหา ให้ดึงข้อมูลเก่าจากในเครื่องมาแสดง
      setState(() {
        _name = prefs.getString('med_name') ?? '';
        _phone = prefs.getString('med_phone') ?? '-';
        _email = prefs.getString('med_email') ?? '-';
        _studentId = prefs.getString('med_studentId') ?? '-';
        _faculty = prefs.getString('med_faculty') ?? '-';
      });
    }

    _calculateTotalScore(prefs); // ดึงคะแนน Quiz จากในเครื่อง

    setState(() {
      _showEmergencyInfo = prefs.getBool('showEmergencyInfo') ?? false;
      String? base64Image = prefs.getString('med_imageBytes');
      if (base64Image != null && base64Image.isNotEmpty) {
        _imageBytes = base64Decode(base64Image);
      }
      _isLoadingAPI = false;
    });
  }

  void _calculateTotalScore(SharedPreferences prefs) {
    int scoreSum = 0;
    List<String> categories = ['Basic First Aid', 'CPR & AED', 'Fire Safety', 'Campus Safety', 'Wildlife & Animal', 'Emergency Protocols'];
    for (String cat in categories) {
      for (int i = 1; i <= 5; i++) {
        scoreSum += prefs.getInt("score_${cat}_Quiz $i") ?? 0;
      }
    }
    setState(() => _totalScore = scoreSum);
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final bytes = await image.readAsBytes();
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('med_imageBytes', base64Encode(bytes));
      setState(() => _imageBytes = bytes);
    }
  }

  Future<void> _toggleEmergencyInfo(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('showEmergencyInfo', value);
    setState(() => _showEmergencyInfo = value);
  }

  void _navigateToEditProfile() async {
    await Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfileScreen(
      currentName: _name, currentPhone: _phone, currentEmail: _email, currentStudentId: _studentId, currentFaculty: _faculty)));
    _fetchProfileFromFirebase(); // กลับมาแล้วโหลดข้อมูลใหม่
  }

  void _logout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('ยืนยันการออกจากระบบ'),
        content: const Text('คุณต้องการออกจากระบบใช่หรือไม่?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('ยกเลิก')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
<<<<<<< HEAD
              // 🛑 [ส่วนที่แก้] ล้างข้อมูลโปรไฟล์ในเครื่องทิ้งก่อน Logout 🛑
              final prefs = await SharedPreferences.getInstance();
              await prefs.remove('med_name');
              await prefs.remove('med_phone');
              await prefs.remove('med_email');
              await prefs.remove('med_studentId');
              await prefs.remove('med_faculty');
              await prefs.remove('med_imageBytes');

=======
>>>>>>> 474e6246fff97eb4768d1411943f8974ff2db20f
              // ออกจากระบบผ่าน Firebase
              await FirebaseAuth.instance.signOut(); 
              if (context.mounted) Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
            },
            child: const Text('ออกจากระบบ', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
=======
    // ระหว่างรอโหลดข้อมูลจากเซิร์ฟเวอร์
>>>>>>> 474e6246fff97eb4768d1411943f8974ff2db20f
    if (_isLoadingAPI) {
      return const Scaffold(backgroundColor: Colors.white, body: Center(child: CircularProgressIndicator(color: Color(0xFF1D0A45))));
    }

<<<<<<< HEAD
    bool hasName = _name.isNotEmpty && _name != 'ยังไม่ได้ระบุชื่อ' && _name != 'ผู้ใช้งานใหม่';
=======
    bool hasName = _name.isNotEmpty && _name != 'ยังไม่ได้ระบุชื่อ';
>>>>>>> 474e6246fff97eb4768d1411943f8974ff2db20f

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1D0A45),
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios, color: Color(0xFFFFD700)), onPressed: () => Navigator.pop(context)),
        title: const Text('User Profile', style: TextStyle(color: Color(0xFFFFD700), fontWeight: FontWeight.bold, fontSize: 26)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // --- 1. ส่วน Header และ รูปโปรไฟล์ ---
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.bottomCenter,
              children: [
                Container(height: 90, decoration: const BoxDecoration(color: Color(0xFF1D0A45), borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)))),
                Positioned(
                  bottom: -60,
                  child: GestureDetector(
                    onTap: _pickImage,
                    child: CircleAvatar(
                      radius: 66, backgroundColor: Colors.black87,
                      child: CircleAvatar(radius: 65, backgroundColor: Colors.grey[200], backgroundImage: _imageBytes != null ? MemoryImage(_imageBytes!) : null, child: _imageBytes == null ? const Icon(Icons.person_outline, size: 90, color: Colors.black) : null),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 70),
            
            // --- 2. ส่วนชื่อและไอคอน Verified ---
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(hasName ? _name : 'User', style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
                if (hasName) ...[const SizedBox(width: 8), const Icon(Icons.check_box, color: Colors.green, size: 28)]
              ],
            ),
            const SizedBox(height: 20),
            
<<<<<<< HEAD
            // --- 3. ส่วน Card Grid ---
=======
            // --- 3. ส่วน Card Grid (ออกแบบยืดหยุ่นป้องกัน Overflow) ---
>>>>>>> 474e6246fff97eb4768d1411943f8974ff2db20f
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(child: _buildScoreCard()),
                        const SizedBox(width: 12),
                        Expanded(child: _buildInfoCard(Icons.phone, 'Phone Number', _phone)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(child: _buildInfoCard(Icons.person, 'Full Name', hasName ? _name : '-')),
                        const SizedBox(width: 12),
                        Expanded(child: _buildInfoCard(Icons.email, 'Email', _email)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(child: _buildInfoCard(Icons.badge, 'Student ID', _studentId)),
                        const SizedBox(width: 12),
                        Expanded(child: _buildInfoCard(Icons.domain, 'Faculty', _faculty)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(child: _buildEditCard()),
                        const SizedBox(width: 12),
                        Expanded(child: _buildToggleCard()),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildLogoutCard(),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      decoration: BoxDecoration(color: Colors.white, border: Border.all(color: Colors.grey.shade500), borderRadius: BorderRadius.circular(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Total User Points', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 13)),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(child: FittedBox(fit: BoxFit.scaleDown, child: Text('$_totalScore', style: const TextStyle(fontSize: 34, fontWeight: FontWeight.w400)))),
              const SizedBox(width: 8),
              Icon(Icons.stars, color: _iconYellow, size: 36),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildInfoCard(IconData icon, String title, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      decoration: BoxDecoration(color: Colors.white, border: Border.all(color: Colors.grey.shade500), borderRadius: BorderRadius.circular(8)),
      child: Row(
        children: [
          Icon(icon, color: _iconYellow, size: 36),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(title, style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 13)),
                const SizedBox(height: 4),
                Text(value.isEmpty ? '-' : value, style: const TextStyle(fontSize: 13, color: Colors.black), maxLines: 2, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditCard() {
    return GestureDetector(
      onTap: _navigateToEditProfile,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(color: Colors.white, border: Border.all(color: Colors.grey.shade500), borderRadius: BorderRadius.circular(8)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Edit Profile', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            Icon(Icons.edit, color: _iconYellow, size: 28),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(color: Colors.white, border: Border.all(color: Colors.grey.shade500), borderRadius: BorderRadius.circular(8)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Expanded(child: Padding(padding: EdgeInsets.only(left: 8.0), child: Text('Emergency\nInfo', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, height: 1.2)))),
          Transform.scale(
            scale: 0.85,
            child: Switch(value: _showEmergencyInfo, onChanged: _toggleEmergencyInfo, activeColor: Colors.white, activeTrackColor: Colors.green, inactiveThumbColor: Colors.white, inactiveTrackColor: Colors.grey.shade300),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutCard() {
    return GestureDetector(
      onTap: _logout,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(color: Colors.white, border: Border.all(color: Colors.grey.shade500), borderRadius: BorderRadius.circular(8)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Logout', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            const SizedBox(width: 8),
            Icon(Icons.exit_to_app, color: _iconYellow, size: 28),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------
// หน้าแก้ไขโปรไฟล์ (บันทึกข้อมูลขึ้น Firebase)
// ---------------------------------------------------------
class EditProfileScreen extends StatefulWidget {
  final String currentName, currentPhone, currentEmail, currentStudentId, currentFaculty;
  const EditProfileScreen({super.key, required this.currentName, required this.currentPhone, required this.currentEmail, required this.currentStudentId, required this.currentFaculty});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nameController, _phoneController, _emailController, _studentIdController, _facultyController;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
<<<<<<< HEAD
    _nameController = TextEditingController(text: widget.currentName == 'ยังไม่ได้ระบุชื่อ' || widget.currentName == 'ผู้ใช้งานใหม่' ? '' : widget.currentName);
=======
    _nameController = TextEditingController(text: widget.currentName == 'ยังไม่ได้ระบุชื่อ' ? '' : widget.currentName);
>>>>>>> 474e6246fff97eb4768d1411943f8974ff2db20f
    _phoneController = TextEditingController(text: widget.currentPhone == '-' ? '' : widget.currentPhone);
    _emailController = TextEditingController(text: widget.currentEmail == '-' ? '' : widget.currentEmail);
    _studentIdController = TextEditingController(text: widget.currentStudentId == '-' ? '' : widget.currentStudentId);
    _facultyController = TextEditingController(text: widget.currentFaculty == '-' ? '' : widget.currentFaculty);
  }

  Future<void> _saveData() async {
    String emailText = _emailController.text.trim();
    String phoneText = _phoneController.text.trim();

    // 1. Validation 
    if (emailText.isNotEmpty && emailText != '-') {
      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(emailText)) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('รูปแบบอีเมลไม่ถูกต้อง'), backgroundColor: Colors.red));
        return; 
      }
    }
    if (phoneText.isNotEmpty && phoneText != '-') {
      String phoneRaw = phoneText.replaceAll(RegExp(r'\D'), ''); 
      if (!RegExp(r'^0\d{9}$').hasMatch(phoneRaw)) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('เบอร์ต้องขึ้นต้นด้วย 0 และมี 10 หลัก'), backgroundColor: Colors.red));
        return; 
      }
    }

    setState(() => _isSaving = true);

    try {
<<<<<<< HEAD
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
=======
      // 2. ดึง UID ผู้ใช้งานและอัปเดตลง Firestore
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        // ใช้ SetOptions(merge: true) เพื่อให้เขียนทับเฉพาะฟิลด์ที่มีการแก้ไข
>>>>>>> 474e6246fff97eb4768d1411943f8974ff2db20f
        await FirebaseFirestore.instance.collection('users').doc(currentUser.uid).set({
          'name': _nameController.text.trim(),
          'phone': phoneText,
          'email': emailText,
          'studentId': _studentIdController.text.trim(),
          'faculty': _facultyController.text.trim()
        }, SetOptions(merge: true));

<<<<<<< HEAD
=======
        // 3. แบ็คอัปข้อมูลลงเครื่อง
>>>>>>> 474e6246fff97eb4768d1411943f8974ff2db20f
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('med_name', _nameController.text.trim());
        await prefs.setString('med_phone', phoneText);
        await prefs.setString('med_email', emailText);
        await prefs.setString('med_studentId', _studentIdController.text.trim());
        await prefs.setString('med_faculty', _facultyController.text.trim());

        if (mounted) Navigator.pop(context);
      }
    } catch (e) {
<<<<<<< HEAD
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('เกิดข้อผิดพลาดในการบันทึกข้อมูล'), backgroundColor: Colors.red));
=======
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('เกิดข้อผิดพลาดในการบันทึกข้อมูลบนเซิร์ฟเวอร์'), backgroundColor: Colors.red));
>>>>>>> 474e6246fff97eb4768d1411943f8974ff2db20f
    }
    
    setState(() => _isSaving = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1D0A45), 
        title: const Text('Edit Profile', style: TextStyle(color: Color(0xFFFFD700), fontWeight: FontWeight.bold)),
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios, color: Color(0xFFFFD700)), onPressed: () => Navigator.pop(context)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            _buildEditField('ชื่อ-นามสกุล', _nameController),
            _buildEditField('เบอร์โทรศัพท์', _phoneController, isNumber: true),
<<<<<<< HEAD
            _buildEditField('อีเมล', _emailController),
=======
            _buildEditField('อีเมลมหาวิทยาลัย', _emailController),
>>>>>>> 474e6246fff97eb4768d1411943f8974ff2db20f
            _buildEditField('รหัสนักศึกษา/บุคลากร', _studentIdController),
            _buildEditField('คณะ/หน่วยงาน', _facultyController),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1D0A45), minimumSize: const Size(double.infinity, 55), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
              onPressed: _isSaving ? null : _saveData,
              child: _isSaving 
                  ? const CircularProgressIndicator(color: Color(0xFFFFD700))
                  : const Text('บันทึกข้อมูล', style: TextStyle(color: Color(0xFFFFD700), fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditField(String label, TextEditingController controller, {bool isNumber = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            keyboardType: isNumber ? TextInputType.phone : TextInputType.text,
            maxLength: isNumber ? 10 : null,
            inputFormatters: isNumber ? [FilteringTextInputFormatter.digitsOnly] : null,
            decoration: InputDecoration(
              filled: true, fillColor: Colors.grey[100], 
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              counterText: "", 
            ),
          ),
        ],
      ),
    );
  }
}