# CLAUDE.md

이 파일은 Claude Code (claude.ai/code) 및 다른 작업자의 코드 수정 작업 시 참고할 가이드를 제공합니다.

---

# 코드 작성 규칙

### Rule 1: View-ViewModel-Model 분리
**View는 Model에 직접 접근하지 않고, 항상 Controller(ViewModel)를 통해서만 데이터 조회와 액션을 수행합니다.**

```dart
// ❌ Bad - View에서 Model 직접 접근
class PatientListView extends StatelessWidget {
  final List<Patient> patients;

  Widget build(BuildContext context) {
    return ListView(
      children: patients.map((patient) =>
          Text('${patient.name} - ${patient.age}세')  // Model 직접 사용
      ).toList(),
    );
  }
}

// ✅ Good - Controller를 통한 접근
class PatientListView extends GetView<PatientListController> {
  Widget build(BuildContext context) {
    return Obx(() => ListView(
      children: controller.patients.map((patient) =>
          Text(controller.getPatientDisplayText(patient))  // Controller의 ViewModel 사용
      ).toList(),
    ));
  }
}
```

**왜?**
- View는 "어떻게 보여줄지"만 관심
- Model 구조 변경 시 Controller만 수정하면 됨 (View는 무관)
- 테스트 용이성 (Controller만 독립적으로 테스트 가능)

---

### Rule 2: View는 "무엇을 보여줄지"만 관심
**View 내부에는 비즈니스 로직(조건 분기, 계산, 상태 결정)을 두지 않고, Controller에서 가공된 데이터만 사용합니다.**

**예외:**
- **애니메이션 관련 계산** (duration, curve, offset 등)은 View에서 허용
- **View에서만 사용되는 일회성 계산식**은 혼잡도를 줄이기 위해 View에 허용

```dart
// ❌ Bad - View에서 복잡한 비즈니스 로직 계산
class SoundResultView extends GetView<SoundController> {
  Widget build(BuildContext context) {
    return Obx(() {
      final detections = controller.recentResults.where((r) => r.isAuscultation).length;
      final total = controller.recentResults.length;
      final percentage = (detections / total * 100).toStringAsFixed(1);

      return Text('Detection: $detections/$total ($percentage%)');
    });
  }
}

// ✅ Good - Controller에서 계산된 값 사용
class SoundResultView extends GetView<SoundController> {
  Widget build(BuildContext context) {
    return Obx(() => Text(controller.detectionRateText));
  }
}

// Controller에서
String get detectionRateText {
  if (recentResults.isEmpty) return 'Detection rate: 0/0 (0.0%)';

  final detections = recentResults.where((r) => r.isAuscultation).length;
  final percentage = (detections / recentResults.length * 100);
  return 'Detection rate: $detections/${recentResults.length} (${percentage.toStringAsFixed(1)}%)';
}

// ✅ OK - 애니메이션 계산은 View에서 허용
AnimatedContainer(
duration: Duration(milliseconds: isExpanded ? 300 : 200),
curve: Curves.easeInOut,
height: isExpanded ? 200 : 100,
)

// ✅ OK - View에서만 사용되는 간단한 계산
Padding(
padding: EdgeInsets.only(
top: MediaQuery.of(context).padding.top + 16,
),
)
```

---

### Rule 3: Controller 주입 방식 준수
**View는 Controller를 직접 생성하지 않고, GetX의 의존성 주입 시스템(Binding)을 통해서만 사용합니다.**

```dart
// ❌ Bad - View에서 Controller 직접 생성
class MyView extends StatelessWidget {
  final controller = MyController();  // 직접 생성 금지

  Widget build(BuildContext context) {
    return Text(controller.title);
  }
}

// ✅ Good - GetView로 의존성 주입
class MyView extends GetView<MyController> {
  Widget build(BuildContext context) {
    return Obx(() => Text(controller.title));
  }
}

// Binding에서 주입
class MyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MyController>(() => MyController());
  }
}
```

**왜?**
- 생명주기 자동 관리
- 메모리 누수 방지
- 테스트 시 Mock 주입 가능

---

## 🎯 Model Layer Rules

### Rule 4: Model은 순수 데이터 구조
**Model은 상태, 타입, 인터페이스만 정의하고, 상태 변경 로직이나 비즈니스 규칙은 두지 않습니다.**

**예외:**
- **API 응답을 가공하는 계산식** (포맷팅, 변환 등)은 Model에서 허용

```dart
// ✅ OK - API 응답 가공을 위한 helper methods (Freezed private constructor 패턴)
@freezed
class Sound with _$Sound {
  const Sound._();  // Private constructor for helper methods

  const factory Sound({
    @JsonKey(name: '_id') required String id,
    required String patientId,
    required String resultType,
    required DateTime createdAt,
  }) = _Sound;

  // ✅ OK - API 데이터를 가공하는 getter는 허용
  String get statusText => resultType.toLowerCase() == 'normal' ? '정상호흡음' : '이상호흡음';

  String get formattedDate => '${createdAt.year}년 ${createdAt.month}월 ${createdAt.day}일';

  Color get statusColor => resultType.toLowerCase() == 'normal'
      ? Colors.green
      : Colors.red;

  factory Sound.fromJson(Map<String, dynamic> json) => _$SoundFromJson(json);
}

// ❌ Bad - Model에 비즈니스 로직 포함
@freezed
class Patient with _$Patient {
  const Patient._();

  const factory Patient({
    required String id,
    required String name,
    required int age,
  }) = _Patient;

  // ❌ 비즈니스 규칙은 Controller에 있어야 함
  bool get isEligibleForSurgery => age >= 18 && age <= 65;

  // ❌ 상태 변경 로직은 Controller/Service에 있어야 함
  Future<void> updateAge(int newAge) async {
    // API 호출 등...
  }

  factory Patient.fromJson(Map<String, dynamic> json) => _$PatientFromJson(json);
}

// ✅ Good - 비즈니스 로직은 Controller에
class PatientController extends GetxController {
  bool isEligibleForSurgery(Patient patient) {
    return patient.age >= 18 && patient.age <= 65;
  }

  Future<void> updatePatientAge(Patient patient, int newAge) async {
    // API 호출 등...
  }
}
```

