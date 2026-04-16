import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; 
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart'; // นำเข้า Firebase Auth
import 'package:cloud_firestore/cloud_firestore.dart'; // นำเข้า Firestore

class MedicalIdScreen extends StatefulWidget {
  final bool isEmergencyMode; 

  const MedicalIdScreen({super.key, this.isEmergencyMode = false});

  @override
  State<MedicalIdScreen> createState() => _MedicalIdScreenState();
}

class _MedicalIdScreenState extends State<MedicalIdScreen> {
  late bool _isEditing;
  bool _isLoading = false; // ตัวแปรสำหรับโชว์สถานะโหลดข้อมูล

  Uint8List? _imageBytes; 
  final ImagePicker _picker = ImagePicker();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  
  final TextEditingController _bloodDetailController = TextEditingController();
  final TextEditingController _diseaseDetailController = TextEditingController();
  final TextEditingController _drugDetailController = TextEditingController();
  final TextEditingController _foodDetailController = TextEditingController();

  final TextEditingController _emNameController = TextEditingController();
  final TextEditingController _emRelController = TextEditingController();
  final TextEditingController _emAddressController = TextEditingController();
  final TextEditingController _emPhoneController = TextEditingController();

  String _bloodChoice = 'ไม่ทราบ / ไม่เคยตรวจ';
  String _diseaseChoice = 'ไม่มี';
  String _drugChoice = 'ไม่แพ้';
  String _foodChoice = 'ไม่แพ้';

  @override
  void initState() {
    super.initState();
    _isEditing = !widget.isEmergencyMode;
    _fetchData(); // เรียกใช้ฟังก์ชันดึงข้อมูลแบบใหม่
  }

  // --- ฟังก์ชันดึงข้อมูล (Firebase + Local) ---
  Future<void> _fetchData() async {
    setState(() => _isLoading = true);
    final prefs = await SharedPreferences.getInstance();

    // 1. ถ้าอยู่ในโหมดปกติ (ล็อกอินแล้ว) ให้ลองดึงข้อมูลจาก Firebase มาอัปเดตเครื่องก่อน
    if (!widget.isEmergencyMode) {
      try {
        User? currentUser = FirebaseAuth.instance.currentUser;
        if (currentUser != null) {
          DocumentSnapshot doc = await FirebaseFirestore.instance.collection('users').doc(currentUser.uid).get();
          
          if (doc.exists) {
            var data = doc.data() as Map<String, dynamic>;
            // อัปเดตข้อมูลจาก Cloud ลงในเครื่อง (SharedPreferences) เพื่อใช้ตอนฉุกเฉิน
            await prefs.setString('med_name', data['name'] ?? '');
            await prefs.setString('med_phone', data['phone'] ?? '');
            await prefs.setString('med_age', data['age'] ?? '');
            await prefs.setString('med_address', data['address'] ?? '');
            
            await prefs.setString('med_bloodChoice', data['med_bloodChoice'] ?? 'ไม่ทราบ / ไม่เคยตรวจ');
            await prefs.setString('med_bloodDetail', data['med_bloodDetail'] ?? '');
            
            await prefs.setString('med_diseaseChoice', data['med_diseaseChoice'] ?? 'ไม่มี');
            await prefs.setString('med_diseaseDetail', data['med_diseaseDetail'] ?? '');
            
            await prefs.setString('med_drugChoice', data['med_drugChoice'] ?? 'ไม่แพ้');
            await prefs.setString('med_drugDetail', data['med_drugDetail'] ?? '');
            
            await prefs.setString('med_foodChoice', data['med_foodChoice'] ?? 'ไม่แพ้');
            await prefs.setString('med_foodDetail', data['med_foodDetail'] ?? '');

            await prefs.setString('med_emName', data['med_emName'] ?? '');
            await prefs.setString('med_emRel', data['med_emRel'] ?? '');
            await prefs.setString('med_emAddress', data['med_emAddress'] ?? '');
            await prefs.setString('med_emPhone', data['med_emPhone'] ?? '');

            if (data['med_imageBytes'] != null) {
              await prefs.setString('med_imageBytes', data['med_imageBytes']);
            }
          }
        }
      } catch (e) {
        print("Firebase fetch error: $e"); // ปล่อยผ่านไปใช้ข้อมูลเก่าในเครื่อง
      }
    }

    // 2. โหลดข้อมูลจาก SharedPreferences มาโชว์ที่หน้าจอ (ทำงานเสมอทั้งโหมดปกติและฉุกเฉิน)
    setState(() {
      _nameController.text = prefs.getString('med_name') ?? '';
      _phoneController.text = prefs.getString('med_phone') ?? '';
      _ageController.text = prefs.getString('med_age') ?? '';
      _addressController.text = prefs.getString('med_address') ?? '';
      
      _bloodChoice = prefs.getString('med_bloodChoice') ?? 'ไม่ทราบ / ไม่เคยตรวจ';
      _bloodDetailController.text = prefs.getString('med_bloodDetail') ?? '';
      
      _diseaseChoice = prefs.getString('med_diseaseChoice') ?? 'ไม่มี';
      _diseaseDetailController.text = prefs.getString('med_diseaseDetail') ?? '';
      
      _drugChoice = prefs.getString('med_drugChoice') ?? 'ไม่แพ้';
      _drugDetailController.text = prefs.getString('med_drugDetail') ?? '';
      
      _foodChoice = prefs.getString('med_foodChoice') ?? 'ไม่แพ้';
      _foodDetailController.text = prefs.getString('med_foodDetail') ?? '';

      _emNameController.text = prefs.getString('med_emName') ?? '';
      _emRelController.text = prefs.getString('med_emRel') ?? '';
      _emAddressController.text = prefs.getString('med_emAddress') ?? '';
      _emPhoneController.text = prefs.getString('med_emPhone') ?? '';

      String? base64Image = prefs.getString('med_imageBytes');
      if (base64Image != null && base64Image.isNotEmpty) {
        _imageBytes = base64Decode(base64Image);
      }

      if (!widget.isEmergencyMode && _nameController.text.isNotEmpty) {
        _isEditing = false;
      }
      _isLoading = false;
    });
  }

