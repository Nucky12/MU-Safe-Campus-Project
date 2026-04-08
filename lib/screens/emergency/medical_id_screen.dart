import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class MedicalIdScreen extends StatefulWidget {
  const MedicalIdScreen({super.key});

  @override
  State<MedicalIdScreen> createState() => _MedicalIdScreenState();
}

class _MedicalIdScreenState extends State<MedicalIdScreen> {
  bool _isEditing = true; // ตัวแปรสลับโหมด: true = หน้ากรอกฟอร์ม, false = หน้าแสดงบัตร

  // ตัวแปรเก็บรูปภาพ
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  // Controllers สำหรับฟิลด์ข้อมูล
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  
  // Controllers สำหรับตัวเลือกที่มีการระบุเพิ่มเติม
  final TextEditingController _bloodDetailController = TextEditingController();
  final TextEditingController _diseaseDetailController = TextEditingController();
  final TextEditingController _drugDetailController = TextEditingController();
  final TextEditingController _foodDetailController = TextEditingController();

  // ข้อมูลฉุกเฉิน
  final TextEditingController _emNameController = TextEditingController();
  final TextEditingController _emRelController = TextEditingController();
  final TextEditingController _emAddressController = TextEditingController();
  final TextEditingController _emPhoneController = TextEditingController();

