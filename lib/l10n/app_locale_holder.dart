import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';

/// Active locale for non-widget code (validators, repositories, utils).
class AppLocaleHolder {
  AppLocaleHolder._();

  static Locale locale = const Locale('en');

  static AppLocalizations get l10n => lookupAppLocalizations(locale);

  static void update(Locale value) {
    locale = value;
  }
}
