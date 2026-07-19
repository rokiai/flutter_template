import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'analytics_port.g.dart';

abstract interface class AnalyticsPort {
  Future<void> logEvent(String name, {Map<String, Object?>? params});

  Future<void> setUserId(String? userId);
}

class NoopAnalytics implements AnalyticsPort {
  const NoopAnalytics();

  @override
  Future<void> logEvent(String name, {Map<String, Object?>? params}) async {}

  @override
  Future<void> setUserId(String? userId) async {}
}

@Riverpod(keepAlive: true)
AnalyticsPort analytics(Ref ref) => const NoopAnalytics();
