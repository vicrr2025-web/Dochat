package com.dochat.server.service;

import com.dochat.server.dto.PageResponse;
import com.dochat.server.dto.PostRequest;
import com.dochat.server.dto.PostResponse;
import com.dochat.server.model.Follow;
import com.dochat.server.model.Friend;
import com.dochat.server.model.Like;
import com.dochat.server.model.Post;
import com.dochat.server.model.User;
import com.dochat.server.repository.FollowRepository;
import com.dochat.server.repository.FriendRepository;
import com.dochat.server.repository.LikeRepository;
import com.dochat.server.repository.PostRepository;
import com.dochat.server.repository.UserRepository;
import com.google.gson.Gson;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.*;
import java.util.stream.Collectors;

@Service
public class PostService {

    private static final Gson gson = new Gson();

    private final PostRepository postRepository;
    private final UserRepository userRepository;
    private final LikeRepository likeRepository;
    private final FollowRepository followRepository;
    private final FriendRepository friendRepository;

    public PostService(PostRepository postRepository, UserRepository userRepository,
                       LikeRepository likeRepository, FollowRepository followRepository,
                       FriendRepository friendRepository) {
        this.postRepository = postRepository;
        this.userRepository = userRepository;
        this.likeRepository = likeRepository;
        this.followRepository = followRepository;
        this.friendRepository = friendRepository;
    }

    public PageResponse<PostResponse> getFeed(String feed, String userId, int page, int size) {
        Page<Post> postPage;
        switch (feed) {
            case "following":
                postPage = getFollowingFeed(userId, page, size);
                break;
            case "moments":
                postPage = getMomentsFeed(userId, page, size);
                break;
            case "recommend":
            default:
                postPage = postRepository.findByStatusAndVisibilityOrderByCreatedAtDesc(
                        "published", "public", PageRequest.of(page, size));
                break;
        }
        return toPageResponse(postPage, userId);
    }

    private Page<Post> getFollowingFeed(String userId, int page, int size) {
        List<Follow> follows = followRepository.findByFollowerId(userId);
        if (follows.isEmpty()) {
            return Page.empty();
        }
        List<String> followingIds = follows.stream()
                .map(Follow::getFollowingId)
                .collect(Collectors.toList());
        return postRepository.findByUserIdInOrderByCreatedAtDesc(followingIds, PageRequest.of(page, size));
    }

    private Page<Post> getMomentsFeed(String userId, int page, int size) {
        List<Friend> friends = friendRepository.findByUserIdAndStatus(userId, "accepted");
        Set<String> userIds = new HashSet<>();
        userIds.add(userId);
        friends.forEach(f -> userIds.add(f.getFriendId()));
        return postRepository.findByUserIdInOrderByCreatedAtDesc(
                new ArrayList<>(userIds), PageRequest.of(page, size));
    }

    private PageResponse<PostResponse> toPageResponse(Page<Post> postPage, String currentUserId) {
        List<PostResponse> responses = postPage.getContent().stream()
                .map(post -> {
                    User user = userRepository.findByUserId(post.getUserId()).orElse(null);
                    boolean isLiked = likeRepository
                            .findByUserIdAndTargetIdAndTargetType(currentUserId, post.getPostId(), "post")
                            .isPresent();
                    return PostResponse.fromPost(post,
                            user != null ? user.getNickname() : "未知用户",
                            user != null ? user.getAvatar() : null,
                            isLiked);
                })
                .collect(Collectors.toList());
        return new PageResponse<>(responses, postPage.getTotalPages(),
                postPage.getTotalElements(), postPage.getNumber());
    }

