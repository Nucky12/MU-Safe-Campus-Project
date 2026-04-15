import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

// ==========================================
// 1. Data Model
// ==========================================
class MapLocation {
  final String id;
  final String title;
  final String type;
  final String description;
  final LatLng position;
  final String imagePath;

  MapLocation({
    required this.id, required this.title, required this.type,
    required this.description, required this.position, required this.imagePath,
  });
}

// ==========================================
// 2. หน้าจอ Safety Map (แผนที่จริง)
// ==========================================
class SafetyMapScreen extends StatefulWidget {
  const SafetyMapScreen({super.key});

  @override
  State<SafetyMapScreen> createState() => _SafetyMapScreenState();
}

class _SafetyMapScreenState extends State<SafetyMapScreen> {
  final TextEditingController _searchController = TextEditingController();
  final MapController _mapController = MapController();
  
  LatLng? _myPosition;
  bool _isLoadingLocation = false;

  // ข้อมูลพิกัดสถานที่ทั้งหมด (พิกัดจริง)
  final List<MapLocation> _allLocations = [
    // 1. สำนักงานอธิการบดี
    MapLocation(id: '1a', title: 'สำนักงานอธิการบดี', type: 'AED', description: 'เครื่อง AED ถูกติดตั้งอยู่ชั้น 1 ข้างจุดประชาสัมพันธ์ บริเวณตรงกลาง ของอาคารสำนักงานอธิการบดี', position: const LatLng(13.79444047022652, 100.32582857501072), imagePath: 'assets/aed_op_1.jpg'),
    MapLocation(id: '1n', title: 'สำนักงานอธิการบดี', type: 'Nurse', description: 'ห้องอยู่ บริเวณชั้น 4 ของอาคาร เดินตรงออกมาจากลิฟต์ แล้วจะเจอเลย  ***แต่โดยปกติแล้ว ห้องนี้จะไม่เปิดให้บุคคลภายนอกใช้งาน*** ', position: const LatLng(13.794440339120937, 100.32563383618277), imagePath: 'assets/first_aid_op_1.jpg'),

    // 2. คณะเทคโนโลยีสารสนเทศและการสื่อสาร 
    MapLocation(id: '2a', title: 'คณะเทคโนโลยีสารสนเทศและการสื่อสาร', type: 'AED', description: 'เครื่อง AED ถูกติดตั้งอยู่ ตรงบริเวณเสา ที่โถงทางเดินชั้น 1 ของอาคาร ', position: const LatLng(13.794607685342495, 100.32478959786519), imagePath: 'assets/aed_ict_1.jpg'),
    MapLocation(id: '2n', title: 'คณะเทคโนโลยีสารสนเทศและการสื่อสาร', type: 'Nurse', description: 'ห้องพยาบาลอยู่บริเวณ ชั้น 2 ของอาคาร ฝั่งทางห้อง 201-204 , 211-212', position: const LatLng(13.794614927026103, 100.32453000276921), imagePath: 'assets/first_aid_room_ict_1.jpg'),

    // 3. ตึกเรียนรวม 1
    MapLocation(id: '3a', title: 'ตึกเรียนรวม 1', type: 'AED', description: 'เครื่อง AED ถูกติดตั้งอยู่ ข้างๆห้อง 102 ของอาคารเรียนรวม 1', position: const LatLng(13.793781789765786, 100.32481758517375), imagePath: 'assets/aed_l1_1.jpg'),

    // 4. วิทยาลัยนานาชาติ
    MapLocation(id: '4a', title: 'วิทยาลัยนานาชาติ', type: 'AED', description: 'เครื่อง AED ถูกติดตั้งอยู่ที่บริเวณข้างป้อมยามชั้น 1', position: const LatLng(13.792668578167033, 100.32553272883302), imagePath: 'assets/aed_old_ic__1.jpg'),
    MapLocation(id: '4n', title: 'วิทยาลัยนานาชาติ', type: 'Nurse', description: 'ห้องจะอยู่ชั้น 1 ใกล้กับตึกสังคม ก่อนเดินเข้ามาในตัวอาคาร ', position: const LatLng(13.79287518776159, 100.32551455579578), imagePath: 'assets/first_aid_room_old_ic_1.jpg'),

    // 5. คณะวิศวกรรมศาสตร์
    MapLocation(id: '5a', title: 'คณะวิศวกรรมศาสตร์', type: 'AED', description: 'เครื่อง AED ถูกติดตั้ง ที่ตึกวิศวกรรมศาสตร์ อาคาร 1 บริเวณข้างจุดรักษาคววามปลอดภัย', position: const LatLng(13.796070216815364, 100.32483268990433), imagePath: 'assets/aed_engineering_middle_1.jpg'),
    MapLocation(id: '5n', title: 'คณะวิศวกรรมศาสตร์', type: 'Nurse', description: 'ห้องจะอยู่ที่ตึกวิศวกรรม อาคาร 1 ที่บริเวณชั้น 2', position: const LatLng(13.796099452895545, 100.32495889009382), imagePath: 'assets/first_aid_room_engineering_middle_1.jpg'),

    // 6. หอสมุดและคลังความรู้
    MapLocation(id: '6a', title: 'หอสมุดและคลังความรู้', type: 'AED', description: 'เครื่อง AED ถูกติดตั้ง ที่ชั้น 1 ทางฝั่งขวาของห้องสมุด ใกล้กับโซน E-Lecture ข้างๆห้องพยาบาล', position: const LatLng(13.794281565406015, 100.32401061582354), imagePath: 'assets/aed_library_1.jpg'),
    MapLocation(id: '6n', title: 'หอสมุดและคลังความรู้', type: 'Nurse', description: 'ห้องจะอยู่บริเวณชั้น 1 ทางฝั่งขวาของห้องสมุด ใกล้กับโซน E-Lecture ข้างๆเครื่อง AED', position: const LatLng(13.794238387006034, 100.32402631039444), imagePath: 'assets/first_aid_room_library_1.jpg'),

    // 7. อาคารเรียนรวม 2
    MapLocation(id: '7a', title: 'อาคารเรียนรวม 2', type: 'AED', description: 'เครื่อง AED ถูกติดตั้ง ข้างๆห้อง 102 ของอาคารเรียนรวม 2', position: const LatLng(13.793771955130579, 100.32324490000117), imagePath: 'assets/aed_l2_1.jpg'),

    // 8. คณะวิทยาศาสตร์ ตึก 1
    MapLocation(id: '8a', title: 'คณะวิทยาศาสตร์ ตึก 1', type: 'AED', description: 'เครื่อง AED ถูกติดตั้ง ที่บริเวณชั้น 1 ข้างๆห้องน้ำหญิง ตรงทางเชื่อมระหว่างตึก SC1 และ SC2 ', position: const LatLng(13.792838077938343, 100.32360733425841), imagePath: 'assets/aed_sc1_1.jpg'),

    // 9. คณะวิทยาศาสตร์ ตึก 2
    MapLocation(id: '9a', title: 'คณะวิทยาศาสตร์ ตึก 2', type: 'AED', description: 'เครื่อง AED ถูกติดตั้ง ที่บริเวณชั้น 1 ข้างๆห้องน้ำชาย ตรงทางเชื่อมระหว่างตึก SC2 และ SC1', position: const LatLng(13.792588134964644, 100.32361746636323), imagePath: 'assets/aed_sc2_1.jpg'),

    // 10. คณะวิทยาศาสตร์ ตึก 3 
    MapLocation(id: '10a', title: 'คณะวิทยาศาสตร์ ตึก 3', type: 'AED', description: 'เครื่อง AED ถูกติดตั้ง ที่บริเวณ ข้างหน้าลิฟต์ ชั้น 1 ของตึก SC3', position: const LatLng(13.79251418172575, 100.32201822072335), imagePath: 'assets/aed_sc3_1.jpg'),

    // 11. คณะวิทยาศาสตร์ ตึก 4
    MapLocation(id: '11a', title: 'คณะวิทยาศาสตร์ ตึก 4', type: 'AED', description: 'เครื่อง AED ถูกติดตั้ง ที่บริเวณ ข้างหน้าลิฟต์ ชั้น 1 ของตึก SC4', position: const LatLng(13.793058110842694, 100.3220124597873), imagePath: 'assets/aed_sc4_1.jpg'),

    // 12. บัณฑิตวิทยาลัย
    MapLocation(id: '12a', title: 'บัณฑิตวิทยาลัย', type: 'AED', description: 'เครื่อง AED ถูกติดตั้ง ที่บริเวณชั้น 1 ข้างๆบริเวณรักษาความปลอดภับ ของอาคารบัณฑิตวิทยาลัย', position: const LatLng(13.79375498951809, 100.32219011076515), imagePath: 'assets/aed_graduated_1.jpg'),

    // 13. คณะสิ่งแวดล้อมและทรัพยากรศาสตร์
    MapLocation(id: '13n', title: 'คณะสิ่งแวดล้อมฯ', type: 'Nurse', description: 'ห้องจะอยู่บริเวณชั้น 1 ตรงบริเวณมุมของ อาคารคณะสิ่งแวดล้อมและทรัพยากรศาสตร์', position: const LatLng(13.79491761909572, 100.32261237148819), imagePath: 'assets/first_aid_room_environment_building_1.jpg'),

    // 14. บ้านศรีตรัง (หอพักนักศึกษา 11)
    MapLocation(id: '14a', title: 'บ้านศรีตรัง', type: 'AED', description: 'เครื่อง AED ถูกติดตั้ง ใกล้เคียงกับ 7-11 และอยู่ข้างห้อง ERT (Emergncy Response Team) ของหอพักนักศึกษา 11 ', position: const LatLng(13.794522092541516, 100.31979726026255), imagePath: 'assets/aed_dorm11_1.jpg'),
    MapLocation(id: '14n', title: 'บ้านศรีตรัง (ERT)', type: 'Nurse', description: 'ห้องจะอยู่ บริเวณใกล้เคียงกับ 7-11 และอยู่ข้างเครื่อง AED ของหอพักนักศึกษา 11 ***โดยห้องจะใช้ชื่อว่า "ERT (Emergncy Response Team)" *** ', position: const LatLng(13.79453684077861, 100.31994936783236), imagePath: 'assets/ert_dorm11_1.jpg'),

    // 15. MLC
    MapLocation(id: '15a', title: 'MLC', type: 'AED', description: 'เครื่อง AED ถูกติดตั้ง ที่ศูนย์การเรียนรู้มหิดล หรือ MLC ที่ข้างห้อง MU HEALTH ', position: const LatLng(13.793663632153278, 100.32091883271823), imagePath: 'assets/aed_mlc_1.jpg'),
    MapLocation(id: '15n', title: 'MU Health', type: 'Nurse', description: 'ห้องพยาบาล MU Health อยู่ที่ศูนย์การเรียนรู้มหิดล หรือ MLC และบริเวณข้างห้อง MU HEALTH นั้น จะมีเครื่อง AED อยู่อีกด้วย', position: const LatLng(13.79362302896374, 100.32105373965558), imagePath: 'assets/mu_health_mlc_1.jpg'),

    // 16. สนามบาส
    MapLocation(id: '16a', title: 'สนามบาส', type: 'AED', description: 'เครื่อง AED ถูกติดตั้ง ตรงบริเวณห้องน้ำ ข้างหลังสนามบาสเกตบอล และ ข้างสนามฟุตซอล ', position: const LatLng(13.795305907699817, 100.32000721270087), imagePath: 'assets/aed_basketball_1.jpg'),

    // 17. วิทยาลัยวิทยาศาสตร์และเทคโนโลยีการกีฬา
    MapLocation(id: '17a', title: 'วิทยาลัยวิทยาศาสตร์และเทคโนโลยีการกีฬา', type: 'AED', description: 'เครื่อง AED ถูกติดตั้ง บริเวณหน้าทางเข้าของ อาคารวิทยาลัยวิทยาศาสตร์และเทคโนโลยีการกีฬา หรือ SS', position: const LatLng(13.795656778232042, 100.3210526717999), imagePath: 'assets/aed_ss_1.jpg'),

    // 18. สนามฟุตบอล 1
    MapLocation(id: '18a', title: 'สนามฟุตบอล 1', type: 'AED', description: 'เครื่อง AED ถูกติดตั้ง ตรงบริเวณทางเข้าตรงกลาง ของสนามฟุตบอล 1', position: const LatLng(13.793356147734652, 100.31763165002644), imagePath: 'assets/aed_football_1.jpg'),

    // 19. อุทยานธรรมชาติวิทยาสิรีรุกขชาติ
    MapLocation(id: '19a', title: 'อุทยานสิรีรุกขชาติ', type: 'AED', description: 'เครื่อง AED ถูกติดตั้ง ตรงบริเวณ ด้านหน้าของศูนย์ประชาสัมพันธ์ ของอุทยานธรรมชาติวิทยาสิรีรุกขชาติ', position: const LatLng(13.791311326340836, 100.31999243165872), imagePath: 'assets/aed_sireeruckhachatinature_learning_park_1.jpg'),

    // 20. มหิดลสิทธาคาร
    MapLocation(id: '20a', title: 'มหิดลสิทธาคาร', type: 'AED', description: 'เครื่อง AED ถูกติดตั้ง บริเวณด้านข้าง ฝั่งดุริยางค์ของมหิดลสิทธาคาร', position: const LatLng(13.789921109981554, 100.32144025300857), imagePath: 'assets/aed_prince_mahidol_hall_1.jpg'),

    // 21. ศูนย์ประชุมมหิดลสิทธาคาร
    MapLocation(id: '21a', title: 'ศูนย์ประชุมมหิดลสิทธาคาร', type: 'AED', description: 'เครื่อง AED ถูกติดตั้ง บริเวณใกล้เคียงกับ Starbucks และอยู่ใกล้เคียงกับบันไดเพื่อลงไปลานจอดรถของศูนย์ประชุม', position: const LatLng(13.790358343992509, 100.32196289157217), imagePath: 'assets/aed_pmh_conference_center_1.jpg'),

    // 22. วิทยาลัยดุริยางคศิลป์
    MapLocation(id: '22a', title: 'วิทยาลัยดุริยางคศิลป์', type: 'AED', description: 'เครื่อง AED ถูกติดตั้ง ที่เสา บริเวณใกล้เคียงกับ โรงอาหารของวิทยาลัยดุริยางคศิลป์', position: const LatLng(13.788779696667117, 100.32437578702506), imagePath: 'assets/aed_music_1.jpg'),

    // 23. สถาบันพัฒนาสุขภาพอาเซียน
    MapLocation(id: '23n', title: 'สถาบันพัฒนาสุขภาพอาเซียน', type: 'Nurse', description: 'ห้องพยาบาลจะอยู่บริเวณชั้น 1 ด้านใน ของตัวอาคารสถาบันพัฒนาสุขภาพอาเซียน', position: const LatLng(13.79104976441249, 100.32554875586783), imagePath: 'assets/first_aid_room_asean_institute_for_health_development_1.jpg'),

    // 24. คณะพยาบาลศาสตร์
    MapLocation(id: '24a', title: 'คณะพยาบาลศาสตร์', type: 'AED', description: 'เครื่อง AED ถูกติดตั้ง บริเวณชั้น 1 ของอาคารคณะพยาบาลศาสตร์', position: const LatLng(13.788664300782706, 100.32639626972987), imagePath: 'assets/aed_nurse_1.jpg'),

    // 25. อาคารอาทิตยาทร
    
    // 26. สถาบันชีววิทยาศาสตร์โมเลกุล
    MapLocation(id: '25a', title: 'สถาบันชีววิทยาศาสตร์โมเลกุล', type: 'AED', description: 'เครื่อง AED ถูกติดตั้ง ที่บริเวณชั้น 1 ข้างๆ ห้องพยาบาล และอยู่ใกล้กับบันได ของอาคารสถาบันชีววิทยาศาสตร์โมเลกุล', position: const LatLng(13.797166029403543, 100.32629131670168), imagePath: 'assets/aed_institute_of_molecular_biosciences_1.jpg'),
    MapLocation(id: '25n', title: 'สถาบันชีววิทยาศาสตร์โมเลกุล', type: 'Nurse', description: 'ห้องพยาบาล จะอยู่ที่บริเวณชั้น 1 ข้างๆ เครื่อง AED และอยู่ใกล้กับบันได ของอาคารสถาบันชีววิทยาศาสตร์โมเลกุล', position: const LatLng(13.79720988278852, 100.3262779852505), imagePath: 'assets/first_aid_room_institute_of_molecular_biosciences_1.jpg'),

    // 27. สถาบันวิจัยประชากรและสังคม
    MapLocation(id: '26a', title: 'สถาบันวิจัยประชากรและสังคม', type: 'AED', description: 'เครื่อง AED ถูกติดตั้ง ที่ชั้น 1 บริเวณทางเข้า ของอาคารสถาบันวิจัยประชากรและสังคม', position: const LatLng(13.79706162959642, 100.32468862095266), imagePath: 'assets/aed_institute_for_population_and_social_research_1.jpg'),

    // 28. คณะเทคนิคการแพทย์
    MapLocation(id: '27a', title: 'คณะเทคนิคการแพทย์', type: 'AED', description: 'เครื่อง AED ถูกติดตั้ง ที่ชั้น 1 บริเวณทางเข้า ของอาคารทางคณะเทคนิคการแพทย์', position: const LatLng(13.798668631380869, 100.32312629486724), imagePath: 'assets/aed_mt_1.jpg'),
    MapLocation(id: '27n', title: 'คณะเทคนิคการแพทย์', type: 'Nurse', description: 'ห้องพยาบาลจะอยู่ ที่ชั้น 2 ของอาคารคณะเทคนิคการแพทย์', position: const LatLng(13.798627802197899, 100.32291463349723), imagePath: 'assets/first_aid_room_mt_1.jpg'),

    // 29. โรงเรียนพยาบาลรามาธิบดี
    MapLocation(id: '28a', title: 'โรงเรียนพยาบาลรามาธิบดี', type: 'AED', description: 'เครื่อง AED ถูกติดตั้ง บริเวณชั้น 1 ทางด้านซ้ายมือของอาคารโรงเรียนพยาบาลรามาธิบดี ***ในวันที่ไปเก็บข้อมูล ทางฝ่ายสถานที่แจ้งว่า ได้แจ้งไว้ว่า จะมีการเปลี่ยน AED ใหม่ เลยไม่ได้มีตัวเครื่องในรูป***', position: const LatLng(13.798575590939732, 100.32208554374121), imagePath: 'assets/aed_rama_school_1.jpg'),
    MapLocation(id: '28n', title: 'โรงเรียนพยาบาลรามาธิบดี', type: 'Nurse', description: 'ห้องพยาบาล จะอยู่บริเวณชั้น 1 ทางด้านขวามือของอาคารโรงเรียนพยาบาลรามาธิบดี', position: const LatLng(13.798547884055006, 100.3219530817126), imagePath: 'assets/first_aid_room_rama_school_1.jpg'),

    // 30. หอพักนักศึกษาพยาบาล รามาธิบดี
    MapLocation(id: '29a', title: 'หอพักนักศึกษาพยาบาล รามาธิบดี', type: 'AED', description: 'เครื่อง AED ถูกติดตั้ง ที่บริเวณฝั่งขวา ทางเดินชั้น 1 ของหอพักนักศึกษาพยาบาล ', position: const LatLng(13.798710873924867, 100.32093682997449), imagePath: 'assets/aed_rama_dorm_1.jpg'),
    MapLocation(id: '29n', title: 'หอพักนักศึกษาพยาบาล รามาธิบดี', type: 'Nurse', description: 'ห้องพยาบาลจะอยู่ ที่บริเวณฝั่งซ้าย ทางเดินชั้น 1 ของหอพักนักศึกษาพยาบาล', position: const LatLng(13.798680213304054, 100.32110940624901), imagePath: 'assets/first_aid_room_rama_dorm_1.jpg'),

    // 31. คณะกายภาพบำบัด
    MapLocation(id: '30a', title: 'คณะกายภาพบำบัด', type: 'AED', description: 'เครื่อง AED ถูกติดตั้ง ที่ชั้น 1 บริเวณตรงข้ามกับ เคาน์เตอร์ของคณะกายภาพบำบัด', position: const LatLng(13.797603076606888, 100.322110706082), imagePath: 'assets/aed_pt_1.jpg'),

    // 32. คณะศิลปศาสตร์
    MapLocation(id: '31a', title: 'คณะศิลปศาสตร์', type: 'AED', description: 'เครื่อง AED ถูกติดตั้ง ที่ชั้น 1 ใกล้กับลิฟต์ของ คณะศิลปศาสตร์', position: const LatLng(13.797175658539672, 100.32093564755996), imagePath: 'assets/aed_la_1.jpg'),
    MapLocation(id: '31n', title: 'คณะศิลปศาสตร์', type: 'Nurse', description: 'ห้องพยาบาล จะอยู่ที่บริเวณชั้น 1 ข้างๆ กับจุดรักษาความปลอดภัย ของคณะศิลปศาสตร์', position: const LatLng(13.797323301757975, 100.32093149485857), imagePath: 'assets/first_aid_room_la_1.jpg'),

    // 33. Condo Dusita (Condo D)
    MapLocation(id: '32a', title: 'Condo Dusita', type: 'AED', description: 'เครื่อง AED ถูกติดตั้ง อยู่บริเวณหน้าทางเข้าของ Condo D', position: const LatLng(13.799755998869012, 100.32237075937972), imagePath: 'assets/aed_condo_d_1.jpg'),

    // 34. สนามแบดมินตัน และสนามเทนนิส
    MapLocation(id: '33a', title: 'สนามแบดมินตัน/เทนนิส', type: 'AED', description: 'เครื่อง AED ถูกติดตั้ง อยู่บริเวณทางเข้าของ สนามแบดมินตัน และสนามเทนนิส', position: const LatLng(13.797593376763274, 100.31938538225458), imagePath: 'assets/aed_badminton_court_1.jpg'),
  ];