  // ตัวแปรเก็บค่า Radio Button
  String _bloodChoice = 'ไม่ทราบ';
  String _diseaseChoice = 'ไม่มี';
  String _drugChoice = 'ไม่แพ้';
  String _foodChoice = 'ไม่แพ้';

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
      setState(() {
        _selectedImage = File(image.path);
      });
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
        title: const Text('Medical ID', style: TextStyle(color: Color(0xFFFFD700), fontWeight: FontWeight.bold)),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4.0),
          child: Container(color: const Color(0xFFFFD700), height: 4.0),
        ),
      ),
      body: _isEditing ? _buildInputForm() : _buildMedicalCard(),
    );
  }

  // ==========================================
  // ส่วนที่ 1: หน้าฟอร์มกรอกข้อมูล
  // ==========================================
  Widget _buildInputForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Medical ID Input Form', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1D0A45))),
          const SizedBox(height: 16),
          
          _buildLabel('ชื่อ-นามสกุล'),
          _buildTextField(_nameController, 'เช่น นายสิรวิชญ์ น้อยเจริญ'),
          
          _buildLabel('เบอร์โทรติดต่อ'),
          _buildTextField(_phoneController, 'เบอร์โทรศัพท์', isNumber: true),

          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel('อายุ'),
                    _buildTextField(_ageController, 'อายุ', isNumber: true),
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
                            Text(_selectedImage != null ? 'เลือกรูปแล้ว' : 'แนบรูปภาพ'),
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

          _buildChoiceSection('หมู่เลือด', ['ทราบหมู่เลือดตัวเอง', 'ไม่ทราบ'], _bloodChoice, (val) => setState(() => _bloodChoice = val!), detailController: _bloodDetailController, showDetailIf: 'ทราบหมู่เลือดตัวเอง', hint: 'ระบุหมู่เลือด เช่น A'),
          _buildChoiceSection('โรคประจำตัว', ['ไม่มี', 'มี โปรดระบุ', 'ไม่ทราบ'], _diseaseChoice, (val) => setState(() => _diseaseChoice = val!), detailController: _diseaseDetailController, showDetailIf: 'มี โปรดระบุ'),
          _buildChoiceSection('ประวัติแพ้ยา / สารอื่นๆ', ['ไม่แพ้', 'แพ้ โปรดระบุ', 'ไม่ทราบ'], _drugChoice, (val) => setState(() => _drugChoice = val!), detailController: _drugDetailController, showDetailIf: 'แพ้ โปรดระบุ'),
          _buildChoiceSection('ประวัติแพ้อาหาร', ['ไม่แพ้', 'แพ้ โปรดระบุ', 'ไม่ทราบ'], _foodChoice, (val) => setState(() => _foodChoice = val!), detailController: _foodDetailController, showDetailIf: 'แพ้ โปรดระบุ'),

          const Divider(height: 32, thickness: 2),
          const Text('ข้อมูลผู้ติดต่อฉุกเฉิน', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),

          _buildLabel('ชื่อ-นามสกุล บุคคลที่ติดต่อได้'),
          _buildTextField(_emNameController, 'ชื่อผู้ติดต่อฉุกเฉิน'),
          _buildLabel('ความสัมพันธ์ที่เกี่ยวข้อง'),
          _buildTextField(_emRelController, 'เช่น บิดา, มารดา, พี่ชาย'),
          _buildLabel('ที่อยู่ผู้ที่ติดต่อได้'),
          _buildTextField(_emAddressController, 'ที่อยู่'),
          _buildLabel('เบอร์โทรที่สามารถติดต่อ'),
          _buildTextField(_emPhoneController, 'เบอร์โทรศัพท์', isNumber: true),

          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF4A00E0), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
              onPressed: () {
                if (_nameController.text.isEmpty || _phoneController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('กรุณากรอกชื่อและเบอร์โทรศัพท์'), backgroundColor: Colors.red));
                  return;
                }
                setState(() => _isEditing = false); // สลับไปหน้าโชว์บัตร
              },
              child: const Text('Save / Show Card', style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  // ==========================================
  // ส่วนที่ 2: หน้าแสดงบัตร Medical ID
  // ==========================================
  Widget _buildMedicalCard() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          // รูปโปรไฟล์และชื่อ
          Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 70,
                  backgroundColor: Colors.grey[300],
                  backgroundImage: _selectedImage != null ? FileImage(_selectedImage!) : null,
                  child: _selectedImage == null ? const Icon(Icons.person, size: 80, color: Colors.white) : null,
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(_nameController.text, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    IconButton(
                      icon: const Icon(Icons.edit, color: Color(0xFFFFD700)),
                      onPressed: () => setState(() => _isEditing = true), // สลับกลับไปหน้าแก้ไข
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          
          // กล่องข้อมูล
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDisplayRow('อายุ', '${_ageController.text} ปี'),
                _buildDisplayRow('เบอร์โทรติดต่อ', _phoneController.text),
                _buildDisplayRow('ที่อยู่', _addressController.text),
                _buildDisplayRow('หมู่เลือด', _bloodChoice == 'ทราบหมู่เลือดตัวเอง' ? _bloodDetailController.text : _bloodChoice),
                _buildDisplayRow('โรคประจำตัว', _diseaseChoice == 'มี โปรดระบุ' ? _diseaseDetailController.text : _diseaseChoice),
                _buildDisplayRow('ประวัติแพ้ยา / สารอื่นๆ', _drugChoice == 'แพ้ โปรดระบุ' ? _drugDetailController.text : _drugChoice),
                _buildDisplayRow('ประวัติแพ้อาหาร', _foodChoice == 'แพ้ โปรดระบุ' ? _foodDetailController.text : _foodChoice),
                
                const Divider(height: 24, color: Colors.black),
                const Text('ข้อมูลผู้ติดต่อฉุกเฉิน:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 8),
                _buildDisplayRow('ชื่อ-นามสกุล', _emNameController.text),
                _buildDisplayRow('ความสัมพันธ์', _emRelController.text),
                _buildDisplayRow('ที่อยู่', _emAddressController.text),
                _buildDisplayRow('เบอร์โทร', _emPhoneController.text),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // Widgets ช่วยเหลือ
  // ==========================================
  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0, bottom: 4.0),
      child: Text(text, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint, {bool isNumber = false}) {
    return TextField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.phone : TextInputType.text,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.grey[300],
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: BorderSide.none),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      ),
    );
  }

  Widget _buildChoiceSection(String title, List<String> options, String groupValue, Function(String?) onChanged, {required TextEditingController detailController, required String showDetailIf, String? hint}) {
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
        )),
        if (groupValue == showDetailIf)
          Padding(
            padding: const EdgeInsets.only(left: 32.0, top: 4.0),
            child: _buildTextField(detailController, hint ?? 'โปรดระบุรายละเอียด'),
          ),
      ],
    );
  }

  Widget _buildDisplayRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(fontSize: 15, color: Colors.black),
          children: [
            TextSpan(text: '$title: ', style: const TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(text: value.isEmpty ? '-' : value),
          ],
        ),
      ),
    );
  }
}