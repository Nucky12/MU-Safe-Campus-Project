import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  // Controller สำหรับรับค่าจากช่องกรอกข้อมูลต่างๆ
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _acceptTerms = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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
        title: const Text('Create Account', style: TextStyle(color: Color(0xFFFFD700), fontWeight: FontWeight.bold)),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4.0),
          child: Container(color: const Color(0xFFFFD700), height: 4.0),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLabel('ชื่อ - นามสกุล'),
            _buildTextField('กรอกชื่อ - นามสกุล', controller: _nameController),
            const SizedBox(height: 16),
            
            _buildLabel('อีเมล์มหาวิทยาลัยมหิดล'),
            _buildTextField('กรอกอีเมล์มหาวิทยาลัย', controller: _emailController, keyboardType: TextInputType.emailAddress),
            const SizedBox(height: 16),
            
            _buildLabel('เบอร์โทรศัพท์'),
            _buildTextField('กรอกเบอร์โทรศัพท์', controller: _phoneController, keyboardType: TextInputType.phone),
            const SizedBox(height: 16),
            
            _buildLabel('รหัสผ่าน'),
            _buildPasswordField('ตั้งรหัสผ่าน', _passwordController, _obscurePassword, () => setState(() => _obscurePassword = !_obscurePassword)),
            const SizedBox(height: 16),
            
            _buildLabel('ยืนยันรหัสผ่าน'),
            _buildPasswordField('ยืนยันรหัสผ่านอีกครั้ง', _confirmPasswordController, _obscureConfirmPassword, () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword)),
            const SizedBox(height: 16),
            
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Checkbox(
                  value: _acceptTerms,
                  onChanged: (value) => setState(() => _acceptTerms = value!),
                  activeColor: Colors.black,
                ),
                const Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: Text('ฉันยอมรับข้อกำหนดในการให้บริการ\nและนโยบายความเป็นส่วนตัว', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1D0A45),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () {
                  // TODO: ตรวจสอบความถูกต้องของข้อมูล (Validation) และบันทึก
                  
                  // กลับไปหน้า Login
                  Navigator.pop(context);
                },
                child: const Text('Sign up', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFFFFD700))),
              ),
            ),
            const SizedBox(height: 16),
            
            Center(
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Text.rich(
                  TextSpan(
                    text: 'มีบัญชีอยู่แล้ว? ',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    children: [
                      TextSpan(text: 'เข้าสู่ระบบ', style: TextStyle(color: Color(0xFFFFD700))),
                    ],
                  ),
                ),
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
      child: Text(text, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
    );
  }

  // เพิ่ม parameter 'controller' ให้ TextField รับค่าได้
  Widget _buildTextField(String hint, {required TextEditingController controller, TextInputType keyboardType = TextInputType.text}) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.grey[300],
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: BorderSide.none),
      ),
    );
  }

  // เพิ่ม parameter 'controller' ให้ TextField รับค่าได้
  Widget _buildPasswordField(String hint, TextEditingController controller, bool isObscure, VoidCallback toggleVisibility) {
    return TextField(
      controller: controller,
      obscureText: isObscure,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.grey[300],
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: BorderSide.none),
        suffixIcon: IconButton(
          icon: Icon(isObscure ? Icons.visibility_off : Icons.visibility, color: Colors.grey),
          onPressed: toggleVisibility,
        ),
      ),
    );
  }
}