---

### Rule 5: Enum으로 타입 안전성 확보
**도메인 값(상태, 타입 등)은 String 대신 enum으로 정의하고, 표현 로직은 Extension이나 Controller에 둡니다.**

```dart
// ✅ Good - Enum 사용
enum SoundResultType {
  normal,
  abnormal,
  unknown,
}

extension SoundResultTypeExt on SoundResultType {
  String get displayText {
    switch (this) {
      case SoundResultType.normal:
        return '정상호흡음';
      case SoundResultType.abnormal:
        return '이상호흡음';
      case SoundResultType.unknown:
        return '알 수 없음';
    }
  }

  Color get color {
    switch (this) {
      case SoundResultType.normal:
        return Colors.green;
      case SoundResultType.abnormal:
        return Colors.red;
      case SoundResultType.unknown:
        return Colors.grey;
    }
  }
}

// ❌ Bad - String으로 상태 관리
@freezed
class Sound with _$Sound {
  const factory Sound({
    required String resultType,  // 'normal', 'abnormal', 'unknown' 문자열로 관리
  }) = _Sound;
}

// View에서 매번 하드코딩
Text(
sound.resultType == 'normal' ? '정상호흡음' : '이상호흡음',
style: TextStyle(
color: sound.resultType == 'normal' ? Colors.green : Colors.red,
),
)
```

**왜?**
- 타입 안전성 (오타 방지)
- IDE 자동완성 지원
- 리팩토링 시 안전성
- 표현 로직 중앙화

---

## 🧠 Controller (ViewModel) Layer Rules

### Rule 6: Controller는 ViewModel 역할
**Controller는 Model 상태를 변경하고, View에서 바로 사용할 수 있는 형태(ViewModel)로 가공하여 반환합니다.**

```dart
// ✅ Good - Controller가 ViewModel 제공
class PatientListController extends GetxController {
  final patients = <Patient>[].obs;
  final isLoading = false.obs;

  // ViewModel - View에서 바로 사용 가능한 형태
  String get headerText => 'Total ${patients.length} patients';

  List<String> get patientDisplayNames => patients
      .map((p) => '${p.name} (${p.age}세)')
      .toList();

  bool get hasPatients => patients.isNotEmpty;

  String get emptyMessage => '등록된 환자가 없습니다';
}

// View는 단순히 표시만
class PatientListView extends GetView<PatientListController> {
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return CircularProgressIndicator();
      }

      if (!controller.hasPatients) {
        return Text(controller.emptyMessage);
      }

      return Column(
        children: [
          Text(controller.headerText),
          ...controller.patientDisplayNames.map((name) => Text(name)),
        ],
      );
    });
  }
}
```

---

### Rule 7: 표현 로직은 Controller에
**"이 값이면 이 텍스트/색상/아이콘을 쓴다"와 같은 표현 로직은 Controller에 두고, View에는 결과만 전달합니다.**

```dart
// ✅ Good - 표현 로직을 Controller에
class SoundController extends GetxController {
  final result = Rxn<Sound>();

  // 표현 로직: 상태 → 텍스트
  String get statusText {
    final sound = result.value;
    if (sound == null) return '측정 전';
    return sound.resultType == 'normal' ? '정상호흡음' : '이상호흡음';
  }

  // 표현 로직: 상태 → 색상
  Color get statusColor {
    final sound = result.value;
    if (sound == null) return Colors.grey;
    return sound.resultType == 'normal' ? Colors.green : Colors.red;
  }

  // 표현 로직: 상태 → 아이콘
  IconData get statusIcon {
    final sound = result.value;
    if (sound == null) return Icons.mic_none;
    return sound.resultType == 'normal' ? Icons.check_circle : Icons.error;
  }
}

// View는 결과만 사용
class SoundStatusView extends GetView<SoundController> {
  Widget build(BuildContext context) {
    return Obx(() => Row(
      children: [
        Icon(controller.statusIcon, color: controller.statusColor),
        Text(controller.statusText, style: TextStyle(color: controller.statusColor)),
      ],
    ));
  }
}

// ❌ Bad - View에서 표현 로직 처리
class SoundStatusView extends GetView<SoundController> {
  Widget build(BuildContext context) {
    return Obx(() {
      final sound = controller.result.value;
      final isNormal = sound?.resultType == 'normal';

      return Row(
        children: [
          Icon(
            sound == null ? Icons.mic_none : (isNormal ? Icons.check_circle : Icons.error),
            color: sound == null ? Colors.grey : (isNormal ? Colors.green : Colors.red),
          ),
          Text(
            sound == null ? '측정 전' : (isNormal ? '정상호흡음' : '이상호흡음'),
            style: TextStyle(
              color: sound == null ? Colors.grey : (isNormal ? Colors.green : Colors.red),
            ),
          ),
        ],
      );
    });
  }
}
```

---

### Rule 8: 복잡한 계산은 getter로 분리
**재사용되는 계산식·조건·포맷팅 로직은 Controller의 getter 또는 별도 메서드로 분리합니다.**

