import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';

import '/extensions/app_localizations_extension.dart';
import '/extensions/build_context_extension.dart';
import '/features/common/ui/providers/app_theme_mode_provider.dart';
import '/features/common/ui/widgets/common_header.dart';
import 'widgets/appearance_item.dart';

class AppearancesScreen extends ConsumerWidget {
  const AppearancesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(appThemeModeProvider).value;

    return Scaffold(
      backgroundColor: context.secondaryBackgroundColor,
      body: Column(
        children: [
          CommonHeader(header: context.l10n.appearances),
          Padding(
            padding: const EdgeInsets.all(16),
            child: RadioGroup<ThemeMode>(
              groupValue: themeMode,
              onChanged: (value) {
                if (value == null) return;
                ref.read(appThemeModeProvider.notifier).updateMode(value);
              },
              child: Column(
                children: [
                  AppearanceItem(
                    icon: HugeIcon(
                      icon: HugeIcons.strokeRoundedSettings01,
                      color: context.primaryTextColor,
                      size: 20,
                    ),
                    text: context.l10n.auto,
                    value: ThemeMode.system,
                    isFirst: true,
                  ),
                  AppearanceItem(
                    icon: HugeIcon(
                      icon: HugeIcons.strokeRoundedIdea,
                      color: context.primaryTextColor,
                      size: 20,
                    ),
                    text: context.l10n.lightMode,
                    value: ThemeMode.light,
                  ),
                  AppearanceItem(
                    icon: HugeIcon(
                      icon: HugeIcons.strokeRoundedMoon02,
                      color: context.primaryTextColor,
                      size: 20,
                    ),
                    text: context.l10n.darkMode,
                    value: ThemeMode.dark,
                    isLast: true,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
