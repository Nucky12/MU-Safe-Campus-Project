import 'package:flutter/material.dart';

// ==========================================
// 1. คลาสเก็บข้อมูลตำแหน่งบนแผนที่ (Data Model)
// ==========================================
class MapLocation {
  final String id;
  final String title;
  final String type; // 'AED' หรือ 'Nurse'
  final String description;
  final double x; // พิกัดแกน X บนแผนที่จำลอง (0.0 ถึง 1.0)
  final double y; // พิกัดแกน Y บนแผนที่จำลอง (0.0 ถึง 1.0)
  final String imagePath; // ชื่อไฟล์รูปภาพสถานที่

  MapLocation({
    required this.id,
    required this.title,
    required this.type,
    required this.description,
    required this.x,
    required this.y,
    required this.imagePath,
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
  // ข้อมูลจำลองพิกัดต่างๆ (Mock Data)
  // *แก้ชื่อไฟล์ใน imagePath ให้ตรงกับรูปที่คุณเซฟไว้ในโฟลเดอร์ assets*
  // ----------------------------------------------------
  final List<MapLocation> _allLocations = [
    MapLocation(
      id: '1', 
      title: 'AED station: ICT Building (Floor 1)', 
      type: 'AED', 
      description: 'ตำแหน่ง: อยู่บริเวณชั้น 1 ของคณะ ICT ใกล้บริเวณทางเข้า', 
      x: 0.6, y: 0.45, 
      imagePath: 'assets/aed_ict_1.jpg'
    ),
    MapLocation(
      id: '2', 
      title: 'AED station: MLC Building', 
      type: 'AED', 
      description: 'ตำแหน่ง: อาคารศูนย์การเรียนรู้มหิดล (MLC) ชั้น 1', 
      x: 0.45, y: 0.55, 
      imagePath: 'assets/aed_mlc_1.jpg'
    ),
    MapLocation(
      id: '3', 
      title: 'AED station: Condo D', 
      type: 'AED', 
      description: 'ตำแหน่ง: บริเวณล็อบบี้ หอพัก Condo D', 
      x: 0.3, y: 0.3, 
      imagePath: 'assets/aed_condo_d_1.jpg'
    ),
    MapLocation(
      id: '4', 
      title: 'First Aid: ห้องพยาบาลคณะ ICT', 
      type: 'Nurse', 
      description: 'ตำแหน่ง: ห้องพยาบาลคณะ ICT ชั้น 2', 
      x: 0.62, y: 0.48, 
      imagePath: 'assets/nurse_room_ict_1.jpg' // เปลี่ยนชื่อไฟล์ให้ตรงกับของคุณ
    ),
    MapLocation(
      id: '5', 
      title: 'First Aid: สวนสิรีรุกขชาติ', 
      type: 'Nurse', 
      description: 'ตำแหน่ง: อาคารอำนวยการ สวนสิรีรุกขชาติ', 
      x: 0.35, y: 0.7, 
      imagePath: 'assets/aed_sc_1_1.jpg' // ใช้รูปจำลองไปก่อน
    ),
    MapLocation(
      id: '6', 
      title: 'AED station: ตึกวิทยาศาสตร์ SC1', 
      type: 'AED', 
      description: 'ตำแหน่ง: บริเวณโถงทางเข้าตึก SC1', 
      x: 0.75, y: 0.65, 
      imagePath: 'assets/aed_sc_1_1.jpg'
    ),
  ];

  List<MapLocation> _filteredLocations = [];
  MapLocation? _selectedLocation;

  // กำหนดขนาดจำลองของรูปแผนที่ (ตั้งให้ใหญ่พอที่จะซูมและเลื่อนได้)
  final double mapWidth = 1200;
  final double mapHeight = 1200;

  @override
  void initState() {
    super.initState();
    _filteredLocations = _allLocations; // เริ่มต้นให้แสดงทุกจุด
  }

  // ฟังก์ชันระบบค้นหา
  void _filterMap(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredLocations = _allLocations;
      } else {
        _filteredLocations = _allLocations
            .where((loc) => loc.title.toLowerCase().contains(query.toLowerCase()) || 
                            loc.description.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
      // ถ้ากำลังพิมพ์ค้นหาใหม่ ให้ซ่อนการ์ดข้อมูลที่เปิดค้างไว้
      _selectedLocation = null; 
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1D0A45), // สีม่วงเข้ม
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFFFFD700)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Safety Map', style: TextStyle(color: Color(0xFFFFD700), fontWeight: FontWeight.bold)),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4.0),
          child: Container(color: const Color(0xFFFFD700), height: 4.0), // เส้นสีเหลืองด้านล่าง AppBar
        ),
      ),
      body: Stack(
        children: [
          // ----------------------------------------------------
          // ส่วนที่ 1: แผนที่แบบ Interactive (ซูมและเลื่อนได้)
          // ----------------------------------------------------
          GestureDetector(
            onTap: () {
              // กดพื้นที่ว่างเพื่อปิดคีย์บอร์ดและปิดการ์ด
              FocusScope.of(context).unfocus();
              setState(() => _selectedLocation = null);
            },
            child: InteractiveViewer(
              minScale: 0.5,
              maxScale: 3.0,
              constrained: false, // ปล่อยให้เลื่อนอิสระเกินหน้าจอได้
              child: SizedBox(
                width: mapWidth,
                height: mapHeight,
                child: Stack(
                  children: [
                    // รูปพื้นหลังแผนที่
                    Positioned.fill(
                      child: Image.asset(
                        'assets/map_bg.jpg', // ต้องมีไฟล์นี้ในโฟลเดอร์ assets
                        fit: BoxFit.cover,
                        filterQuality: FilterQuality.high,
                        errorBuilder: (context, error, stackTrace) {
                          // โชว์หน้าจอเทาๆ ถ้ายังไม่ได้เอารูปแผนที่มาใส่
                          return Container(
                            color: const Color(0xFFEFEFEF),
                            child: const Center(
                              child: Text(
                                'MAP BACKGROUND\n(Please add assets/map_bg.jpg)', 
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    // วาดจุดปักหมุดทั้งหมด
                    ..._filteredLocations.map((loc) => Positioned(
                      // เอาพิกัด x, y (0.0 - 1.0) มาคูณความกว้าง/ยาวของแผนที่
                      left: loc.x * mapWidth,
                      top: loc.y * mapHeight,
                      child: GestureDetector(
                        onTap: () {
                          // ปิดคีย์บอร์ดและโชว์การ์ดข้อมูล
                          FocusScope.of(context).unfocus();
                          setState(() {
                            _selectedLocation = loc;
                          });
                        },
                        child: _buildMapPin(loc),
                      ),
                    )),
                  ],
                ),
              ),
            ),
          ),

          // ----------------------------------------------------
          // ส่วนที่ 2: ช่องค้นหา (Search Bar) ลอยอยู่ด้านบน
          // ----------------------------------------------------
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4))
                ],
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: _filterMap,
                decoration: const InputDecoration(
                  hintText: 'Search Maps (เช่น ict, mlc)',
                  prefixIcon: Icon(Icons.search, color: Colors.grey),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ),

          // ----------------------------------------------------
          // ส่วนที่ 3: การ์ดแสดงข้อมูลสถานที่ (Pop-up ด้านล่าง)
          // ----------------------------------------------------
          if (_selectedLocation != null)
            Positioned(
              bottom: 24,
              left: 16,
              right: 16,
              child: _buildLocationCard(_selectedLocation!),
            ),
        ],
      ),
    );
  }

  // ==========================================
  // Widget ช่วยสร้าง หมุด (Pins)
  // ==========================================
  Widget _buildMapPin(MapLocation loc) {
    bool isAED = loc.type == 'AED';
    bool isSelected = _selectedLocation?.id == loc.id; // เช็คว่าหมุดนี้ถูกกดอยู่ไหม

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      transform: Matrix4.translationValues(0, isSelected ? -10 : 0, 0), // เด้งขึ้นเวลากด
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ตัวหมุดวงกลม
          Container(
            width: isSelected ? 40 : 32,
            height: isSelected ? 40 : 32,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(
                color: isAED ? Colors.red : Colors.green, // แดง = AED, เขียว = ห้องพยาบาล
                width: 3,
              ),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 4, offset: const Offset(0, 2))
              ],
            ),
            child: Icon(
              isAED ? Icons.location_on : Icons.add, // AED ใช้ไอคอนพิกัด, พยาบาลใช้เครื่องหมายบวก
              color: isAED ? Colors.red : Colors.green,
              size: isSelected ? 24 : 18,
            ),
          ),
          // หางของหมุด
          Container(
            width: 4,
            height: isSelected ? 12 : 8,
            color: isAED ? Colors.red : Colors.green,
          ),
        ],
      ),
    );
  }

  // ==========================================
  // Widget ช่วยสร้าง การ์ดข้อมูลด้านล่าง
  // ==========================================
  Widget _buildLocationCard(MapLocation loc) {
    bool isAED = loc.type == 'AED';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black, width: 1), // ขอบสีดำตามดีไซน์
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 10, offset: const Offset(0, 5))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ข้อมูลตัวหนังสือด้านซ้าย
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      loc.title,
                      style: TextStyle(
                        fontSize: 16, 
                        fontWeight: FontWeight.bold, 
                        color: isAED ? const Color(0xFFD32F2F) : const Color(0xFF388E3C), // สีแดงหรือเขียวเข้ม
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      loc.description,
                      style: const TextStyle(fontSize: 12, color: Colors.black87),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              // รูปภาพสถานที่ด้านขวา
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(3),
                  child: Image.asset(
                    loc.imagePath,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      // ถ้ารูปโหลดไม่ขึ้น (ใส่ชื่อไฟล์ผิด/หาไม่เจอ) โชว์ไอคอนเทาๆ
                      return Container(
                        color: Colors.grey[300],
                        child: const Icon(Icons.image_not_supported, color: Colors.grey, size: 30),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // ปุ่ม "เส้นทาง" สีม่วง
          SizedBox(
            width: double.infinity,
            height: 45,
            child: ElevatedButton(
              onPressed: () {
                // จำลองการกดปุ่มเส้นทาง
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('กำลังเปิดเส้นทางไปยัง ${loc.title}...'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1D0A45),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('เส้นทาง', style: TextStyle(color: Color(0xFFFFD700), fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}
