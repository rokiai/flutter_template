import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../constants/constants.dart';
import '../../../extensions/app_localizations_extension.dart';
import '../../../extensions/build_context_extension.dart';
import '../../../routing/app_router.dart';
import '../../../theme/app_theme.dart';
import 'widgets/profile_item.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  var _version = '';

  @override
  void initState() {
    super.initState();
    PackageInfo.fromPlatform().then((info) {
      if (!mounted) return;
      setState(() => _version = info.version);
    }).catchError((Object error) {
      debugPrint('${Constants.tag} [ProfileScreen] package info: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.secondaryBackgroundColor,
      body: ListView(
        padding: EdgeInsets.fromLTRB(
          16,
          MediaQuery.paddingOf(context).top + 24,
          16,
          128,
        ),
        children: [
          Text(context.l10n.menuSetting, style: AppTheme.title24),
          const SizedBox(height: 24),
          Text(context.l10n.preferences, style: AppTheme.title20),
          const SizedBox(height: 8),
          ProfileItem(
            icon: HugeIcons.strokeRoundedIdea,
            text: context.l10n.appearances,
            isFirst: true,
            onTap: () => const AppearancesRoute().push(context),
          ),
          ProfileItem(
            icon: HugeIcons.strokeRoundedTranslate,
            text: context.l10n.language,
            isLast: true,
            onTap: () => const LanguagesRoute().push(context),
          ),
          const SizedBox(height: 24),
          Center(
            child: Text(
              'Version $_version',
              style: AppTheme.body12,
            ),
          ),
        ],
      ),
    );
  }
}
