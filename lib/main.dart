import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'environment/flavor.dart';
import 'extensions/build_context_extension.dart';
import 'features/common/monitoring/sentry_init.dart';
import 'features/common/ui/providers/app_locale_provider.dart';
import 'features/common/ui/providers/app_theme_mode_provider.dart';
import 'features/common/ui/widgets/offline_container.dart';
import 'features/common/ui/widgets/talker_overlay.dart';
import 'l10n/app_localizations.dart';
import 'routing/app_router.dart';
import 'utils/app_talker.dart';
import 'utils/provider_observer.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  _ignoreWebStartupFocusRace();

  await initSentry(() async {
    talker.info('Starting app flavor=${FlavorConfig.flavor.name}');

    LicenseRegistry.addLicense(() async* {
      final license = await rootBundle.loadString('assets/google_fonts/OFL.txt');
      yield LicenseEntryWithLineBreaks(['google_fonts'], license);
    });

    runApp(
      ProviderScope(
        observers: [AppObserver()],
        child: const MainApp(),
      ),
    );
  });
}

/// Flutter web can throw `_RenderTheater hasSize` during the first focus pass
/// before layout finishes (https://github.com/flutter/flutter/issues/187939).
void _ignoreWebStartupFocusRace() {
  if (!kIsWeb) return;

  var armed = true;
  WidgetsBinding.instance.addPostFrameCallback((_) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      armed = false;
    });
  });

  final previous = FlutterError.onError;
  FlutterError.onError = (details) {
    if (armed) {
      final message = details.exceptionAsString();
      final stack = details.stack?.toString() ?? '';
      if (message.contains('was not laid out') &&
          stack.contains('didChangeViewFocus')) {
        return;
      }
    }
    previous?.call(details);
  };
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(appThemeModeProvider);
    final locale = ref.watch(appLocaleProvider).value ?? const Locale('en');

    return MaterialApp.router(
      title: FlavorConfig.displayName,
      theme: context.lightTheme,
      darkTheme: context.darkTheme,
      themeMode: themeMode.value,
      locale: locale,
      supportedLocales: AppLocale.supported,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      routerConfig: router,
      debugShowCheckedModeBanner: FlavorConfig.flavor == Flavor.dev,
      builder: (context, child) {
        return TalkerOverlay(
          child: OfflineContainer(child: child),
        );
      },
    );
  }
}
