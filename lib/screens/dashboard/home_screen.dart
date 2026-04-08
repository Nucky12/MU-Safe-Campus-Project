import 'package:flutter/material.dart';
import '../emergency/medical_id_screen.dart';
import '../map/safety_map_screen.dart';
import '../emergency/emergency_contact_screen.dart';
import '../report/report_history_screen.dart';
import '../education/faq_tips_screen.dart';
import '../education/quiz_screen.dart';



class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1D0A45),
        title: const Text(
          'MU SAFE CAMPUS',
          style: TextStyle(color: Color(0xFFFFD700), fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            height: 200,
            width: double.infinity,
            decoration: const BoxDecoration(
               image: DecorationImage(
                 image: AssetImage('assets/banner.png'), 
                 fit: BoxFit.cover,
               ),
            ),
          ),
          Container(height: 5, color: const Color(0xFFFFD700)), 
          
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.25, 
                children: [
                  _buildMenuCard(context, Icons.location_on_outlined, 'Safety Map', Colors.blue),
                  _buildMenuCard(context, Icons.phone_in_talk_outlined, 'External Emergency\nContacts', Colors.red),
                  _buildMenuCard(context, Icons.medical_information_outlined, 'Digital Medical\nCard', Colors.green),
                  _buildMenuCard(context, Icons.manage_history, 'My Reporting\nHistory', Colors.blueGrey),
                  _buildMenuCard(context, Icons.lightbulb_outline, 'Safety\nFAQ & Tips', Colors.orange),
                  _buildMenuCard(context, Icons.fact_check_outlined, 'Safety Quiz', Colors.purple),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuCard(BuildContext context, IconData icon, String title, Color color) {
    return InkWell(
      onTap: () {
        if (title.contains('Safety Map')) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const SafetyMapScreen()));
        } 
        else if (title.contains('External Emergency')) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const EmergencyContactScreen()));
        }
        else if (title.contains('Medical')) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const MedicalIdScreen()));
        }
        else if (title.contains('Reporting')) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const ReportHistoryScreen()));
        }
        else if (title.contains('FAQ')) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const FaqTipsScreen()));
        }
        else if (title.contains('Quiz')) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const QuizScreen()));
        }
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 5, 
              offset: const Offset(0, 2)
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 45, color: color),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: color),
            ),
          ],
        ),
      ),
    );
  }
}