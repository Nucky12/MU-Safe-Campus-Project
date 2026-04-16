import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart'; // นำเข้า Firebase Auth
import 'package:cloud_firestore/cloud_firestore.dart'; // นำเข้า Firestore

import 'signup_screen.dart';
import '../emergency/medical_id_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscureText = true;
  bool _rememberMe = false;
  bool _isEmailLogin = true;
  bool _showEmergencyButton = true; 
  bool _isLoading = false; 

  @override
  void initState() {
    super.initState();
    _loadSettings(); 
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _showEmergencyButton = prefs.getBool('showEmergencyInfo') ?? true;
      _rememberMe = prefs.getBool('rememberMe') ?? false;
      if (_rememberMe) {
        _isEmailLogin = prefs.getBool('saved_is_email') ?? true;
        _usernameController.text = prefs.getString('saved_username') ?? '';
      }
    });
  }

  @override
  void dispose() {
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
              // --- Header ---
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 30),
                decoration: const BoxDecoration(
                  color: Color(0xFF1D0A45),
                  border: Border(bottom: BorderSide(color: Color(0xFFFFD700), width: 6)),
                ),
                child: const Center(
                  child: Text('MU SAFE CAMPUS', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFFFFD700))),
                ),
              ),
              
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_isEmailLogin ? 'อีเมล' : 'เบอร์โทรศัพท์', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _usernameController,
                      keyboardType: _isEmailLogin ? TextInputType.emailAddress : TextInputType.phone,
                      decoration: InputDecoration(
                        hintText: _isEmailLogin ? 'กรอกอีเมล' : 'กรอกเบอร์โทรศัพท์',
                        filled: true, fillColor: Colors.grey[300],
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: BorderSide.none),
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    const Text('รหัสผ่าน', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _passwordController,
                      obscureText: _obscureText,
                      decoration: InputDecoration(
                        hintText: 'กรอกรหัสผ่าน',
                        filled: true, fillColor: Colors.grey[300],
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
                            if (!_rememberMe) _usernameController.clear(); 
                          });
                        },
                        child: Text(_isEmailLogin ? 'เข้าสู่ระบบด้วยเบอร์โทรศัพท์' : 'เข้าสู่ระบบด้วยอีเมล', style: const TextStyle(color: Colors.blue, decoration: TextDecoration.underline)),
                      ),
                    ),

                    Row(
                      children: [
                        Checkbox(value: _rememberMe, onChanged: (value) => setState(() => _rememberMe = value!), activeColor: Colors.black),
                        const Text('จดจำฉัน', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // --- ปุ่ม Login (Firebase) ---
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1D0A45),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        onPressed: _isLoading ? null : () async {
                          // 1. Validation
                          if (_usernameController.text.trim().isEmpty || _passwordController.text.trim().isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('กรุณากรอกข้อมูลให้ครบถ้วน'), backgroundColor: Colors.red));
                            return; 
                          }

                          setState(() => _isLoading = true);

                          try {
                            String loginEmail = _usernameController.text.trim();

                            // 2. ถ้ายูสเซอร์เลือกโหมดเบอร์โทร ให้ไปค้นหา Email จาก Database ก่อน
                            if (!_isEmailLogin) {
                              String phoneRaw = loginEmail.replaceAll(RegExp(r'\D'), '');
                              var snapshot = await FirebaseFirestore.instance.collection('users').where('phone', isEqualTo: phoneRaw).limit(1).get();
                              
                              if (snapshot.docs.isNotEmpty) {
                                loginEmail = snapshot.docs.first.data()['email']; // ดึงอีเมลออกมาล็อกอิน
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('ไม่พบเบอร์โทรศัพท์นี้ในระบบ'), backgroundColor: Colors.red));
                                setState(() => _isLoading = false);
                                return;
                              }
                            }

                            // 3. เข้าสู่ระบบผ่าน Firebase ด้วยอีเมลและรหัสผ่าน
                            await FirebaseAuth.instance.signInWithEmailAndPassword(
                              email: loginEmail,
                              password: _passwordController.text,
                            );

                            // 4. บันทึกข้อมูล "จดจำฉัน" ลง SharedPreferences
                            final prefs = await SharedPreferences.getInstance();
                            if (_rememberMe) {
                              await prefs.setBool('rememberMe', true);
                              await prefs.setString('saved_username', _usernameController.text.trim());
                              await prefs.setBool('saved_is_email', _isEmailLogin);
                            } else {
                              await prefs.setBool('rememberMe', false);
                              await prefs.remove('saved_username');
                              await prefs.remove('saved_is_email');
                            }

                            // ไปยังหน้าหลัก
                            if (mounted) Navigator.pushReplacementNamed(context, '/main');

                          } on FirebaseAuthException catch (e) {
                            String errorMsg = 'เกิดข้อผิดพลาดในการเข้าสู่ระบบ';
                            if (e.code == 'user-not-found' || e.code == 'wrong-password' || e.code == 'invalid-credential') {
                              errorMsg = 'ชื่อผู้ใช้หรือรหัสผ่านไม่ถูกต้อง';
                            }
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorMsg), backgroundColor: Colors.red));
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('เกิดข้อผิดพลาดในการเชื่อมต่อเซิร์ฟเวอร์'), backgroundColor: Colors.red));
                          }

                          setState(() => _isLoading = false);
                        },
                        child: _isLoading 
                            ? const CircularProgressIndicator(color: Color(0xFFFFD700))
                            : const Text('Login', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFFFFD700))),
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

                    if (_showEmergencyButton) ...[
                      const SizedBox(height: 32),
                      const Divider(thickness: 1, color: Colors.grey),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: OutlinedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const MedicalIdScreen(isEmergencyMode: true)),
                            );
                          },
                          icon: const Icon(Icons.health_and_safety, color: Colors.red, size: 28),
                          label: const Text(
                            'Emergency Info (Medical ID)', 
                            style: TextStyle(color: Colors.red, fontSize: 16, fontWeight: FontWeight.bold)
                          ),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.red, width: 2),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            backgroundColor: Colors.red.withOpacity(0.05), 
                          ),
                        ),
                      ),
                    ],
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