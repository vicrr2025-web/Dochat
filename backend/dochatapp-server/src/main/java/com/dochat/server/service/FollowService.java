package com.dochat.server.service;

import com.dochat.server.dto.PageResponse;
import com.dochat.server.dto.PostResponse;
import com.dochat.server.model.Follow;
import com.dochat.server.model.Post;
import com.dochat.server.model.User;
import com.dochat.server.repository.FollowRepository;
import com.dochat.server.repository.LikeRepository;
import com.dochat.server.repository.PostRepository;
import com.dochat.server.repository.UserRepository;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.*;
import java.util.stream.Collectors;

@Service
public class FollowService {

    private final FollowRepository followRepository;
    private final PostRepository postRepository;
    private final UserRepository userRepository;
    private final LikeRepository likeRepository;

    public FollowService(FollowRepository followRepository, PostRepository postRepository,
                         UserRepository userRepository, LikeRepository likeRepository) {
        this.followRepository = followRepository;
        this.postRepository = postRepository;
        this.userRepository = userRepository;
        this.likeRepository = likeRepository;
    }

    @Transactional
    public Map<String, Object> toggleFollow(String followerId, String followingId) {
        if (followerId.equals(followingId)) {
            throw new IllegalArgumentException("不能关注自己");
        }

        Optional<Follow> existing = followRepository
                .findByFollowerIdAndFollowingId(followerId, followingId);

        if (existing.isPresent()) {
            followRepository.deleteByFollowerIdAndFollowingId(followerId, followingId);
            Map<String, Object> result = new HashMap<>();
            result.put("following", false);
            return result;
        } else {
            Follow follow = new Follow();
            follow.setFollowerId(followerId);
            follow.setFollowingId(followingId);
            followRepository.save(follow);
            Map<String, Object> result = new HashMap<>();
            result.put("following", true);
            return result;
        }
    }

    public PageResponse<Map<String, Object>> getFollowing(String userId, int page, int size) {
        Page<Follow> followPage = followRepository.findByFollowerId(userId, PageRequest.of(page, size));
        List<Map<String, Object>> list = followPage.getContent().stream()
                .map(f -> {
                    User user = userRepository.findByUserId(f.getFollowingId()).orElse(null);
                    Map<String, Object> m = new HashMap<>();
                    m.put("userId", f.getFollowingId());
                    m.put("nickname", user != null ? user.getNickname() : "未知用户");
                    m.put("avatar", user != null ? user.getAvatar() : null);
                    m.put("createdAt", f.getCreatedAt().toString());
                    return m;
                })
                .collect(Collectors.toList());
        return new PageResponse<>(list, followPage.getTotalPages(),
                followPage.getTotalElements(), followPage.getNumber());
    }

    public PageResponse<Map<String, Object>> getFollowers(String userId, int page, int size) {
        Page<Follow> followPage = followRepository.findByFollowingId(userId, PageRequest.of(page, size));
        List<Map<String, Object>> list = followPage.getContent().stream()
                .map(f -> {
                    User user = userRepository.findByUserId(f.getFollowerId()).orElse(null);
                    Map<String, Object> m = new HashMap<>();
                    m.put("userId", f.getFollowerId());
                    m.put("nickname", user != null ? user.getNickname() : "未知用户");
                    m.put("avatar", user != null ? user.getAvatar() : null);
                    m.put("createdAt", f.getCreatedAt().toString());
                    return m;
                })
                .collect(Collectors.toList());
        return new PageResponse<>(list, followPage.getTotalPages(),
                followPage.getTotalElements(), followPage.getNumber());
    }

    public PageResponse<PostResponse> getUserPosts(String userId, int page, int size) {
        Page<Post> postPage = postRepository.findByUserIdOrderByCreatedAtDesc(userId, PageRequest.of(page, size));
        List<PostResponse> responses = postPage.getContent().stream()
                .map(post -> {
                    User user = userRepository.findByUserId(post.getUserId()).orElse(null);
                    boolean isLiked = likeRepository
                            .findByUserIdAndTargetIdAndTargetType(userId, post.getPostId(), "post")
                            .isPresent();
                    return PostResponse.fromPost(post,
                            user != null ? user.getNickname() : "未知用户",
                            user != null ? user.getAvatar() : null,
                            isLiked, true);
                })
                .collect(Collectors.toList());
        return new PageResponse<>(responses, postPage.getTotalPages(),
                postPage.getTotalElements(), postPage.getNumber());
    }
}
