import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../extensions/app_localizations_extension.dart';
import '../../../extensions/build_context_extension.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_theme.dart';
import '../../common/ui/widgets/primary_button.dart';
import '../../common/ui/widgets/secondary_button.dart';
import 'view_model/counter_provider.dart';

class CounterScreen extends ConsumerWidget {
  const CounterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(counterProvider);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(context.l10n.menuCounter, style: AppTheme.title24),
              const SizedBox(height: 8),
              Text(
                context.l10n.counterDescription,
                style: AppTheme.body14.copyWith(
                  color: context.secondaryTextColor,
                ),
              ),
              const Spacer(),
              Center(
                child: Text(
                  '$count',
                  style: AppTheme.title32.copyWith(
                    color: AppColors.blueberry100,
                    fontSize: 72,
                  ),
                ),
              ),
              const Spacer(),
              PrimaryButton(
                text: context.l10n.counterIncrement,
                onPressed: () =>
                    ref.read(counterProvider.notifier).increment(),
              ),
              const SizedBox(height: 8),
              SecondaryButton(
                text: context.l10n.counterDecrement,
                onPressed: () =>
                    ref.read(counterProvider.notifier).decrement(),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => ref.read(counterProvider.notifier).reset(),
                child: Text(context.l10n.counterReset),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
