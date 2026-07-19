// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Cancel';

  @override
  String get confirm => 'Confirm';

  @override
  String get noData => 'No data';

  @override
  String get offline => 'Your device is offline';

  @override
  String get unexpectedErrorOccurred => 'Unexpected error occurred';

  @override
  String get menuCounter => 'Counter';

  @override
  String get menuApi => 'API';

  @override
  String get menuSetting => 'Settings';

  @override
  String get counterDescription =>
      'Riverpod state demo. Tap buttons to update the count.';

  @override
  String get counterIncrement => 'Increment';

  @override
  String get counterDecrement => 'Decrement';

  @override
  String get counterReset => 'Reset';

  @override
  String get apiExampleDescription =>
      'Dio + Repository + ViewModel example (JSONPlaceholder /posts).';

  @override
  String get preferences => 'Preferences';

  @override
  String get appearances => 'Appearance';

  @override
  String get auto => 'Follow the system';

  @override
  String get lightMode => 'Light Mode';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get language => 'Language';
}
