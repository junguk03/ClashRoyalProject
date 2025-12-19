import 'dart:convert';
import 'package:logger/logger.dart';

/// 환경별 로그 레벨 제어 (필요 시 수정)
class EnvLogFilter extends LogFilter {
  EnvLogFilter({
    this.enableNetwork = true,
    this.enableTrace = false,
  });

  final bool enableNetwork;
  final bool enableTrace;

  @override
  bool shouldLog(LogEvent event) {
    if (event.level == Level.trace) return enableTrace;
    return true;
  }
}

/// 전역 로거
final log = Logger(
  filter: EnvLogFilter(
    enableNetwork: const bool.fromEnvironment('LOG_NETWORK', defaultValue: true),
    enableTrace: const bool.fromEnvironment('LOG_TRACE', defaultValue: false),
  ),
  printer: PrettyPrinter(
    methodCount: 0,
    errorMethodCount: 5,
    lineLength: 110,
    colors: true,
    printEmojis: false,
    dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
  ),
);

/// 섹션 헤더/푸터
void logSection(String title, {String tag = 'APP'}) {
  final trimmed = title.trim();
  final pad = (72 - trimmed.length - tag.length - 4).clamp(0, 72);
  log.i('[$tag] == $trimmed ${'=' * pad}');
}

void logEnd({String tag = 'APP'}) {
  log.i('[$tag] ${'=' * 72}');
}

/// JSON 포맷팅
String prettyJson(Object? data, {int max = 3000}) {
  try {
    final obj = data is String ? json.decode(data) : data;
    final s = const JsonEncoder.withIndent('  ').convert(obj);
    return s.length <= max ? s : '${s.substring(0, max)} …(truncated)';
  } catch (_) {
    final s = data?.toString() ?? '';
    return s.length <= max ? s : '${s.substring(0, max)} …(truncated)';
  }
}

String oneLineJson(Object? data, {int max = 1000}) {
  try {
    final obj = data is String ? json.decode(data) : data;
    final s = json.encode(obj);
    return s.length <= max ? s : '${s.substring(0, max)} …(truncated)';
  } catch (_) {
    final s = data?.toString() ?? '';
    return s.length <= max ? s : '${s.substring(0, max)} …(truncated)';
  }
}

/// 네트워크 로그 헬퍼
class NetLog {
  static const _tag = 'NET';

  static void req({
    required String method,
    required Uri uri,
    Map<String, String>? headers,
    Object? body,
    bool verbose = false,
  }) {
    logSection('HTTP $method ${uri.path}', tag: _tag);
    log.i('[$_tag] URL: $uri');
    if (verbose && headers != null && headers.isNotEmpty) {
      log.t('[$_tag] Headers: ${oneLineJson(headers)}');
    }
    if (verbose && body != null) {
      log.t('[$_tag] Body: ${oneLineJson(body)}');
    }
  }

  static void res({
    required int status,
    Map<String, String>? headers,
    String? body,
    bool verbose = false,
  }) {
    log.i('[$_tag] Status: $status');
    if (verbose && headers != null && headers.isNotEmpty) {
      log.t('[$_tag] Resp Headers: ${oneLineJson(headers)}');
    }
    if (body != null) {
      log.d('[$_tag] Resp Body:\n${prettyJson(body)}');
    }
    logEnd(tag: _tag);
  }

  static void err(String message, {int? status, Object? details}) {
    final suffix = status != null ? ' (status=$status)' : '';
    log.e('[$_tag] HTTP Error$suffix: $message');
    if (details != null) log.t('[$_tag] Details: ${oneLineJson(details)}');
    logEnd(tag: _tag);
  }
}

/// 업로드 진행률 로그를 퍼센트 단위로만 출력
class ProgressLogger {
  ProgressLogger({this.stepPercent = 10});
  final int stepPercent;
  int _last = -1;

  void call(double progress, {String tag = 'PROG'}) {
    final p = (progress * 100).clamp(0, 100).toInt();
    final bucket = (p ~/ stepPercent) * stepPercent;
    if (bucket != _last) {
      _last = bucket;
      log.i('[$tag] $bucket%');
    }
  }
}