  // --- ฟังก์ชันบันทึกข้อมูล (อัปขึ้น Firebase + เซฟลงเครื่อง) ---
  Future<void> _saveData() async {
    setState(() => _isLoading = true);
    final prefs = await SharedPreferences.getInstance();

    String base64Image = _imageBytes != null ? base64Encode(_imageBytes!) : "";

    // 1. เซฟลงเครื่องเพื่อแบ็คอัป (ทำงานเสมอ)
    await prefs.setString('med_name', _nameController.text.trim());
    await prefs.setString('med_phone', _phoneController.text.trim());
    await prefs.setString('med_age', _ageController.text.trim());
    await prefs.setString('med_address', _addressController.text.trim());
    await prefs.setString('med_bloodChoice', _bloodChoice);
    await prefs.setString('med_bloodDetail', _bloodDetailController.text.trim());
    await prefs.setString('med_diseaseChoice', _diseaseChoice);
    await prefs.setString('med_diseaseDetail', _diseaseDetailController.text.trim());
    await prefs.setString('med_drugChoice', _drugChoice);
    await prefs.setString('med_drugDetail', _drugDetailController.text.trim());
    await prefs.setString('med_foodChoice', _foodChoice);
    await prefs.setString('med_foodDetail', _foodDetailController.text.trim());
    await prefs.setString('med_emName', _emNameController.text.trim());
    await prefs.setString('med_emRel', _emRelController.text.trim());
    await prefs.setString('med_emAddress', _emAddressController.text.trim());
    await prefs.setString('med_emPhone', _emPhoneController.text.trim());
    if (base64Image.isNotEmpty) await prefs.setString('med_imageBytes', base64Image);

    // 2. อัปโหลดขึ้น Firebase (ทำงานเฉพาะตอนไม่ได้อยู่โหมดฉุกเฉิน)
    if (!widget.isEmergencyMode) {
      try {
        User? currentUser = FirebaseAuth.instance.currentUser;
        if (currentUser != null) {
          Map<String, dynamic> medData = {
            'name': _nameController.text.trim(),
            'phone': _phoneController.text.trim(),
            'age': _ageController.text.trim(),
            'address': _addressController.text.trim(),
            'med_bloodChoice': _bloodChoice,
            'med_bloodDetail': _bloodDetailController.text.trim(),
            'med_diseaseChoice': _diseaseChoice,
            'med_diseaseDetail': _diseaseDetailController.text.trim(),
            'med_drugChoice': _drugChoice,
            'med_drugDetail': _drugDetailController.text.trim(),
            'med_foodChoice': _foodChoice,
            'med_foodDetail': _foodDetailController.text.trim(),
            'med_emName': _emNameController.text.trim(),
            'med_emRel': _emRelController.text.trim(),
            'med_emAddress': _emAddressController.text.trim(),
            'med_emPhone': _emPhoneController.text.trim(),
          };
          
          if (base64Image.isNotEmpty) medData['med_imageBytes'] = base64Image;

          // เซฟลง Collection 'users' (เพื่อแชร์ข้อมูลชื่อ-เบอร์กับหน้า Profile)
          await FirebaseFirestore.instance.collection('users').doc(currentUser.uid).set(medData, SetOptions(merge: true));
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('บันทึกลง Cloud ไม่สำเร็จ แต่ข้อมูลถูกบันทึกในเครื่องแล้ว'), backgroundColor: Colors.orange));
      }
    }

