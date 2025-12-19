import 'package:get/get.dart';

import 'ko_kr.dart';
import 'en_us.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'ko_KR': koKR,
        'en_US': enUS,
      };
}
