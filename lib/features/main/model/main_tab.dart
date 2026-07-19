import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';

enum MainTab {
  counter(Icons.add_circle_outline_rounded, _menuCounter),
  api(Icons.cloud_outlined, _menuApi),
  setting(Icons.settings_outlined, _menuSetting);

  const MainTab(this.iconData, this.labelOf);

  final IconData iconData;
  final String Function(AppLocalizations) labelOf;
}

String _menuCounter(AppLocalizations l10n) => l10n.menuCounter;

String _menuApi(AppLocalizations l10n) => l10n.menuApi;

String _menuSetting(AppLocalizations l10n) => l10n.menuSetting;
