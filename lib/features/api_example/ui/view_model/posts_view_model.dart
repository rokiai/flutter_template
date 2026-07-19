import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../repository/posts_repository.dart';
import '../state/posts_state.dart';

part 'posts_view_model.g.dart';

@Riverpod(keepAlive: true)
class PostsViewModel extends _$PostsViewModel {
  @override
  FutureOr<PostsState> build() async {
    final posts = await ref.watch(postsRepositoryProvider).fetchPosts();
    return PostsState(posts: posts);
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final posts = await ref.read(postsRepositoryProvider).fetchPosts();
      return PostsState(posts: posts);
    });
  }
}