```dart
// ✅ Good - getter로 계산 로직 분리
class OnnxTestController extends GetxController {
  final recentResults = <AuscultationResult>[].obs;
  final totalProcessedSamples = 0.obs;

  // Computed property - 복잡한 계산을 getter로
  String get processingRate {
    if (totalProcessedSamples.value == 0) return '0.0 samples/sec';
    final rate = totalProcessedSamples.value / (totalProcessedSamples.value * 0.1);
    return '${rate.toStringAsFixed(1)} samples/sec';
  }

  String get detectionRate {
    if (recentResults.isEmpty) return 'Detection rate: 0/0 (0.0%)';

    final detections = recentResults.where((r) => r.isAuscultation).length;
    final percentage = (detections / recentResults.length * 100);
    return 'Detection rate: $detections/${recentResults.length} (${percentage.toStringAsFixed(1)}%)';
  }

  int get detectionCount {
    return recentResults.where((r) => r.isAuscultation).length;
  }

  double get detectionPercentage {
    if (recentResults.isEmpty) return 0.0;
    return (detectionCount / recentResults.length * 100);
  }
}

// View는 getter만 호출
class OnnxTestView extends GetView<OnnxTestController> {
  Widget build(BuildContext context) {
    return Obx(() => Column(
      children: [
        Text('Processing rate: ${controller.processingRate}'),
        Text(controller.detectionRate),
      ],
    ));
  }
}
```

---

### Rule 9: 네비게이션 로직 처리
**간단한 네비게이션은 View에서 OK, 복잡한 네비게이션(arguments, 결과 처리)은 Controller에서 처리합니다.**

```dart
// ✅ OK - 간단한 네비게이션은 View에서
ElevatedButton(
onPressed: () => Get.toNamed(Routes.SETTINGS),
child: Text('설정'),
)

// ✅ Good - 복잡한 네비게이션은 Controller에서
class PatientListController extends GetxController {
Future<void> navigateToPatientDetail(Patient patient) async {
final result = await Get.toNamed(
Routes.PATIENT_DETAIL,
arguments: {'patientId': patient.id},
);

if (result == true) {
// 환자 정보가 수정되었으면 목록 새로고침
await refreshPatients();
}
}
}

// View에서 호출
ListTile(
title: Text(patient.name),
onTap: () => controller.navigateToPatientDetail(patient),
)
```

---

## 🎨 GetX Reactive Rules

### Rule 10: Obx는 최소 범위에만 적용
**Obx는 변경되는 위젯의 최소 범위에만 적용하고, 불필요한 중첩을 피합니다.**

```dart
// ❌ Bad - Obx가 너무 넓은 범위
class MyView extends GetView<MyController> {
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(  // 전체를 Obx로 감쌈
      appBar: AppBar(title: Text('Title')),  // 정적 위젯도 포함
      body: Column(
        children: [
          Text('Static text'),  // 변경되지 않는 위젯
          Text(controller.counter.value.toString()),  // 변경되는 위젯
        ],
      ),
    ));
  }
}

// ✅ Good - 최소 범위만 Obx
class MyView extends GetView<MyController> {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Title')),
      body: Column(
        children: [
          const Text('Static text'),
          Obx(() => Text(controller.counter.value.toString())),  // 변경되는 부분만
        ],
      ),
    );
  }
}

// ❌ Bad - Obx 중첩
Obx(() => Column(
children: [
Obx(() => Text(controller.title)),  // 불필요한 중첩
Obx(() => Text(controller.subtitle)),
],
))

// ✅ Good - 하나의 Obx로
Obx(() => Column(
children: [
Text(controller.title),
Text(controller.subtitle),
],
))
```

---

### Rule 11: GetxController 생명주기 활용
**리소스 정리는 반드시 onClose에서 수행합니다.**

```dart
// ✅ Good - 생명주기 메서드 활용
class SoundController extends GetxController {
  final _audioRecorder = AudioRecorder();
  StreamSubscription? _subscription;

  @override
  void onInit() {
    super.onInit();
    _initializeRecorder();
  }

  @override
  void onClose() {
    // 리소스 정리
    _subscription?.cancel();
    _audioRecorder.dispose();
    super.onClose();
  }
}
```

---

## 📦 Constants & Utilities Rules

### Rule 12: 매직 넘버/스트링 금지
**화면 여백을 제외한 모든 의미 있는 값은 반드시 이름 있는 const로 정의합니다.**

```dart
// ❌ Bad - 매직 넘버/스트링
if (patient.age >= 65) {  // 65가 무엇을 의미하는지?
showWarning('고령 환자입니다');
}

if (sound.resultType == 'abnormal') {  // 오타 가능성
alertDoctor();
}

// ✅ Good - 상수로 정의
class PatientConstants {
static const int seniorAgeThreshold = 65;
static const String seniorWarningMessage = '고령 환자입니다';
}

if (patient.age >= PatientConstants.seniorAgeThreshold) {
showWarning(PatientConstants.seniorWarningMessage);
}

// 더 좋음 - Enum 사용
enum SoundResultType { normal, abnormal, unknown }
if (sound.resultType == SoundResultType.abnormal) {
alertDoctor();
}

// ✅ OK - 화면 여백은 직접 사용 가능
Padding(
padding: const EdgeInsets.all(16),
child: Text('Content'),
)
```

---

### Rule 13: 상수는 도메인별로 분리
**도메인별 상수는 전용 constants 파일에 모아서 관리합니다.**

#### Constants 폴더 구조 전략

**1. 전역 Constants (`lib/app/constants/`)**
- 여러 feature에서 공통 사용되는 상수
- 앱 전체 설정
- 도메인별로 명확한 파일명 사용

```
lib/app/constants/
├── api_constants.dart          # API 관련 (baseUrl, timeout, pagination)
├── app_constants.dart          # 앱 설정 (version, name 등)
├── theme_constants.dart        # 색상, 폰트 등
└── validation_constants.dart   # 전역 유효성 검증 규칙
```

**2. 기능별 Constants (`lib/app/features/[feature]/constants/`)**
- 특정 feature에서만 사용되는 상수
- 도메인 특화 값
- feature 이름을 prefix로 사용

