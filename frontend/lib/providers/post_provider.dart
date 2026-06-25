import 'package:flutter/foundation.dart';
import 'package:dochat_app/models/post_models.dart';
import 'package:dochat_app/services/post_service.dart';

class PostProvider extends ChangeNotifier {
  final PostService _postService = PostService();

  List<PostInfo> _recommendFeed = [];
  List<PostInfo> _followingFeed = [];
  List<PostInfo> _momentsFeed = [];
  String _currentFeed = 'recommend';
  int _currentPage = 0;
  bool _isLoading = false;
  bool _hasMore = true;
  bool _isRefreshing = false;
  String? _errorMessage;

  static const int _pageSize = 20;

  List<PostInfo> get currentPosts {
    switch (_currentFeed) {
      case 'recommend':
        return _recommendFeed;
      case 'following':
        return _followingFeed;
      case 'moments':
        return _momentsFeed;
      default:
        return _recommendFeed;
    }
  }

  String get currentFeed => _currentFeed;
  int get currentPage => _currentPage;
  bool get isLoading => _isLoading;
  bool get hasMore => _hasMore;
  bool get isRefreshing => _isRefreshing;
  String? get errorMessage => _errorMessage;

  List<PostInfo> get feed {
    switch (_currentFeed) {
      case 'recommend':
        return _recommendFeed;
      case 'following':
        return _followingFeed;
      case 'moments':
        return _momentsFeed;
      default:
        return _recommendFeed;
    }
  }

  Future<void> loadFeed(String feed, {bool refresh = false}) async {
    if (refresh) {
      _currentPage = 0;
      _hasMore = true;
      _isRefreshing = true;
    } else {
      _isLoading = true;
    }
    _errorMessage = null;
    notifyListeners();

    try {
      final posts = await _postService.getFeed(feed, _currentPage, _pageSize);
      if (refresh) {
        _setFeed(feed, posts);
      } else {
        _appendFeed(feed, posts);
      }
      _hasMore = posts.length >= _pageSize;
    } catch (e) {
      _errorMessage = 'networkError';
    }

    _isLoading = false;
    _isRefreshing = false;
    notifyListeners();
  }

  Future<void> loadMore() async {
    if (_isLoading || !_hasMore) return;
    _currentPage++;
    await loadFeed(_currentFeed);
  }

  Future<void> toggleLike(String postId) async {
    try {
      final result = await _postService.toggleLike(postId);
      _updatePostLike(postId, result.liked, result.count);
    } catch (e) {
      _errorMessage = 'networkError';
      notifyListeners();
    }
  }

  Future<bool> deletePost(String postId) async {
    try {
      await _postService.deletePost(postId);
      _removePost(postId);
      return true;
    } catch (e) {
      _errorMessage = 'networkError';
      notifyListeners();
      return false;
    }
  }

  Future<PostInfo?> createPost(PostRequest request) async {
    try {
      final post = await _postService.createPost(request);
      _recommendFeed.insert(0, post.copyWith(
        likeCount: 0,
        commentCount: 0,
        shareCount: 0,
        isLiked: false,
      ));
      _momentsFeed.insert(0, post.copyWith(
        likeCount: 0,
        commentCount: 0,
        shareCount: 0,
        isLiked: false,
      ));
      notifyListeners();
      return post;
    } catch (e) {
      _errorMessage = 'networkError';
      notifyListeners();
      return null;
    }
  }

  void switchFeed(String feed) {
    _currentFeed = feed;
    _currentPage = 0;
    _hasMore = true;
    notifyListeners();
  }

  Future<void> toggleFollow(String userId) async {
    try {
      await _postService.toggleFollow(userId);
    } catch (e) {
      _errorMessage = 'networkError';
      notifyListeners();
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void _setFeed(String feed, List<PostInfo> posts) {
    switch (feed) {
      case 'recommend':
        _recommendFeed = posts;
      case 'following':
        _followingFeed = posts;
      case 'moments':
        _momentsFeed = posts;
    }
  }

  void _appendFeed(String feed, List<PostInfo> posts) {
    switch (feed) {
      case 'recommend':
        _recommendFeed.addAll(posts);
      case 'following':
        _followingFeed.addAll(posts);
      case 'moments':
        _momentsFeed.addAll(posts);
    }
  }

  void _updatePostLike(String postId, bool liked, int count) {
    _updateListLike(_recommendFeed, postId, liked, count);
    _updateListLike(_followingFeed, postId, liked, count);
    _updateListLike(_momentsFeed, postId, liked, count);
    notifyListeners();
  }

  void _updateListLike(List<PostInfo> list, String postId, bool liked, int count) {
    final idx = list.indexWhere((p) => p.postId == postId);
    if (idx != -1) {
      list[idx] = list[idx].copyWith(isLiked: liked, likeCount: count);
    }
  }

  void _removePost(String postId) {
    _recommendFeed.removeWhere((p) => p.postId == postId);
    _followingFeed.removeWhere((p) => p.postId == postId);
    _momentsFeed.removeWhere((p) => p.postId == postId);
    notifyListeners();
  }
}
