import 'package:freezed_annotation/freezed_annotation.dart';

import '../../model/post.dart';

part 'posts_state.freezed.dart';

@freezed
abstract class PostsState with _$PostsState {
  const factory PostsState({
    @Default([]) List<Post> posts,
  }) = _PostsState;
}