```
lib/app/features/patient/constants/
└── patient_constants.dart      # Patient feature 전용

lib/app/features/sound/constants/
└── sound_constants.dart        # Sound feature 전용
```

#### 분류 기준

| 조건 | 위치 | 예시 |
|------|------|------|
| 2개 이상 feature에서 사용 | `lib/app/constants/` | API URL, 테마 색상, 페이지네이션 |
| 앱 전체 설정 | `lib/app/constants/` | 앱 버전, 타임아웃 |
| 특정 feature에서만 사용 | `lib/app/features/[feature]/constants/` | 환자 나이 제한, 녹음 길이 제한 |
| 도메인 특화 규칙 | `lib/app/features/[feature]/constants/` | 증상 리스트, 분류 타입 |

#### 실제 예시

```dart
// ✅ Good - 전역 Constants (lib/app/constants/api_constants.dart)
class ApiConstants {
  // API 기본 설정
  static const String baseUrl = 'http://192.168.1.102:3001';
  static const Duration requestTimeout = Duration(seconds: 30);

  // 페이지네이션 기본값 (여러 service에서 공통 사용)
  static const int defaultPage = 1;
  static const int defaultLimit = 10;
  static const int patientSoundsLimit = 20;
  static const String defaultSortBy = 'createdAt';
  static const String defaultOrder = 'desc';
}

// ✅ Good - 기능별 Constants (lib/app/features/patient/constants/patient_constants.dart)
class PatientConstants {
  static const int minAge = 0;
  static const int maxAge = 120;
  static const int seniorAgeThreshold = 65;
  static const List<String> sexTypes = ['M', 'F', 'OTHER'];
}

// ✅ Good - 기능별 Constants (lib/app/features/sound/constants/sound_constants.dart)
class SoundConstants {
  static const int maxRecordingDuration = 300; // 5분
  static const int sampleRate = 16000;
  static const int bufferSize = 16000;
  static const double confidenceThreshold = 0.7;
  static const List<String> allowedFormats = ['wav', 'mp3'];
}

// 사용 예시
// patient_service.dart
import '../../constants/api_constants.dart';

Future<PatientsResponse?> getPatients({
  int page = ApiConstants.defaultPage,
  int limit = ApiConstants.defaultLimit,
  String sortBy = ApiConstants.defaultSortBy,
  String order = ApiConstants.defaultOrder,
}) async {
  // ...
}

// patient_controller.dart
import '../../constants/api_constants.dart';
import '../constants/patient_constants.dart';

class PatientController extends GetxController {
  Future<void> loadPatients() async {
    final response = await service.getPatients(
      page: ApiConstants.defaultPage,
      limit: ApiConstants.defaultLimit,
    );

    if (patient.age >= PatientConstants.seniorAgeThreshold) {
      // 고령 환자 처리
    }
  }
}
```

#### 네이밍 규칙

| 위치 | 파일명 | 클래스명 | 예시 |
|------|--------|----------|------|
| 전역 | `{domain}_constants.dart` | `{Domain}Constants` | `api_constants.dart` → `ApiConstants` |
| 기능별 | `{feature}_constants.dart` | `{Feature}Constants` | `patient_constants.dart` → `PatientConstants` |

**❌ Bad - 일반적인 이름 사용**
```dart
// lib/app/features/patient/constants/constants.dart  // ❌ 너무 일반적
// lib/app/features/sound/constants/constants.dart    // ❌ 이름 충돌 가능

// import 시 혼란
import '../../constants/constants.dart' as GlobalConstants;
import '../constants/constants.dart' as LocalConstants;
```

**왜 도메인별로 분리하는가?**
- 명확성: import만 봐도 어떤 상수인지 알 수 있음
- 충돌 방지: 서로 다른 이름으로 충돌 없음
- IDE 지원: 자동완성 시 도메인별로 그룹화됨
- 유지보수: 파일 이름만 봐도 내용을 예측 가능

---

### Rule 14: 재사용 로직은 Extension으로
**재사용되는 문자열 변환·포맷팅 로직은 Extension으로 분리합니다.**

```dart
// ✅ Good - Extension으로 재사용 로직 분리
extension DateTimeExt on DateTime {
  String toKoreanFormat() {
    return '$year년 $month월 $day일';
  }

  String toDisplayFormat() {
    return '${year.toString().padLeft(4, '0')}-'
           '${month.toString().padLeft(2, '0')}-'
           '${day.toString().padLeft(2, '0')}';
  }
}

extension StringExt on String {
  String toPhoneFormat() {
    if (length == 11) {
      return '${substring(0, 3)}-${substring(3, 7)}-${substring(7)}';
    }
    return this;
  }
}

// 사용
Text(patient.createdAt.toKoreanFormat());
Text(patient.phoneNumber.toPhoneFormat());

// ❌ Bad - Controller에 반복적인 포맷팅 로직
class PatientController extends GetxController {
  String formatDate(DateTime date) {
    return '${date.year}년 ${date.month}월 ${date.day}일';
  }

  String formatPhone(String phone) {
    if (phone.length == 11) {
      return '${phone.substring(0, 3)}-${phone.substring(3, 7)}-${phone.substring(7)}';
    }
    return phone;
  }
}
```

---

### Rule 15: 유틸리티 함수 분리
**완전히 범용적인 로직은 utils에, 도메인 종속 로직은 Controller에 둡니다.**

```dart
// ✅ Good - 범용 로직은 utils에
// lib/app/utils/date_utils.dart
class DateUtils {
  static bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  static int daysBetween(DateTime from, DateTime to) {
    return to.difference(from).inDays;
  }
}

// ✅ Good - 도메인 종속 로직은 Controller에
class PatientController extends GetxController {
  bool isPatientEligibleForSurgery(Patient patient) {
    return patient.age >= 18 &&
           patient.age <= 65 &&
           patient.hasValidInsurance;
  }
}
```

