import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // นำเข้า Firebase Auth
import 'package:cloud_firestore/cloud_firestore.dart'; // นำเข้า Firestore Database

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _acceptTerms = false;
  bool _isLoading = false; 

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
            
            _buildLabel('อีเมล'),
            _buildTextField('กรอกอีเมล', controller: _emailController, keyboardType: TextInputType.emailAddress),
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
            
            // --- ปุ่ม Sign Up (Firebase) ---
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1D0A45),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: _isLoading ? null : () async {
                  
                  // 1. Validation (ตรวจสอบข้อมูล)
                  if (_nameController.text.trim().isEmpty || 
                      _emailController.text.trim().isEmpty || 
                      _phoneController.text.trim().isEmpty || 
                      _passwordController.text.trim().isEmpty || 
                      _confirmPasswordController.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('กรุณากรอกข้อมูลให้ครบทุกช่อง'), backgroundColor: Colors.red));
                    return;
                  }

                  if (RegExp(r'[0-9]').hasMatch(_nameController.text.trim())) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('ชื่อ-นามสกุล ต้องไม่มีตัวเลขผสมอยู่'), backgroundColor: Colors.red));
                    return;
                  }

                  final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                  if (!emailRegex.hasMatch(_emailController.text.trim())) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('รูปแบบอีเมลไม่ถูกต้อง (ต้องมี @)'), backgroundColor: Colors.red));
                    return;
                  }

                  String phoneRaw = _phoneController.text.replaceAll(RegExp(r'\D'), ''); 
                  if (!RegExp(r'^0\d{9}$').hasMatch(phoneRaw)) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('เบอร์โทรศัพท์ต้องเริ่มต้นด้วย 0 และมี 10 หลัก'), backgroundColor: Colors.red));
                    return;
                  }

                  if (_passwordController.text != _confirmPasswordController.text) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('รหัสผ่านไม่ตรงกัน กรุณาตรวจสอบอีกครั้ง'), backgroundColor: Colors.red));
                    return;
                  }

                  if (!_acceptTerms) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('กรุณากดยอมรับข้อกำหนดและนโยบายความเป็นส่วนตัว'), backgroundColor: Colors.red));
                    return;
                  }

                  // 2. สมัครสมาชิกผ่าน Firebase
                  setState(() => _isLoading = true);

                  try {
                    // สร้างบัญชีผู้ใช้ (ใช้ Authentication)
                    UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                      email: _emailController.text.trim(),
                      password: _passwordController.text,
                    );

                    // เก็บข้อมูลโปรไฟล์ลงฐานข้อมูล (ใช้ Firestore)
                    await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
                      'name': _nameController.text.trim(),
                      'email': _emailController.text.trim(),
                      'phone': phoneRaw,
                      'role': 'student',
                      'createdAt': FieldValue.serverTimestamp(),
                    });

                    setState(() => _isLoading = false);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('ลงทะเบียนสำเร็จ! กรุณาเข้าสู่ระบบ'), backgroundColor: Colors.green));
                      Navigator.pop(context); // กลับไปหน้า Login
                    }

                  } on FirebaseAuthException catch (e) {
                    setState(() => _isLoading = false);
                    String errorMsg = 'เกิดข้อผิดพลาดในการลงทะเบียน';
                    if (e.code == 'weak-password') {
                      errorMsg = 'รหัสผ่านอ่อนเกินไป (ต้อง 6 ตัวอักษรขึ้นไป)';
                    } else if (e.code == 'email-already-in-use') {
                      errorMsg = 'อีเมลนี้ถูกใช้งานไปแล้ว';
                    }
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorMsg), backgroundColor: Colors.red));
                  } catch (e) {
                    setState(() => _isLoading = false);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('เกิดข้อผิดพลาดในการเชื่อมต่อเซิร์ฟเวอร์'), backgroundColor: Colors.red));
                  }
                },
                child: _isLoading 
                    ? const CircularProgressIndicator(color: Color(0xFFFFD700))
                    : const Text('Sign up', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFFFFD700))),
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