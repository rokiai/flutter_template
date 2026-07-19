import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../extensions/app_localizations_extension.dart';
import '../../../extensions/build_context_extension.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_theme.dart';
import '../../api_example/ui/api_example_screen.dart';
import '../../common/ui/widgets/material_ink_well.dart';
import '../../counter/ui/counter_screen.dart';
import '../../profile/ui/profile_screen.dart';
import '../model/main_tab.dart';

const List<Widget> _screens = [
  CounterScreen(),
  ApiExampleScreen(),
  ProfileScreen(),
];

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  int _currentTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          IndexedStack(
            index: _currentTabIndex,
            children: _screens,
          ),
          Positioned(
            left: 24,
            right: 24,
            bottom: MediaQuery.paddingOf(context).bottom + 16,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: context.secondaryWidgetColor,
                borderRadius: const BorderRadius.all(Radius.circular(48)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: MainTab.values
                    .map((tab) => _buildNavItem(tab))
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(MainTab tab) {
    final isSelected = _currentTabIndex == tab.index;
    return MaterialInkWell(
      radius: 24,
      onTap: () {
        setState(() {
          _currentTabIndex = tab.index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? context.secondaryBackgroundColor : null,
          borderRadius: const BorderRadius.all(Radius.circular(24)),
        ),
        child: Column(
          children: [
            Icon(
              tab.iconData,
              color: isSelected ? AppColors.blueberry100 : null,
            ),
            const SizedBox(height: 4),
            Text(
              tab.labelOf(context.l10n),
              style: AppTheme.body12.copyWith(
                color: isSelected ? AppColors.blueberry100 : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