---

## 🚫 Anti-Patterns (금지 사항)

### Rule 16: StatefulWidget과 GetX 혼용 금지
**GetX Controller를 사용하는 화면은 StatelessWidget 또는 GetView만 사용합니다.**

```dart
// ❌ Bad - StatefulWidget + GetX 혼용
class MyView extends StatefulWidget {
  @override
  State<MyView> createState() => _MyViewState();
}

class _MyViewState extends State<MyView> {
  final controller = Get.find<MyController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() => Text(controller.title));
  }
}

// ✅ Good - GetView 사용
class MyView extends GetView<MyController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() => Text(controller.title));
  }
}
```

**왜?**
- 상태 관리 방식 혼재로 인한 혼란
- GetX의 생명주기 관리 이점 상실
- 불필요한 복잡성

---

### Rule 17: View에서 API 직접 호출 금지
**View는 절대 API나 Service를 직접 호출하지 않습니다. 모든 데이터 요청은 Controller를 통합니다.**

```dart
// ❌ Bad - View에서 API 직접 호출
class PatientListView extends StatelessWidget {
  final apiClient = Get.find<ApiClient>();

  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        final patients = await apiClient.getPatients();  // View에서 API 호출
        // ...
      },
      child: Text('Load'),
    );
  }
}

// ✅ Good - Controller를 통한 호출
class PatientListView extends GetView<PatientListController> {
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: controller.loadPatients,  // Controller 메서드 호출
      child: Text('Load'),
    );
  }
}

class PatientListController extends GetxController {
  Future<void> loadPatients() async {
    isLoading.value = true;
    try {
      final result = await apiClient.getPatients();
      patients.value = result;
    } catch (e) {
      log.e('Failed to load patients: $e');
      Get.snackbar('Error', 'Failed to load patients');
    } finally {
      isLoading.value = false;
    }
  }
}
```

---

### Rule 18: BuildContext를 Controller에 저장 금지
**BuildContext를 Controller의 멤버 변수로 저장하면 메모리 누수가 발생합니다.**

```dart
// ❌ Bad - BuildContext를 Controller에 저장
class MyController extends GetxController {
  late BuildContext context;  // 메모리 누수 발생

  void init(BuildContext ctx) {
    context = ctx;
  }

  void showDialog() {
    showDialog(context: context, builder: ...);  // 위험
  }
}

// ✅ Good - BuildContext를 파라미터로 전달
class MyController extends GetxController {
  void showDialog(BuildContext context) {
    showDialog(context: context, builder: ...);
  }
}

// 또는 GetX의 dialog 사용 (context 불필요)
void showMessage() {
  Get.dialog(AlertDialog(...));
}
```

---

## 📊 Code Quality Rules

### Rule 19: DRY (Don't Repeat Yourself)
**동일한 조건식·계산식이 두 번 이상 등장하면, 반드시 공통 함수로 추출합니다.**

```dart
// ❌ Bad - 중복 코드
class PatientView extends GetView<PatientController> {
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (controller.patient.value?.age != null &&
            controller.patient.value!.age >= 65)
          Text('고령 환자'),

        ElevatedButton(
          onPressed: controller.patient.value?.age != null &&
                     controller.patient.value!.age >= 65
              ? null
              : controller.doSomething,
          child: Text('Action'),
        ),
      ],
    );
  }
}

// ✅ Good - 공통 함수로 추출
class PatientController extends GetxController {
  final patient = Rxn<Patient>();

  bool get isSenior {
    final age = patient.value?.age;
    return age != null && age >= 65;
  }
}

class PatientView extends GetView<PatientController> {
  Widget build(BuildContext context) {
    return Obx(() => Column(
      children: [
        if (controller.isSenior) Text('고령 환자'),

        ElevatedButton(
          onPressed: controller.isSenior ? null : controller.doSomething,
          child: Text('Action'),
        ),
      ],
    ));
  }
}
```

---

### Rule 20: Early Return 패턴 사용
**if 중첩을 최소화하고, Guard Clause 패턴(Early Return)을 적극 활용합니다.**

```dart
// ❌ Bad - if 중첩
String processPatientData(Patient? patient) {
  if (patient != null) {
    if (patient.name != null) {
      if (patient.name.isNotEmpty) {
        if (patient.age != null) {
          return '${patient.name} (${patient.age}세)';
        } else {
          return 'Age missing';
        }
      } else {
        return 'Empty name';
      }
    } else {
      return 'No name';
    }
  } else {
    return 'No patient';
  }
}

// ✅ Good - Early return으로 평탄화
String processPatientData(Patient? patient) {
  if (patient == null) return 'No patient';
  if (patient.name == null) return 'No name';
  if (patient.name.isEmpty) return 'Empty name';
  if (patient.age == null) return 'Age missing';

  return '${patient.name} (${patient.age}세)';
}

// ✅ Good - Early return in async
Future<void> loadData() async {
  if (!await checkPermission()) return;
  if (!await checkNetwork()) return;
  if (!isInitialized) return;

  // 실제 작업
  await fetchData();
}
```

**왜?**
- 코드 가독성 향상
- 중첩 깊이 감소
- 에러 케이스를 먼저 처리 → 정상 플로우가 명확

---

### Rule 21: Null Safety 준수
**Null 가능성이 있는 값은 반드시 null check를 수행하거나 ?? 연산자로 기본값을 제공합니다.**

