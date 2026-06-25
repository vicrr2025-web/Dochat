import 'package:dochat_app/models/post_models.dart';
import 'package:dochat_app/models/friend_models.dart';
import 'package:dochat_app/services/api_service.dart';

class PostService {
  final ApiService _api = ApiService();

  Future<List<PostInfo>> getFeed(String feed, int page, int size) async {
    final response = await _api.client.get(
      '/v1/posts',
      queryParameters: {'feed': feed, 'page': page, 'size': size},
    );
    final data = response.data['data'];
    final list = data['content'] as List;
    return list
        .map((e) => PostInfo.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<PostInfo> createPost(PostRequest request) async {
    final response = await _api.client.post(
      '/v1/posts',
      data: request.toJson(),
    );
    return PostInfo.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  Future<PostInfo> getPost(String postId) async {
    final response = await _api.client.get('/v1/posts/$postId');
    return PostInfo.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  Future<void> deletePost(String postId) async {
    await _api.client.delete('/v1/posts/$postId');
  }

  Future<LikeResult> toggleLike(String postId) async {
    final response = await _api.client.post('/v1/posts/$postId/like');
    return LikeResult.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  Future<List<CommentInfo>> getComments(String postId, int page) async {
    final response = await _api.client.get(
      '/v1/posts/$postId/comments',
      queryParameters: {'page': page},
    );
    final data = response.data['data'];
    final list = data['content'] as List;
    return list
        .map((e) => CommentInfo.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<CommentInfo> addComment(
    String postId,
    String content, {
    String? parentId,
    String? replyToUserId,
  }) async {
    final data = <String, dynamic>{'content': content};
    if (parentId != null) data['parentId'] = parentId;
    if (replyToUserId != null) data['replyToUserId'] = replyToUserId;
    final response = await _api.client.post(
      '/v1/posts/$postId/comments',
      data: data,
    );
    return CommentInfo.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  Future<void> deleteComment(String commentId) async {
    await _api.client.delete('/v1/comments/$commentId');
  }

  Future<void> saveDraft(PostRequest request, {String? postId}) async {
    await _api.client.put('/v1/posts/draft', data: {
      'postId': postId,
      ...request.toJson(),
    });
  }

  Future<List<PostInfo>> getDrafts() async {
    final response = await _api.client.get('/v1/posts/drafts');
    final list = response.data['data'] as List;
    return list
        .map((e) => PostInfo.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<FollowResult> toggleFollow(String userId) async {
    final response = await _api.client.post('/v1/users/$userId/follow');
    return FollowResult.fromJson(
        response.data['data'] as Map<String, dynamic>);
  }

  Future<List<FriendInfo>> getFollowing(String userId) async {
    final response = await _api.client.get(
      '/v1/users/following',
      queryParameters: {'userId': userId},
    );
    final list = response.data['data'] as List;
    return list
        .map((e) => FriendInfo.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<FriendInfo>> getFollowers(String userId) async {
    final response = await _api.client.get(
      '/v1/users/followers',
      queryParameters: {'userId': userId},
    );
    final list = response.data['data'] as List;
    return list
        .map((e) => FriendInfo.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<PostInfo>> getUserPosts(String userId, int page) async {
    final response = await _api.client.get(
      '/v1/users/$userId/posts',
      queryParameters: {'page': page},
    );
    final data = response.data['data'];
    final list = data['content'] as List;
    return list
        .map((e) => PostInfo.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
