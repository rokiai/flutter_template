import 'package:flutter/foundation.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import '../../../environment/env.dart';
import '../../../environment/flavor.dart';
import '../../../utils/app_talker.dart';

Future<void> initSentry(Future<void> Function() appRunner) async {
  final dsn = Env.sentryDsn.trim();
  if (dsn.isEmpty) {
    talker.info('Sentry DSN empty — skip Sentry init');
    await appRunner();
    return;
  }

  await SentryFlutter.init(
    (options) {
      options.dsn = dsn;
      options.environment = FlavorConfig.flavor.name;
      options.tracesSampleRate = kReleaseMode ? 0.2 : 1.0;
      options.enableAutoSessionTracking = true;
    },
    appRunner: appRunner,
  );
}