```dart
// ✅ Good - Null safety 준수
String getPatientName(Patient? patient) {
  return patient?.name ?? 'Unknown';
}

int getAge(Patient? patient) {
  final age = patient?.age;
  if (age == null) return 0;
  return age;
}

// Null-aware cascade
patient
  ?..name = 'John'
  ..age = 30;

// Collection null safety
final names = patients?.map((p) => p.name).toList() ?? [];
```

---

### Rule 22: Error Handling & Logging
**모든 async 메서드는 try-catch로 에러를 처리하고, Logger를 사용해 로깅합니다. print() 사용 금지.**

```dart
// ✅ Good - Proper error handling + Logger 사용
class PatientController extends GetxController {
  Future<void> loadPatients() async {
    try {
      isLoading.value = true;
      log.i('Loading patients started');

      final result = await apiClient.getPatients();
      patients.value = result;

      log.i('Patients loaded successfully: ${result.length} items');
    } on NetworkException catch (e) {
      log.e('Network error while loading patients: $e');
      Get.snackbar('Error', 'Network connection failed');
    } on ApiException catch (e) {
      log.e('API error: ${e.message}', error: e);
      Get.snackbar('Error', e.message);
    } catch (e, stackTrace) {
      log.e('Unexpected error while loading patients', error: e, stackTrace: stackTrace);
      Get.snackbar('Error', 'An unexpected error occurred');
    } finally {
      isLoading.value = false;
    }
  }
}

// Logger 사용 예제
log.d('Debug info: $debugData');         // Debug
log.i('User logged in: ${user.name}');   // Info
log.w('Warning: Low memory');            // Warning
log.e('Error occurred: $error');         // Error

// ❌ Bad - print() 사용
Future<void> loadData() async {
  print('Loading...');  // 금지
  final data = await fetch();
  print('Done: $data');  // 금지
}
```

---

## 📱 UI/UX Rules

### Rule 23: Loading State 표시
**비동기 작업 중에는 반드시 로딩 상태를 사용자에게 보여줍니다.**

```dart
// ✅ Good - Loading state 표시
class PatientListView extends GetView<PatientListController> {
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return Center(child: CircularProgressIndicator());
      }

      return ListView.builder(
        itemCount: controller.patients.length,
        itemBuilder: (context, index) => PatientTile(controller.patients[index]),
      );
    });
  }
}

// Controller
class PatientListController extends GetxController {
  final isLoading = false.obs;
  final patients = <Patient>[].obs;

  Future<void> loadPatients() async {
    isLoading.value = true;
    try {
      final result = await apiClient.getPatients();
      patients.value = result;
    } finally {
      isLoading.value = false;
    }
  }
}
```

---

### Rule 24: Empty State 처리
**데이터가 없을 때는 명확한 Empty State를 보여줍니다.**

```dart
// ✅ Good - Empty state 처리
class PatientListView extends GetView<PatientListController> {
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return Center(child: CircularProgressIndicator());
      }

      if (controller.patients.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.people_outline, size: 64, color: Colors.grey),
              SizedBox(height: 16),
              Text('등록된 환자가 없습니다'),
              SizedBox(height: 8),
              ElevatedButton(
                onPressed: controller.loadPatients,
                child: Text('새로고침'),
              ),
            ],
          ),
        );
      }

      return ListView.builder(
        itemCount: controller.patients.length,
        itemBuilder: (context, index) => PatientTile(controller.patients[index]),
      );
    });
  }
}
```

---

### Rule 25: Single Responsibility (단일 책임 원칙)
**하나의 Controller/Method/Class는 하나의 명확한 책임만 가져야 합니다.**

```dart
// ❌ Bad - UserController가 너무 많은 책임을 가짐
class UserController extends GetxController {
  // User profile 관리
  final user = Rxn<User>();
  void updateProfile() { }

  // 인증 관리
  void login() { }
  void logout() { }

  // 알림 관리
  void sendNotification() { }
  void getNotifications() { }

  // 결제 관리
  void processPayment() { }
}

// ✅ Good - 책임을 분리
class UserProfileController extends GetxController {
  final user = Rxn<User>();

  Future<void> loadProfile() async {
    // 프로필 로드
  }

  Future<void> updateProfile(User updatedUser) async {
    // 프로필 업데이트
  }
}

class AuthController extends GetxController {
  final isAuthenticated = false.obs;

  Future<void> login(String email, String password) async {
    // 로그인 처리
  }

  Future<void> logout() async {
    // 로그아웃 처리
  }
}

class NotificationController extends GetxController {
  final notifications = <Notification>[].obs;

  Future<void> loadNotifications() async {
    // 알림 로드
  }
}
```

**왜?**
- 코드 유지보수성 향상
- 테스트 용이성
- 변경의 영향 범위 최소화
- 코드 재사용성 증가

---

### Rule 26: Command-Query Separation (명령-조회 분리)
**메서드는 "상태를 변경하는 명령(Command)" 또는 "값을 반환하는 조회(Query)" 중 하나만 수행해야 합니다.**

**참고:** 이 원칙은 이상적인 가이드라인입니다. 실무에서는 완벽히 지키기 어려울 수 있지만, 가능한 한 지향하는 것을 권장합니다.

```dart
// ❌ Bad - 상태 변경과 값 반환을 동시에 수행
class PatientController extends GetxController {
  final patients = <Patient>[].obs;

  // 환자를 추가하면서 동시에 추가된 환자를 반환
  Patient addPatient(Patient patient) {
    patients.add(patient);
    return patient;  // 명령과 조회가 섞임
  }
}

// ✅ Good - 명령과 조회 분리
class PatientController extends GetxController {
  final patients = <Patient>[].obs;

  // Command - 상태만 변경
  void addPatient(Patient patient) {
    patients.add(patient);
  }

  // Query - 값만 반환 (상태 변경 없음)
  Patient? getPatientById(String id) {
    return patients.firstWhereOrNull((p) => p.id == id);
  }

  // Query - getter는 항상 조회만
  int get patientCount => patients.length;
  bool get hasPatients => patients.isNotEmpty;
}

// ✅ Good - 비동기 작업도 동일하게 적용
class SoundController extends GetxController {
  final sounds = <Sound>[].obs;
  final isLoading = false.obs;

  // Command - API 호출 후 상태 변경
  Future<void> loadSounds(String patientId) async {
    try {
      isLoading.value = true;
      final result = await soundService.getSounds(patientId);
      sounds.value = result;
    } finally {
      isLoading.value = false;
    }
  }

  // Query - 현재 상태에서 값만 계산
  List<Sound> getAbnormalSounds() {
    return sounds.where((s) => s.resultType == 'abnormal').toList();
  }
}
```

