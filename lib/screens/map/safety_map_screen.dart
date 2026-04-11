import 'package:flutter/material.dart';

// ==========================================
// 1. Data Model (รูปแบบข้อมูลสถานที่)
// ==========================================
class MapLocation {
  final String id;
  final String title;
  final String type; // 'AED' หรือ 'Nurse'
  final String description;
  final double x; // พิกัดแกน X บนแผนที่จำลอง (0.0 ถึง 1.0)
  final double y; // พิกัดแกน Y บนแผนที่จำลอง (0.0 ถึง 1.0)
  final String imagePath; // ลิ้งก์รูปภาพในโฟลเดอร์ assets

  MapLocation({
    required this.id, required this.title, required this.type,
    required this.description, required this.x, required this.y, required this.imagePath,
  });
}

// ==========================================
// 2. หน้าจอ Safety Map หลัก
// ==========================================
class SafetyMapScreen extends StatefulWidget {
  const SafetyMapScreen({super.key});

  @override
  State<SafetyMapScreen> createState() => _SafetyMapScreenState();
}

class _SafetyMapScreenState extends State<SafetyMapScreen> {
  final TextEditingController _searchController = TextEditingController();
  
  // ----------------------------------------------------
  // ข้อมูลพิกัดต่างๆ (อ้างอิงชื่อไฟล์รูปภาพจากโฟลเดอร์ของคุณจริงๆ)
  // หมายเหตุ: ค่า x และ y (0.1 - 0.9) เป็นค่าประมาณ คุณสามารถปรับแก้ให้ตรงกับจุดบนรูป map_bg.jpg ของคุณได้
  // ----------------------------------------------------
  final List<MapLocation> _allLocations = [
    MapLocation(id: '1', title: 'AED: คณะ ICT', type: 'AED', description: 'บริเวณทางเข้า/โถงชั้น 1 คณะ ICT', x: 0.60, y: 0.45, imagePath: 'assets/aed_ict_1.jpg'),
    MapLocation(id: '2', title: 'First Aid: ห้องพยาบาลคณะ ICT', type: 'Nurse', description: 'ห้องพยาบาลประจำคณะ ICT', x: 0.62, y: 0.48, imagePath: 'assets/first_aid_room_ict_1.jpg'),
    
    MapLocation(id: '3', title: 'AED: อาคาร MLC', type: 'AED', description: 'ศูนย์การเรียนรู้มหิดล (MLC)', x: 0.45, y: 0.55, imagePath: 'assets/aed_mlc_1.jpg'),
    MapLocation(id: '4', title: 'First Aid: MU Health (MLC)', type: 'Nurse', description: 'คลินิก MU Health ที่อาคาร MLC', x: 0.47, y: 0.57, imagePath: 'assets/mu_health_mlc_1.jpg'),
    
    MapLocation(id: '5', title: 'AED: หอพัก Condo D', type: 'AED', description: 'บริเวณใต้อาคารหอพัก Condo D', x: 0.30, y: 0.30, imagePath: 'assets/aed_condo_d_1.jpg'),
    MapLocation(id: '6', title: 'AED: ตึกวิทยาศาสตร์ SC1', type: 'AED', description: 'โถงทางเข้าตึก SC1', x: 0.75, y: 0.65, imagePath: 'assets/aed_sc1_1.jpg'),
    
    MapLocation(id: '7', title: 'First Aid: ห้องพยาบาลวิศวะ', type: 'Nurse', description: 'ห้องพยาบาลคณะวิศวกรรมศาสตร์', x: 0.80, y: 0.35, imagePath: 'assets/first_aid_room_engineering_middle_1.jpg'),
    MapLocation(id: '8', title: 'AED: สนามแบดมินตัน', type: 'AED', description: 'จุดติดตั้งใกล้สนามแบดมินตัน', x: 0.20, y: 0.40, imagePath: 'assets/aed_badminton_court_1.jpg'),
    
    MapLocation(id: '9', title: 'First Aid: ห้องพยาบาลหอสมุด', type: 'Nurse', description: 'ห้องพยาบาลประจำหอสมุดกลาง', x: 0.50, y: 0.40, imagePath: 'assets/first_aid_room_library_1.jpg'),
    MapLocation(id: '10', title: 'AED: สวนสิรีรุกขชาติ', type: 'AED', description: 'อุทยานธรรมชาติวิทยาสิรีรุกขชาติ', x: 0.35, y: 0.80, imagePath: 'assets/aed_sireeruckhachatinature_learning_park_1.jpg'),
  ];