    @Transactional
    public PostResponse createPost(String userId, PostRequest request) {
        if (request.getContent() != null && request.getContent().length() > 140) {
            throw new IllegalArgumentException("文字内容不能超过140字");
        }
        if ("video".equals(request.getMediaType())) {
            if (request.getMediaDuration() == null) {
                throw new IllegalArgumentException("视频必须提供时长");
            }
            if (request.getMediaDuration() < 15 || request.getMediaDuration() > 180) {
                throw new IllegalArgumentException("视频时长需在15秒到3分钟之间");
            }
        }
        if (request.getMediaUrls() != null && request.getMediaUrls().size() > 9) {
            throw new IllegalArgumentException("图片最多9张");
        }

        Post post = new Post();
        post.setUserId(userId);
        post.setContent(request.getContent());
        post.setMediaType(request.getMediaType() != null ? request.getMediaType() : "text");
        if (request.getMediaUrls() != null) {
            post.setMediaUrls(gson.toJson(request.getMediaUrls()));
        }
        post.setMediaDuration(request.getMediaDuration());
        post.setLocation(request.getLocation());
        post.setVisibility(request.getVisibility() != null ? request.getVisibility() : "public");
        post.setStatus("published");

        post = postRepository.save(post);

        User user = userRepository.findByUserId(userId).orElse(null);
        return PostResponse.fromPost(post,
                user != null ? user.getNickname() : "未知用户",
                user != null ? user.getAvatar() : null,
                false);
    }

    public PostResponse getPost(String postId, String currentUserId) {
        Post post = postRepository.findByPostId(postId)
                .orElseThrow(() -> new NoSuchElementException("动态不存在"));
        User user = userRepository.findByUserId(post.getUserId()).orElse(null);
        boolean isLiked = likeRepository
                .findByUserIdAndTargetIdAndTargetType(currentUserId, postId, "post")
                .isPresent();
        return PostResponse.fromPost(post,
                user != null ? user.getNickname() : "未知用户",
                user != null ? user.getAvatar() : null,
                isLiked);
    }

    @Transactional
    public void deletePost(String postId, String userId) {
        Post post = postRepository.findByPostId(postId)
                .orElseThrow(() -> new NoSuchElementException("动态不存在"));
        if (!post.getUserId().equals(userId)) {
            throw new IllegalStateException("无权删除此动态");
        }
        post.setStatus("deleted");
        postRepository.save(post);
    }

    @Transactional
    public void saveDraft(String userId, PostRequest request, String postId) {
        Post post;
        if (postId != null) {
            post = postRepository.findByPostId(postId)
                    .orElseThrow(() -> new NoSuchElementException("草稿不存在"));
            if (!post.getUserId().equals(userId)) {
                throw new IllegalStateException("无权修改此草稿");
            }
        } else {
            post = new Post();
            post.setUserId(userId);
        }
        post.setContent(request.getContent());
        post.setMediaType(request.getMediaType() != null ? request.getMediaType() : "text");
        if (request.getMediaUrls() != null) {
            post.setMediaUrls(gson.toJson(request.getMediaUrls()));
        }
        post.setMediaDuration(request.getMediaDuration());
        post.setLocation(request.getLocation());
        post.setVisibility(request.getVisibility() != null ? request.getVisibility() : "public");
        post.setStatus("draft");
        postRepository.save(post);
    }

    public List<PostResponse> getDrafts(String userId) {
        return postRepository.findByUserIdOrderByCreatedAtDesc(userId, PageRequest.of(0, 100))
                .getContent().stream()
                .filter(p -> "draft".equals(p.getStatus()))
                .map(post -> {
                    User user = userRepository.findByUserId(userId).orElse(null);
                    return PostResponse.fromPost(post,
                            user != null ? user.getNickname() : "未知用户",
                            user != null ? user.getAvatar() : null,
                            false);
                })
                .collect(Collectors.toList());
    }

    @Transactional
    public Map<String, Object> toggleLike(String postId, String userId) {
        Post post = postRepository.findByPostId(postId)
                .orElseThrow(() -> new NoSuchElementException("动态不存在"));

        Optional<Like> existing = likeRepository
                .findByUserIdAndTargetIdAndTargetType(userId, postId, "post");

        if (existing.isPresent()) {
            likeRepository.deleteByUserIdAndTargetIdAndTargetType(userId, postId, "post");
            post.setLikeCount(Math.max(0, post.getLikeCount() - 1));
            postRepository.save(post);
            Map<String, Object> result = new HashMap<>();
            result.put("liked", false);
            result.put("count", post.getLikeCount());
            return result;
        } else {
            Like like = new Like();
            like.setUserId(userId);
            like.setTargetId(postId);
            like.setTargetType("post");
            likeRepository.save(like);
            post.setLikeCount(post.getLikeCount() + 1);
            postRepository.save(post);
            Map<String, Object> result = new HashMap<>();
            result.put("liked", true);
            result.put("count", post.getLikeCount());
            return result;
        }
    }
}
