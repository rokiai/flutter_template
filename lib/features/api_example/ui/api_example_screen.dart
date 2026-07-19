import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../extensions/app_localizations_extension.dart';
import '../../../extensions/build_context_extension.dart';
import '../../../theme/app_theme.dart';
import '../../common/ui/widgets/common_error.dart';
import '../../common/ui/widgets/loading.dart';
import 'view_model/posts_view_model.dart';

class ApiExampleScreen extends ConsumerWidget {
  const ApiExampleScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncPosts = ref.watch(postsViewModelProvider);

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(context.l10n.menuApi, style: AppTheme.title24),
                  const SizedBox(height: 8),
                  Text(
                    context.l10n.apiExampleDescription,
                    style: AppTheme.body14.copyWith(
                      color: context.secondaryTextColor,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: asyncPosts.when(
                loading: () => const Loading(),
                error: (_, _) => const CommonError(),
                data: (state) {
                  if (state.posts.isEmpty) {
                    return Center(child: Text(context.l10n.noData));
                  }
                  return RefreshIndicator(
                    onRefresh: () =>
                        ref.read(postsViewModelProvider.notifier).refresh(),
                    child: ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
                      itemCount: state.posts.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final post = state.posts[index];
                        return Material(
                          color: context.secondaryWidgetColor,
                          borderRadius: BorderRadius.circular(16),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '#${post.id}  ${post.title}',
                                  style: AppTheme.title14.copyWith(
                                    color: context.primaryTextColor,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  post.body,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTheme.body12.copyWith(
                                    color: context.secondaryTextColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
