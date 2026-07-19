import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '/constants/constants.dart';
import '/l10n/app_locale_holder.dart';

part 'app_locale_provider.g.dart';

@Riverpod(keepAlive: true)
class AppLocale extends _$AppLocale {
  static const supported = [Locale('en'), Locale('vi')];

  @override
  Future<Locale> build() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(Constants.languageCodeKey);
    final locale = supported.firstWhere(
      (l) => l.languageCode == code,
      orElse: () => const Locale('en'),
    );
    AppLocaleHolder.update(locale);
    return locale;
  }

  Future<void> setLocale(Locale locale) async {
    if (!supported.any((l) => l.languageCode == locale.languageCode)) {
      return;
    }
    AppLocaleHolder.update(locale);
    state = AsyncData(locale);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(Constants.languageCodeKey, locale.languageCode);
  }
}
