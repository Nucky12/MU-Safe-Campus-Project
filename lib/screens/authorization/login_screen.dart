import 'package:flutter/material.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Controller สำหรับรับค่าจากช่องกรอกข้อความ
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscureText = true;
  bool _rememberMe = false;
  bool _isEmailLogin = true;

  @override
  void dispose() {
    // คืนค่าหน่วยความจำเมื่อปิดหน้าจอ
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // ส่วนหัว
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 30),
                decoration: const BoxDecoration(
                  color: Color(0xFF1D0A45),
                  border: Border(bottom: BorderSide(color: Color(0xFFFFD700), width: 6)),
                ),
                child: const Center(
                  child: Text(
                    'MU SAFE CAMPUS',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFFFFD700)),
                  ),
                ),
              ),
              
              // ฟอร์มล็อกอิน
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _isEmailLogin ? 'อีเมล์มหาวิทยาลัย' : 'เบอร์โทรศัพท์', 
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _usernameController, // รับค่าข้อมูล
                      keyboardType: _isEmailLogin ? TextInputType.emailAddress : TextInputType.phone,
                      decoration: InputDecoration(
                        hintText: _isEmailLogin ? 'กรอกอีเมล์' : 'กรอกเบอร์โทรศัพท์',
                        filled: true,
                        fillColor: Colors.grey[300],
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: BorderSide.none),
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    const Text('รหัสผ่าน', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _passwordController, // รับค่าข้อมูลรหัสผ่าน
                      obscureText: _obscureText,
                      decoration: InputDecoration(
                        hintText: 'กรอกรหัสผ่าน',
                        filled: true,
                        fillColor: Colors.grey[300],
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: BorderSide.none),
                        suffixIcon: IconButton(
                          icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility, color: Colors.grey),
                          onPressed: () => setState(() => _obscureText = !_obscureText),
                        ),
                      ),
                    ),
                    
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            _isEmailLogin = !_isEmailLogin;
                            // ล้างข้อมูลในช่องกรอกเมื่อสลับโหมด
                            _usernameController.clear(); 
                          });
                        },
                        child: Text(
                          _isEmailLogin ? 'ล็อคอินด้วยเบอร์โทรศัพท์' : 'ล็อคอินด้วยอีเมล์มหาวิทยาลัย',
                          style: const TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
                        ),
                      ),
                    ),

                    Row(
                      children: [
                        Checkbox(
                          value: _rememberMe,
                          onChanged: (value) => setState(() => _rememberMe = value!),
                          activeColor: Colors.black,
                        ),
                        const Text('จดจำฉัน', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1D0A45),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        onPressed: () {
                          // TODO: ใส่ Logic ตรวจสอบอีเมลและรหัสผ่านตรงนี้
                          // ตอนนี้ให้กดแล้วไปหน้าหลักเลย
                          Navigator.pushReplacementNamed(context, '/main');
                        },
                        child: const Text('Login', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFFFFD700))),
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const SignUpScreen()));
                        },
                        child: const Text.rich(
                          TextSpan(
                            text: 'ยังไม่มีบัญชี? ',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            children: [
                              TextSpan(text: 'ลงทะเบียน', style: TextStyle(color: Color(0xFFFFD700))),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}