**왜?**
- 예측 가능한 코드: getter는 "안전"하다는 것을 보장
- 부작용(side effect) 최소화
- 코드 의도가 명확해짐
- 디버깅 용이

**실무 팁:**
- 완벽하게 지키기 어려운 경우(예: 캐시 업데이트)도 있지만, 가능한 한 지향하세요
- 부득이하게 섞는 경우 메서드명에 명시 (예: `fetchAndCacheData()`)

---

### Rule 27: Immutable First (불변성 우선)
**변수는 기본적으로 `final`로 선언하고, 반드시 변경이 필요한 경우만 `var`과 `.obs`를 사용합니다.**

```dart
// ✅ Good - final 우선 사용
class PatientController extends GetxController {
  // Services는 변경되지 않으므로 final
  final PatientService _patientService = Get.find();
  final ApiClient _apiClient = Get.find();

  // 상수는 항상 final
  final int maxRetryAttempts = 3;
  final Duration requestTimeout = Duration(seconds: 30);

  // 반응형 상태만 .obs
  final patients = <Patient>[].obs;
  final isLoading = false.obs;
  final selectedPatient = Rxn<Patient>();

  // ❌ Bad - 불필요한 var 사용
  // var retryCount = 3;  // 변경할 필요 없으면 final 사용

  Future<void> loadPatients() async {
    // 지역 변수도 가능하면 final
    final result = await _patientService.getPatients();
    patients.value = result;
  }
}

// ✅ Good - Model은 불변 객체
@freezed
class Patient with _$Patient {
  const factory Patient({
    required String id,
    required String name,
    required int age,
  }) = _Patient;

  // 상태 변경이 필요하면 copyWith 사용
  // patient.copyWith(age: 30)
}

// ❌ Bad - 가변 Model
class Patient {
  String id;
  String name;
  int age;  // 직접 수정 가능 → 예측 불가능

  Patient({required this.id, required this.name, required this.age});
}
```

**왜?**
- 예측 가능한 코드
- 의도하지 않은 상태 변경 방지
- 디버깅 용이 (어디서 변경되는지 명확)
- Thread-safe (멀티스레드 환경에서 안전)

**규칙:**
1. 기본은 `final`
2. UI에 반영되어야 하는 상태만 `.obs`
3. 절대 변경되지 않는 값은 `const`

---

### Rule 28: Consistent Naming Convention (일관된 네이밍)
**프로젝트 전체에서 일관된 명명 규칙을 따라야 합니다.**

```dart
// ✅ Good - Boolean 변수는 is/has/can으로 시작
class PatientController extends GetxController {
  final isLoading = false.obs;
  final hasError = false.obs;
  final canEdit = true.obs;

  bool get isAuthenticated => authService.isLoggedIn;
  bool get hasPatients => patients.isNotEmpty;
  bool get canDeletePatient => user.role == 'ADMIN';
}

// ✅ Good - Async 메서드는 동사로 시작
class SoundController extends GetxController {
  Future<void> loadSounds() async { }      // 데이터 불러오기
  Future<void> saveSoundData() async { }   // 데이터 저장
  Future<void> deleteSoundData() async { } // 데이터 삭제
  Future<void> uploadAudio() async { }     // 파일 업로드
  Future<void> fetchResults() async { }    // API 결과 가져오기
}

// ✅ Good - Event handler는 on으로 시작
class HomeView extends GetView<HomeController> {
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => controller.onLoginPressed(),
      child: Text('로그인'),
    );
  }
}

class HomeController extends GetxController {
  void onLoginPressed() { }
  void onPatientSelected(Patient patient) { }
  void onRefreshRequested() { }
}

// ✅ Good - Private 변수는 언더스코어
class AuthController extends GetxController {
  final AuthService _authService = Get.find();
  final ApiClient _apiClient = Get.find();

  String? _cachedToken;

  void _refreshToken() { }
  Future<void> _validateSession() async { }
}

// ✅ Good - CRUD 메서드 네이밍
class PatientService {
  // Create
  Future<Patient> createPatient(Patient patient) async { }
  Future<void> addPatient(Patient patient) async { }

  // Read
  Future<Patient> getPatient(String id) async { }
  Future<List<Patient>> fetchPatients() async { }
  Future<void> loadPatients() async { }

  // Update
  Future<void> updatePatient(Patient patient) async { }
  Future<void> editPatient(String id, Patient patient) async { }

  // Delete
  Future<void> deletePatient(String id) async { }
  Future<void> removePatient(String id) async { }
}

// ✅ Good - Getter는 명사 또는 형용사
class PatientController extends GetxController {
  // 명사형
  String get patientName => selectedPatient?.name ?? 'Unknown';
  int get patientCount => patients.length;
  List<String> get patientNames => patients.map((p) => p.name).toList();

  // 형용사형 (boolean)
  bool get isEmpty => patients.isEmpty;
  bool get isValid => selectedPatient != null;
}

// ❌ Bad - 일관성 없는 네이밍
class BadController extends GetxController {
  final loading = false.obs;  // isLoading이 더 명확
  final error = false.obs;    // hasError가 더 명확

  void getData() { }          // loadData가 더 명확
  void press() { }            // onButtonPressed가 더 명확
  void del(String id) { }     // deletePatient가 더 명확
}
```