  List<MapLocation> _filteredLocations = [];
  MapLocation? _selectedLocation;
  String _selectedFilter = 'All'; // ตัวแปรเก็บค่าฟิลเตอร์ปัจจุบัน (All, AED, Nurse)

  // กำหนดความกว้างยาวของรูปแผนที่ตอนซูม
  final double mapWidth = 1200;
  final double mapHeight = 1200;

  @override
  void initState() {
    super.initState();
    _filteredLocations = _allLocations;
  }

  // --- ฟังก์ชันค้นหาและกรอง (Filter) ---
  void _filterMap() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      _filteredLocations = _allLocations.where((loc) {
        // เช็คคำค้นหา
        bool matchesQuery = loc.title.toLowerCase().contains(query) || loc.description.toLowerCase().contains(query);
        // เช็คหมวดหมู่ (AED / Nurse)
        bool matchesFilter = _selectedFilter == 'All' || loc.type == _selectedFilter;
        
        return matchesQuery && matchesFilter;
      }).toList();
      _selectedLocation = null; // ปิดการ์ดล่างเมื่อค้นหาใหม่
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1D0A45),
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios, color: Color(0xFFFFD700)), onPressed: () => Navigator.pop(context)),
        title: const Text('Safety Map', style: TextStyle(color: Color(0xFFFFD700), fontWeight: FontWeight.bold)),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4.0),
          child: Container(color: const Color(0xFFFFD700), height: 4.0),
        ),
      ),
      body: Stack(
        children: [
          // 1. พื้นที่แผนที่แบบเลื่อน/ซูมได้
          GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus(); // ปิดคีย์บอร์ด
              setState(() => _selectedLocation = null); // ปิดการ์ด
            },
            child: InteractiveViewer(
              minScale: 0.5, maxScale: 4.0, constrained: false,
              child: SizedBox(
                width: mapWidth, height: mapHeight,
                child: Stack(
                  children: [
                    // รูปพื้นหลังแผนที่
                    Positioned.fill(
                      child: Image.asset(
                        'assets/map_bg.jpg', // ดึงจากไฟล์ภาพแผนที่ของคุณ
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stack) => Container(
                          color: const Color(0xFFEFEFEF), 
                          child: const Center(child: Text('กรุณาเพิ่มรูปแผนที่\n(assets/map_bg.jpg)', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)))
                        ),
                      ),
                    ),
                    // วาดหมุด (Pins) ลงบนแผนที่
                    ..._filteredLocations.map((loc) => Positioned(
                      left: loc.x * mapWidth, 
                      top: loc.y * mapHeight,
                      child: GestureDetector(
                        onTap: () {
                          FocusScope.of(context).unfocus();
                          setState(() => _selectedLocation = loc);
                        },
                        child: _buildMapPin(loc),
                      ),
                    )),
                  ],
                ),
              ),
            ),
          ),

          // 2. แถบค้นหา และ แถบ Filter ด้านบน
          Positioned(
            top: 16, left: 16, right: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // แถบค้นหา (Search Box)
                Container(
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4))]),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (val) => _filterMap(),
                    decoration: InputDecoration(
                      hintText: 'ค้นหาสถานที่ (เช่น ICT, MLC)', 
                      prefixIcon: const Icon(Icons.search, color: Colors.grey), 
                      suffixIcon: _searchController.text.isNotEmpty 
                          ? IconButton(icon: const Icon(Icons.clear, color: Colors.grey), onPressed: () { _searchController.clear(); _filterMap(); }) 
                          : null,
                      border: InputBorder.none, 
                      contentPadding: const EdgeInsets.symmetric(vertical: 14)
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                // แถบปุ่ม Filter (Chips)
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip('All', 'ทั้งหมด', Icons.map),
                      const SizedBox(width: 8),
                      _buildFilterChip('AED', 'จุดติดตั้ง AED', Icons.favorite),
                      const SizedBox(width: 8),
                      _buildFilterChip('Nurse', 'ห้องพยาบาล', Icons.local_hospital),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 3. การ์ดแสดงข้อมูลสถานที่ (เด้งขึ้นมาด้านล่างเมื่อกดหมุด)
          if (_selectedLocation != null)
            Positioned(
              bottom: 24, left: 16, right: 16,
              child: TweenAnimationBuilder(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOutCubic,
                tween: Tween<double>(begin: 100, end: 0),
                builder: (context, double value, child) => Transform.translate(offset: Offset(0, value), child: child),
                child: _buildLocationCard(_selectedLocation!),
              ),
            ),
        ],
      ),
    );
  }

  // --- ฟังก์ชันสร้างปุ่ม Filter ---
  Widget _buildFilterChip(String type, String label, IconData icon) {
    bool isSelected = _selectedFilter == type;
    return ChoiceChip(
      label: Row(
        children: [
          Icon(icon, size: 18, color: isSelected ? Colors.white : Colors.black54),
          const SizedBox(width: 6),
          Text(label, style: TextStyle(color: isSelected ? Colors.white : Colors.black87, fontWeight: FontWeight.bold)),
        ],
      ),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedFilter = type;
          _filterMap();
        });
      },
      selectedColor: const Color(0xFF1D0A45),
      backgroundColor: Colors.white,
      elevation: isSelected ? 4 : 2,
      shadowColor: Colors.black26,
    );
  }

  // --- ฟังก์ชันสร้าง หมุด (Pins) ---
  Widget _buildMapPin(MapLocation loc) {
    bool isAED = loc.type == 'AED';
    bool isSelected = _selectedLocation?.id == loc.id; 

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      transform: Matrix4.translationValues(0, isSelected ? -15 : 0, 0), // หมุดเด้งขึ้นเมื่อถูกเลือก
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: isSelected ? 45 : 35, height: isSelected ? 45 : 35,
            decoration: BoxDecoration(
              color: Colors.white, shape: BoxShape.circle,
              border: Border.all(color: isAED ? Colors.red : Colors.green, width: 3),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.4), blurRadius: 6, offset: const Offset(0, 3))],
            ),
            child: Icon(isAED ? Icons.monitor_heart : Icons.medical_services, color: isAED ? Colors.red : Colors.green, size: isSelected ? 26 : 20),
          ),
          Container(width: 4, height: isSelected ? 12 : 8, color: isAED ? Colors.red : Colors.green),
        ],
      ),
    );
  }

  // --- ฟังก์ชันสร้าง การ์ดข้อมูลด้านล่าง ---
  Widget _buildLocationCard(MapLocation loc) {
    bool isAED = loc.type == 'AED';
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black, width: 1.5),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 10, offset: const Offset(0, 5))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ข้อมูลรายละเอียดซ้ายมือ
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: isAED ? Colors.red.shade100 : Colors.green.shade100, borderRadius: BorderRadius.circular(4)),
                      child: Text(isAED ? 'อุปกรณ์ AED' : 'ห้องพยาบาล', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: isAED ? Colors.red.shade900 : Colors.green.shade900)),
                    ),
                    const SizedBox(height: 6),
                    Text(loc.title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isAED ? const Color(0xFFD32F2F) : const Color(0xFF388E3C))),
                    const SizedBox(height: 6),
                    Text(loc.description, style: const TextStyle(fontSize: 13, color: Colors.black87), maxLines: 3, overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              // รูปภาพขวามือ (ดึงจาก Assets)
              Container(
                width: 100, height: 100,
                decoration: BoxDecoration(border: Border.all(color: Colors.black, width: 1), borderRadius: BorderRadius.circular(8)),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(7),
                  child: Image.asset(
                    loc.imagePath, fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Colors.grey[200], 
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.image_not_supported, color: Colors.grey, size: 30),
                          Text('No Image', style: TextStyle(fontSize: 10, color: Colors.grey)),
                        ],
                      )
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // ปุ่มนำทาง
          SizedBox(
            width: double.infinity, height: 45,
            child: ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('ระบบกำลังเปิดเส้นทางไปยัง ${loc.title} ...'), backgroundColor: Colors.green));
              },
              icon: const Icon(Icons.directions, color: Color(0xFFFFD700)),
              label: const Text('ดูเส้นทาง', style: TextStyle(color: Color(0xFFFFD700), fontSize: 16, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1D0A45), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
            ),
          ),
        ],
      ),
    );
  }
}