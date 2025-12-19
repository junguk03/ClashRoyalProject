# Flutter GetX Base

Flutter + GetX 기반 프로젝트 템플릿

## 프로젝트 구조

```text
lib/
├── main.dart                    # 앱 진입점
├── app.dart                     # GetMaterialApp 설정
├── core/
│   ├── di/
│   │   └── initial_binding.dart # 전역 의존성 주입
│   └── theme/
│       ├── app_colors.dart      # 색상 상수
│       ├── app_text_styles.dart # 텍스트 스타일
│       └── app_theme.dart       # 테마 설정
├── routes/
│   ├── app_routes.dart          # 라우트 경로 상수
│   └── app_pages.dart           # GetPage 정의
└── feature/
    └── home/
        ├── home_binding.dart    # 의존성 바인딩
        ├── home_controller.dart # GetxController
        └── home_page.dart       # GetView UI
```

## 사용 기술

- Flutter SDK >= 3.0.0
- GetX 4.6.6 (상태 관리, 라우팅, DI)
- Pretendard 폰트

## 시작하기

```bash
# 의존성 설치
flutter pub get

# 실행
flutter run
```

## 새 Feature 추가 방법

1. `lib/feature/` 하위에 폴더 생성
2. `*_binding.dart`, `*_controller.dart`, `*_page.dart` 생성
3. `lib/routes/app_routes.dart`에 경로 추가
4. `lib/routes/app_pages.dart`에 GetPage 추가

```dart
// app_routes.dart
static const example = '/example';

// app_pages.dart
GetPage(
  name: AppRoutes.example,
  page: () => const ExamplePage(),
  binding: ExampleBinding(),
),
```