  List<MapLocation> _filteredLocations = [];
  MapLocation? _selectedLocation;
  String _selectedFilter = 'All';

  @override
  void initState() {
    super.initState();
    _filteredLocations = _allLocations;
  }

  void _filterMap() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      _filteredLocations = _allLocations.where((loc) {
        bool matchesQuery = loc.title.toLowerCase().contains(query) || loc.description.toLowerCase().contains(query);
        bool matchesFilter = _selectedFilter == 'All' || loc.type == _selectedFilter;
        return matchesQuery && matchesFilter;
      }).toList();
      _selectedLocation = null;
    });
  }

  // --- ฟังก์ชันการซูมด้วยปุ่ม ---
  void _zoom(double factor) {
    double currentZoom = _mapController.camera.zoom;
    double newZoom = currentZoom + factor;
    _mapController.move(_mapController.camera.center, newZoom);
  }

  // --- ฟังก์ชันหาตำแหน่งปัจจุบัน (GPS) ---
  Future<void> _getCurrentLocation() async {
    setState(() => _isLoadingLocation = true);

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() => _isLoadingLocation = false);
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('กรุณาเปิด GPS ในมือถือ')));
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() => _isLoadingLocation = false);
        return;
      }
    }

    Position position = await Geolocator.getCurrentPosition();

    setState(() {
      _myPosition = LatLng(position.latitude, position.longitude);
      _isLoadingLocation = false;
      _mapController.move(_myPosition!, 17.5); // บินไปหาตำแหน่งพร้อมซูม
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _mapController.dispose();
    super.dispose();
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
          // 1. ตัวเครื่องยนต์แผนที่
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: const LatLng(13.7944, 100.3245), // เริ่มต้นที่มหิดลศาลายา
              initialZoom: 16.0,
              maxZoom: 19.0,
              minZoom: 13.0,
              onTap: (tapPosition, point) {
                FocusScope.of(context).unfocus();
                setState(() => _selectedLocation = null);
              },
            ),
            children: [
              // 1.1 เลเยอร์ภาพแผนที่ถนนจาก OpenStreetMap
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.musafecampus.app',
              ),
              
              // 1.2 เลเยอร์หมุดสถานที่
              MarkerLayer(
                markers: _filteredLocations.map((loc) {
                  bool isSelected = _selectedLocation?.id == loc.id;
                  return Marker(
                    point: loc.position,
                    width: 70, height: 70,
                    child: GestureDetector(
                      onTap: () {
                        FocusScope.of(context).unfocus();
                        setState(() => _selectedLocation = loc);
                        _mapController.move(loc.position, _mapController.camera.zoom); // กดแล้วเลื่อนแผนที่ให้หมุดอยู่ตรงกลาง
                      },
                      child: _buildMapPin(loc, isSelected),
                    ),
                  );
                }).toList(),
              ),

              // 1.3 เลเยอร์ตำแหน่งของฉัน
              if (_myPosition != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: _myPosition!,
                      width: 40, height: 40,
                      child: Container(
                        decoration: BoxDecoration(color: Colors.blue.withOpacity(0.3), shape: BoxShape.circle),
                        child: Center(
                          child: Container(
                            width: 16, height: 16,
                            decoration: BoxDecoration(color: Colors.blue, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),

          // 2. แถบค้นหา
          Positioned(
            top: 16, left: 16, right: 16,
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8, offset: const Offset(0, 4))]),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (val) => _filterMap(),
                    decoration: InputDecoration(
                      hintText: 'ค้นหาสถานที่', 
                      prefixIcon: const Icon(Icons.search, color: Colors.black87), 
                      suffixIcon: _searchController.text.isNotEmpty ? IconButton(icon: const Icon(Icons.clear, color: Colors.grey), onPressed: () { _searchController.clear(); _filterMap(); }) : null,
                      border: InputBorder.none, contentPadding: const EdgeInsets.symmetric(vertical: 16)
                    ),
                  ),
                ),
                const SizedBox(height: 10),
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

          // 3. ปุ่ม Zoom & My Location
          AnimatedPositioned(
            duration: const Duration(milliseconds: 250),
            bottom: _selectedLocation != null ? 280 : 30, // หลบเมื่อมีการ์ดโผล่
            right: 16,
            child: Column(
              children: [
                FloatingActionButton.small(
                  heroTag: 'zoom_in', backgroundColor: Colors.white,
                  onPressed: () => _zoom(1.0),
                  child: const Icon(Icons.add, color: Color(0xFF1D0A45)),
                ),
                const SizedBox(height: 8),
                FloatingActionButton.small(
                  heroTag: 'zoom_out', backgroundColor: Colors.white,
                  onPressed: () => _zoom(-1.0),
                  child: const Icon(Icons.remove, color: Color(0xFF1D0A45)),
                ),
                const SizedBox(height: 16),
                FloatingActionButton(
                  heroTag: 'my_loc', backgroundColor: Colors.white,
                  onPressed: _getCurrentLocation,
                  child: _isLoadingLocation 
                      ? const CircularProgressIndicator() 
                      : const Icon(Icons.my_location, color: Colors.blue, size: 28),
                ),
              ],
            ),
          ),

          // 4. การ์ดแสดงข้อมูลสถานที่
          if (_selectedLocation != null)
            Positioned(
              bottom: 0, left: 0, right: 0,
              child: _buildLocationCard(_selectedLocation!),
            ),
        ],
      ),
    );
  }

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
    );
  }

  Widget _buildMapPin(MapLocation loc, bool isSelected) {
    bool isAED = loc.type == 'AED';
    Color pinColor = isAED ? Colors.red : Colors.green;

    return AnimatedScale(
      scale: isSelected ? 1.4 : 1.0, 
      duration: const Duration(milliseconds: 200),
      alignment: Alignment.bottomCenter, // ให้ปลายหมุดชี้เป้าตรงพิกัด
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(Icons.location_on, color: pinColor, size: 60),
          Positioned(
            top: 10,
            child: Container(
              width: 18, height: 18, 
              decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle), 
              child: Icon(isAED ? Icons.favorite : Icons.add, color: pinColor, size: 14)
            ),
          )
        ],
      ),
    );
  }

  Widget _buildLocationCard(MapLocation loc) {
    bool isAED = loc.type == 'AED';
    return Container(
      padding: const EdgeInsets.all(24), // เพิ่มระยะขอบให้ดูไม่อึดอัด
      decoration: BoxDecoration(
        color: Colors.white, 
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)), 
        border: Border.all(color: Colors.black, width: 1.0), 
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 10, offset: const Offset(0, -2))]
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min, 
        children: [
          RichText(
            text: TextSpan(
              children: [
                // ขยายตัวหนังสือหัวข้อให้ใหญ่และชัดขึ้น
                TextSpan(
                  text: isAED ? 'AED station: ' : 'First Aid: ', 
                  style: const TextStyle(color: Color(0xFFAFB42B), fontSize: 24, fontWeight: FontWeight.bold) 
                ),
                TextSpan(
                  text: loc.title, 
                  style: const TextStyle(color: Colors.black, fontSize: 22, fontWeight: FontWeight.bold)
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ขยายขนาดฟอนต์คำอธิบายเป็น 16
              Expanded(
                flex: 5, 
                child: Text(loc.description, style: const TextStyle(fontSize: 16, color: Colors.black87, height: 1.5))
              ),
              const SizedBox(width: 16),
              // ขยายพื้นที่รูปภาพให้ใหญ่ขึ้น (สูง 120)
              Expanded(
                flex: 5,
                child: Container(
                  height: 120, // เพิ่มความสูงรูปภาพ
                  decoration: BoxDecoration(border: Border.all(color: Colors.black), borderRadius: BorderRadius.circular(8)),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(7), // ลบเหลี่ยมรูปภาพให้พอดีกับกรอบ
                    child: Image.asset(
                      loc.imagePath, fit: BoxFit.cover,
                      errorBuilder: (context, error, stack) => Container(
                        color: Colors.grey[200], 
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.image_not_supported, color: Colors.grey, size: 32), // ขยายไอคอนตอนไม่มีรูป
                            SizedBox(height: 4),
                            Text('No Image', style: TextStyle(fontSize: 14, color: Colors.grey))
                          ]
                        )
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // ขยายปุ่มให้กดง่ายขึ้น พร้อมฟังก์ชันนำทางไป Google Maps จริงๆ
          SizedBox(
            width: double.infinity, height: 55, // เพิ่มความสูงปุ่ม
            child: ElevatedButton(
              onPressed: () async {
                // ใช้รูปแบบมาตรฐานของ Google Maps Directions (นำทาง)
                final String mapUrl = "https://www.google.com/maps/dir/?api=1&destination=${loc.position.latitude},${loc.position.longitude}&travelmode=walking";
                final Uri url = Uri.parse(mapUrl);

                if (await canLaunchUrl(url)) {
                  // บังคับให้กระโดดไปเปิดแอป Google Maps หรือ Browser ในเครื่อง
                  await launchUrl(url, mode: LaunchMode.externalApplication);
                } else {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('ไม่สามารถเปิด Google Maps ได้'), backgroundColor: Colors.red)
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1D0A45), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
              child: const Text('เส้นทาง', style: TextStyle(color: Color(0xFFFFD700), fontSize: 24, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}