**네이밍 규칙 요약:**

| 대상 | 규칙 | 예시 |
|------|------|------|
| Boolean 변수/getter | `is`, `has`, `can` | `isLoading`, `hasError`, `canEdit` |
| Async 메서드 | 동사 시작 | `loadData`, `fetchUsers`, `saveFile` |
| Event handler | `on` + 동사 | `onPressed`, `onTap`, `onChanged` |
| Private 멤버 | `_` prefix | `_apiClient`, `_refreshToken` |
| Getter | 명사/형용사 | `patientName`, `isEmpty`, `totalCount` |
| CRUD - Create | `create`, `add` | `createPatient`, `addUser` |
| CRUD - Read | `get`, `fetch`, `load` | `getPatient`, `fetchData`, `loadUsers` |
| CRUD - Update | `update`, `edit`, `save` | `updateProfile`, `editPatient` |
| CRUD - Delete | `delete`, `remove` | `deletePatient`, `removeItem` |

**왜?**
- 코드 가독성 향상
- 팀원 간 커뮤니케이션 개선
- IDE 자동완성 효율성
- 코드 리뷰 시간 단축

---

### Rule 29: 타입 캐스팅 시 `as` 사용 지양

**`as` 연산자는 타입 캐스팅에 실패하면 런타임 에러를 발생시킵니다. 가능한 한 `is` 연산자로 타입을 먼저 확인하거나, 안전한 대안을 사용하세요.**

```dart
// ❌ Bad - as 연산자로 직접 캐스팅 (런타임 에러 위험)
void processData(dynamic data) {
  final user = data as User;  // data가 User가 아니면 에러 발생!
  print(user.name);
}

// ❌ Bad - JSON 파싱 시 as 남용
final name = json['name'] as String;  // null이거나 다른 타입이면 에러
final age = json['age'] as int;

// ✅ Good - is 연산자로 타입 확인 후 사용
void processData(dynamic data) {
  if (data is User) {
    print(data.name);  // 타입 프로모션으로 안전하게 사용
  } else {
    print('Invalid data type');
  }
}

// ✅ Good - 패턴 매칭 사용 (Dart 3.0+)
void processData(dynamic data) {
  if (data case User user) {
    print(user.name);
  }
}

// ✅ Good - JSON 파싱 시 안전한 변환
final name = json['name'] as String?;  // nullable로 캐스팅
final age = (json['age'] as num?)?.toInt();  // num을 거쳐 안전하게 변환

// ✅ Good - whereType으로 컬렉션 필터링
final users = items.whereType<User>();  // as 없이 타입별 필터링

// ❌ Bad - cast() 사용 (모든 요소마다 타입 체크)
final numbers = items.cast<int>();  // 매번 런타임 체크, 성능 저하

// ✅ Good - List.from() 또는 타입 지정 생성자 사용
final numbers = List<int>.from(items);  // 한 번만 변환
final numbers = items.map((e) => e as int).toList();  // 명시적 변환

// ✅ Better - 처음부터 올바른 타입으로 생성
final numbers = <int>[1, 2, 3];

// ❌ Bad - Get.arguments에서 as 남용
class MyController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    final userId = Get.arguments as String;  // 에러 위험
    final data = Get.arguments as Map<String, dynamic>;  // 에러 위험
  }
}

// ✅ Good - 타입 체크와 기본값 제공
class MyController extends GetxController {
  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments;

    // 방법 1: is로 타입 확인
    if (args is String) {
      final userId = args;
      // userId 사용
    }

    // 방법 2: Map인 경우 안전하게 추출
    if (args is Map) {
      final userId = args['userId'] as String?;
      final data = args['data'] as Map<String, dynamic>?;

      if (userId != null && data != null) {
        // 안전하게 사용
      } else {
        log.e('Invalid arguments');
        Get.back();
      }
    }
  }
}

```

**예외 상황 - as 사용이 허용되는 경우:**

```dart
// ✅ OK - 타입이 보장된 경우 (validation 직후)
final args = Get.arguments;
if (args is Map) {
  final data = args['key'] as ExpectedType;  // Map임이 확인됨
}

// ✅ OK - fromJson 등 타입 변환 메서드 내부
factory User.fromJson(Map<String, dynamic> json) {
  return User(
    name: json['name'] as String,  // JSON 스키마가 보장됨
    age: json['age'] as int,
  );
}

// ✅ OK - private 메서드 내부에서 타입이 보장된 경우
void _processValidatedData(dynamic data) {
  // 외부에서 이미 타입 검증 완료
  final user = data as User;
  // ...
}
```

**컬렉션 타입 변환 우선순위:**

1. **최우선**: 처음부터 올바른 타입으로 생성
2. **추천**: `List<T>.from()`, `Set<T>.from()`, `Map<K, V>.from()`
3. **조건부**: `whereType<T>()` (필터링이 필요한 경우)
4. **지양**: `.cast<T>()` (lazy validation으로 성능 저하)

**왜?**
- **런타임 에러 방지**: `as`는 실패 시 즉시 크래시
- **명시적 에러 처리**: `is` 체크로 예외 상황 대응 가능
- **타입 안전성**: 컴파일 타임에 더 많은 에러 발견
- **성능**: `cast()`는 모든 요소마다 타입 체크 (overhead)
- **유지보수성**: 타입 관련 버그 감소

**참고:**
- 플러터 코딩 컨벤션 한국어 정리 : (https://mingzan.tistory.com/249)
- Dart 공식 문서 : (https://dart.dev/tools/linter-rules)

