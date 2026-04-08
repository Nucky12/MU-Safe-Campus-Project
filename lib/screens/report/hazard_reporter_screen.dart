import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class HazardReporterScreen extends StatefulWidget {
  const HazardReporterScreen({super.key});

  @override
  State<HazardReporterScreen> createState() => _HazardReporterScreenState();
}

class _HazardReporterScreenState extends State<HazardReporterScreen> {
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _dateTimeController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _detailsController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    _dateTimeController.dispose();
    _typeController.dispose();
    _detailsController.dispose();
    super.dispose();
  }

  // ฟังก์ชันเลือกรูปภาพ (รับค่าว่าเป็น กล้อง หรือ แกลลอรี่)
  Future<void> _pickImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  // ฟังก์ชันแสดงเมนูเลือกรูปภาพด้านล่างจอ
  void _showImageSourceActionSheet() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('เลือกจากแกลเลอรี่'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('ถ่ายรูป'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
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
        title: const Text('Hazard Reporter', style: TextStyle(color: Color(0xFFFFD700), fontWeight: FontWeight.bold)),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4.0),
          child: Container(color: const Color(0xFFFFD700), height: 4.0),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- ส่วนรูปภาพ ---
            GestureDetector(
              onTap: _showImageSourceActionSheet,
              child: Container(
                height: 250,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  border: Border(bottom: BorderSide(color: const Color(0xFFFFD700), width: 4)),
                ),
                child: _selectedImage != null
                    ? Image.file(
                        _selectedImage!,
                        fit: BoxFit.cover,
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.camera_alt, size: 60, color: Colors.black54),
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.black),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.image, color: Colors.black),
                                SizedBox(width: 8),
                                Text('แตะเพื่อถ่ายรูปหรือเลือกรูปภาพ', style: TextStyle(fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ],
                      ),
              ),
            ),
            
            // --- ส่วนฟอร์มกรอกข้อมูล ---
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('รายงานแจ้งเหตุ', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  
                  _buildLabel('ชื่อ-นามสกุลผู้แจ้ง'),
                  _buildTextField('เช่น นายสิรวิชญ์ น้อยเจริญ', _nameController),
                  
                  const SizedBox(height: 12),
                  _buildLabel('สถานที่'),
                  _buildTextField('เช่น พื้นถนนบริเวณประตู 4', _locationController),
                  
                  const SizedBox(height: 12),
                  _buildLabel('วันเวลาที่พบ'),
                  _buildTextField('เช่น 10 March 2026, 14:30', _dateTimeController),
                  
                  const SizedBox(height: 12),
                  _buildLabel('ประเภทของเหตุ'),
                  _buildTextField('เช่น ถนนชำรุด', _typeController),
                  
                  const SizedBox(height: 12),
                  _buildLabel('รายละเอียดเพิ่มเติม'),
                  TextField(
                    controller: _detailsController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: 'เช่น พบถนนชำรุด พื้นถนนบริเวณประตู 4 เวลา บ่าย 2 โมงครึ่ง',
                      filled: true,
                      fillColor: Colors.grey[300],
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: BorderSide.none),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  // ปุ่ม Send
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // ตรวจสอบว่ากรอกข้อมูลหรือยัง
                        if (_nameController.text.isEmpty || _locationController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('กรุณากรอกข้อมูลให้ครบถ้วน'), backgroundColor: Colors.red),
                          );
                          return;
                        }
                        
                        if (_selectedImage == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('กรุณาแนบรูปภาพประกอบการแจ้งเหตุ'), backgroundColor: Colors.red),
                          );
                          return;
                        }

                        // ถ้าผ่าน ไปหน้าความสำเร็จ
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const HazardSuccessScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4A00E0), // สีม่วงสว่างแบบในดีไซน์
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                      ),
                      icon: const Icon(Icons.send, color: Colors.white),
                      label: const Text('Send', style: TextStyle(color: Colors.white, fontSize: 16)),
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

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
    );
  }

  Widget _buildTextField(String hint, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.grey[300],
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: BorderSide.none),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }
}

// ---------------------------------------------------------
// หน้าจอส่งรายงานสำเร็จ (แยกออกมาเพื่อความสวยงามตามดีไซน์)
// ---------------------------------------------------------
class HazardSuccessScreen extends StatelessWidget {
  const HazardSuccessScreen({super.key});

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
        title: const Text('Hazard Reporter', style: TextStyle(color: Color(0xFFFFD700), fontWeight: FontWeight.bold)),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4.0),
          child: Container(color: const Color(0xFFFFD700), height: 4.0),
        ),
      ),
      body: Column(
        children: [
          // รูปตึกมหิดลด้านบน
          Container(
            height: 200,
            width: double.infinity,
            decoration: const BoxDecoration(
               image: DecorationImage(
                 image: AssetImage('assets/banner.png'), // ใช้รูปแบนเนอร์เดียวกับหน้าแรก
                 fit: BoxFit.cover,
               ),
            ),
          ),
          Container(height: 4, color: const Color(0xFFFFD700)),
          
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // ไอคอนเครื่องหมายถูกสีเขียว
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.green, width: 8),
                    ),
                    child: const Icon(Icons.check, size: 80, color: Colors.green),
                  ),
                  const SizedBox(height: 24),
                  
                  const Text('ส่งรายงานสำเร็จ!', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  
                  const Text(
                    'ขอบคุณสำหรับการแจ้งข้อมูล ตอนนี้ข้อมูลการแจ้งของคุณ\nได้ถูกส่งเข้าไปในระบบเรียบร้อย\nคุณสามารถติดตามสถานะการแจ้งได้ที่\nปุ่มประวัติการแจ้งเหตุ ที่หน้าแรกได้เลยครับ',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, height: 1.5),
                  ),
                  const SizedBox(height: 40),
                  
                  OutlinedButton(
                    onPressed: () {
                      // กลับไปยังหน้าแรกสุด
                      Navigator.popUntil(context, ModalRoute.withName('/main'));
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.black),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                    ),
                    child: const Text('กลับหน้าแรก', style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}