    setState(() {
      _isEditing = false;
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _ageController.dispose();
    _addressController.dispose();
    _bloodDetailController.dispose();
    _diseaseDetailController.dispose();
    _drugDetailController.dispose();
    _foodDetailController.dispose();
    _emNameController.dispose();
    _emRelController.dispose();
    _emAddressController.dispose();
    _emPhoneController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final bytes = await image.readAsBytes();
      setState(() => _imageBytes = bytes);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(backgroundColor: Colors.white, body: Center(child: CircularProgressIndicator(color: Color(0xFF1D0A45))));
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: widget.isEmergencyMode ? Colors.red.shade900 : const Color(0xFF1D0A45),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFFFFD700)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(_isEditing ? 'Medical ID Input Form' : 'Medical ID Card', style: const TextStyle(color: Color(0xFFFFD700), fontWeight: FontWeight.bold)),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4.0),
          child: Container(color: const Color(0xFFFFD700), height: 4.0),
        ),
        actions: [
          if (!_isEditing && !widget.isEmergencyMode)
            IconButton(
              icon: const Icon(Icons.edit, color: Color(0xFFFFD700)),
              onPressed: () => setState(() => _isEditing = true),
            ),
        ],
      ),
      body: _isEditing ? _buildInputForm() : _buildMedicalCard(),
    );
  }

  Widget _buildInputForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey[300],
                backgroundImage: _imageBytes != null ? MemoryImage(_imageBytes!) : null,
                child: _imageBytes == null ? const Icon(Icons.camera_alt, size: 40, color: Colors.grey) : null,
              ),
            ),
          ),
          const SizedBox(height: 16),

          _buildLabel('ชื่อ-นามสกุล'),
          _buildTextField(_nameController, 'ชื่อ-นามสกุล'),
          
          _buildLabel('เบอร์โทรติดต่อ'),
          _buildTextField(_phoneController, 'เบอร์โทรติดต่อ', isNumber: true, maxLength: 10),

          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel('อายุ'),
                    _buildTextField(_ageController, 'อายุ', isNumber: true, maxLength: 3),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel('รูปภาพใบหน้า'),
                    InkWell(
                      onTap: _pickImage,
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(4)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.attach_file),
                            const SizedBox(width: 8),
                            Text(_imageBytes != null ? 'เลือกรูปแล้ว' : 'แนบรูปภาพ', style: const TextStyle(fontSize: 12)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          _buildLabel('ที่อยู่ปัจจุบัน'),
          TextField(
            controller: _addressController,
            maxLines: 3,
            decoration: InputDecoration(filled: true, fillColor: Colors.grey[300], border: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: BorderSide.none)),
          ),

          const Divider(height: 32, thickness: 2),

          _buildChoiceSection('หมู่เลือด', ['ทราบหมู่เลือดตัวเอง', 'ไม่ทราบ / ไม่เคยตรวจ'], _bloodChoice, (val) => setState(() => _bloodChoice = val!), detailController: _bloodDetailController, showDetailIf: 'ทราบหมู่เลือดตัวเอง', hint: 'หมู่เลือด'),
          _buildChoiceSection('โรคประจำตัว', ['ไม่มี', 'มี โปรดระบุ', 'ไม่ทราบ'], _diseaseChoice, (val) => setState(() => _diseaseChoice = val!), detailController: _diseaseDetailController, showDetailIf: 'มี โปรดระบุ', hint: 'ระบุโรคประจำตัว'),
          _buildChoiceSection('ประวัติแพ้ยา / สารอื่นๆ', ['ไม่แพ้', 'แพ้ โปรดระบุ', 'ไม่ทราบ'], _drugChoice, (val) => setState(() => _drugChoice = val!), detailController: _drugDetailController, showDetailIf: 'แพ้ โปรดระบุ', hint: 'ระบุชื่อยาที่แพ้'),
          _buildChoiceSection('ประวัติแพ้อาหาร', ['ไม่แพ้', 'แพ้ โปรดระบุ', 'ไม่ทราบ'], _foodChoice, (val) => setState(() => _foodChoice = val!), detailController: _foodDetailController, showDetailIf: 'แพ้ โปรดระบุ', hint: 'ระบุอาหารที่แพ้'),

          const Divider(height: 32, thickness: 2),
          
          _buildLabel('ชื่อ-นามสกุล บุคคลที่ติดต่อได้กรณีฉุกเฉิน'),
          _buildTextField(_emNameController, 'ชื่อ-นามสกุล บุคคลที่ติดต่อได้กรณีฉุกเฉิน'),
          _buildLabel('ความสัมพันธ์ที่เกี่ยวข้อง'),
          _buildTextField(_emRelController, 'ความสัมพันธ์ที่เกี่ยวข้อง'),
          _buildLabel('ที่อยู่ผู้ที่ติดต่อได้'),
          _buildTextField(_emAddressController, 'ที่อยู่ผู้ที่ติดต่อได้'),
          _buildLabel('เบอร์โทรที่สามารถติดต่อ'),
          _buildTextField(_emPhoneController, 'เบอร์โทรที่สามารถติดต่อ', isNumber: true, maxLength: 10),

          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF4A00E0), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25))),
              onPressed: () async {
                if (_nameController.text.trim().isEmpty || _phoneController.text.trim().isEmpty || _ageController.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('กรุณากรอก ชื่อ, เบอร์โทร และอายุ ให้ครบถ้วน'), backgroundColor: Colors.red));
                  return;
                }
                
                String phoneRaw = _phoneController.text.replaceAll(RegExp(r'\D'), '');
                if (!RegExp(r'^0\d{9}$').hasMatch(phoneRaw)) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('เบอร์โทรศัพท์ติดต่อต้องเริ่มต้นด้วย 0 และมี 10 หลัก'), backgroundColor: Colors.red));
                  return;
                }

                if (_emPhoneController.text.isNotEmpty) {
                  String emPhoneRaw = _emPhoneController.text.replaceAll(RegExp(r'\D'), '');
                  if (!RegExp(r'^0\d{9}$').hasMatch(emPhoneRaw)) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('เบอร์โทรผู้ติดต่อฉุกเฉินต้องเริ่มต้นด้วย 0 และมี 10 หลัก'), backgroundColor: Colors.red));
                    return;
                  }
                }

                await _saveData(); // เรียกใช้งานฟังก์ชันที่เซฟทั้ง Cloud และ Local
              },
              icon: const Icon(Icons.send, color: Colors.white),
              label: const Text('Save & Show Card', style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildMedicalCard() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          CircleAvatar(
            radius: 80,
            backgroundColor: Colors.grey[300],
            backgroundImage: _imageBytes != null ? MemoryImage(_imageBytes!) : null,
            child: _imageBytes == null ? const Icon(Icons.person, size: 80, color: Colors.white) : null,
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(_nameController.text.isEmpty ? 'ไม่ระบุชื่อ' : _nameController.text, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              if (!widget.isEmergencyMode)
                IconButton(icon: const Icon(Icons.edit, color: Color(0xFFFFD700)), onPressed: () => setState(() => _isEditing = true)),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(border: Border.all(color: Colors.black), borderRadius: BorderRadius.circular(8)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDisplayRow('อายุ', _ageController.text.isEmpty ? '-' : '${_ageController.text} ปี'),
                _buildDisplayRow('เบอร์โทรติดต่อ', _phoneController.text.isEmpty ? '-' : _phoneController.text),
                _buildDisplayRow('ที่อยู่', _addressController.text.isEmpty ? '-' : _addressController.text),
                _buildDisplayRow('หมู่เลือด', _bloodChoice == 'ทราบหมู่เลือดตัวเอง' ? _bloodDetailController.text : _bloodChoice),
                _buildDisplayRow('โรคประจำตัว', _diseaseChoice == 'มี โปรดระบุ' ? _diseaseDetailController.text : _diseaseChoice),
                _buildDisplayRow('ประวัติแพ้ยา / สารอื่นๆ', _drugChoice == 'แพ้ โปรดระบุ' ? _drugDetailController.text : _drugChoice),
                _buildDisplayRow('ประวัติแพ้อาหาร', _foodChoice == 'แพ้ โปรดระบุ' ? _foodDetailController.text : _foodChoice),
                
                const SizedBox(height: 16),
                const Text('บุคคลที่ติดต่อได้กรณีฉุกเฉิน:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.red)),
                const SizedBox(height: 4),
                _buildDisplayRow('ชื่อ-นามสกุล', _emNameController.text.isEmpty ? '-' : _emNameController.text),
                _buildDisplayRow('ความสัมพันธ์', _emRelController.text.isEmpty ? '-' : _emRelController.text),
                _buildDisplayRow('ที่อยู่ติดต่อได้', _emAddressController.text.isEmpty ? '-' : _emAddressController.text),
                _buildDisplayRow('เบอร์โทรศัพท์', _emPhoneController.text.isEmpty ? '-' : _emPhoneController.text),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0, bottom: 4.0),
      child: Text(text, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint, {bool isNumber = false, int? maxLength}) {
    return TextField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      maxLength: maxLength,
      inputFormatters: isNumber ? [FilteringTextInputFormatter.digitsOnly] : null,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.grey[300],
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: BorderSide.none),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        counterText: "", 
      ),
    );
  }

  Widget _buildChoiceSection(String title, List<String> options, String groupValue, Function(String?) onChanged, {required TextEditingController detailController, required String showDetailIf, required String hint}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(title),
        ...options.map((option) => RadioListTile<String>(
          title: Text(option),
          value: option,
          groupValue: groupValue,
          onChanged: onChanged,
          contentPadding: EdgeInsets.zero,
          dense: true,
          activeColor: Colors.black,
        )),
        if (groupValue == showDetailIf)
          Padding(
            padding: const EdgeInsets.only(left: 32.0, top: 4.0),
            child: _buildTextField(detailController, hint),
          ),
      ],
    );
  }

  Widget _buildDisplayRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(fontSize: 15, color: Colors.black),
          children: [
            TextSpan(text: '$title: ', style: const TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(text: value),
          ],
        ),
      ),
    );
  }
}