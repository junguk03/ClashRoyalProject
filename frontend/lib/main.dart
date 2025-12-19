import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:clash_royale_history/app/api/bindings/api_binding.dart';
import 'package:clash_royale_history/app/api/config/api_config.dart';
import 'package:clash_royale_history/app/routes/app_pages.dart';
import 'package:clash_royale_history/app/routes/app_routes.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';

Locale? _savedLocale;

Future<void> main() async {
  // 스플래시 화면 유지 (초기화 완료까지)
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // 환경변수 로드
  await dotenv.load(fileName: '.env');

  // API 키 설정
  final apiKey = dotenv.env['CR_API_KEY'] ?? '';
  if (apiKey.isNotEmpty) {
    ApiConfig.setApiKey(apiKey);
  }

  // 상태바 스타일 설정
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Color.fromARGB(0, 76, 60, 60),
      // 스플래시 배경색이 파란색이므로 light
      statusBarIconBrightness: Brightness.light,
      // iOS용
      statusBarBrightness: Brightness.dark,
    ),
  );

  // API 서비스 초기화
  ApiBinding().dependencies();

  runApp(const MyApp());

  // 첫 프레임 렌더링 완료 후 즉시 스플래시 제거
  FlutterNativeSplash.remove();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "GetX_Base_Project",
      locale: _savedLocale ?? Get.deviceLocale,
      fallbackLocale: const Locale('ko', 'KR'),
      initialRoute: AppRoutes.home,
      getPages: AppPages.pages,
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(
          context,
        ).copyWith(textScaler: const TextScaler.linear(1.0)),
        child: child!,
      ),
    );
  }
}
