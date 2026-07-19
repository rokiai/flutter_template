import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../common/remote/dio_provider.dart';
import '../model/post.dart';

part 'posts_repository.g.dart';

/// Example repository: GET /posts from JSONPlaceholder.
class PostsRepository {
  PostsRepository(this._dio);

  final Dio _dio;

  Future<List<Post>> fetchPosts({int limit = 20}) async {
    final response = await _dio.get<List<dynamic>>(
      '/posts',
      queryParameters: {'_limit': limit},
    );
    final data = response.data ?? const [];
    return data
        .map((e) => Post.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
  }

  Future<Post> fetchPost(int id) async {
    final response = await _dio.get<Map<String, dynamic>>('/posts/$id');
    return Post.fromJson(Map<String, dynamic>.from(response.data ?? const {}));
  }
}

@Riverpod(keepAlive: true)
PostsRepository postsRepository(Ref ref) {
  return PostsRepository(ref.watch(dioProvider));
}
