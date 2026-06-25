package com.dochat.server.service;

import com.dochat.server.dto.CommentRequest;
import com.dochat.server.dto.CommentResponse;
import com.dochat.server.dto.PageResponse;
import com.dochat.server.model.Comment;
import com.dochat.server.model.Post;
import com.dochat.server.model.User;
import com.dochat.server.repository.CommentRepository;
import com.dochat.server.repository.PostRepository;
import com.dochat.server.repository.UserRepository;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.NoSuchElementException;
import java.util.stream.Collectors;

@Service
public class CommentService {

    private final CommentRepository commentRepository;
    private final PostRepository postRepository;
    private final UserRepository userRepository;

    public CommentService(CommentRepository commentRepository, PostRepository postRepository,
                          UserRepository userRepository) {
        this.commentRepository = commentRepository;
        this.postRepository = postRepository;
        this.userRepository = userRepository;
    }

    public PageResponse<CommentResponse> getComments(String postId, int page, int size) {
        Page<Comment> commentPage = commentRepository
                .findByPostIdOrderByCreatedAtAsc(postId, PageRequest.of(page, size));

        List<CommentResponse> responses = commentPage.getContent().stream()
                .map(comment -> {
                    User user = userRepository.findByUserId(comment.getUserId()).orElse(null);
                    return CommentResponse.fromComment(comment,
                            user != null ? user.getNickname() : "未知用户",
                            user != null ? user.getAvatar() : null);
                })
                .collect(Collectors.toList());

        return new PageResponse<>(responses, commentPage.getTotalPages(),
                commentPage.getTotalElements(), commentPage.getNumber());
    }

    @Transactional
    public CommentResponse addComment(String postId, String userId, CommentRequest request) {
        Post post = postRepository.findByPostId(postId)
                .orElseThrow(() -> new NoSuchElementException("动态不存在"));

        Comment comment = new Comment();
        comment.setPostId(postId);
        comment.setUserId(userId);
        comment.setContent(request.getContent());
        comment.setParentId(request.getParentId());
        comment.setReplyToUserId(request.getReplyToUserId());
        comment.setLikeCount(0);

        comment = commentRepository.save(comment);

        post.setCommentCount(post.getCommentCount() + 1);
        postRepository.save(post);

        User user = userRepository.findByUserId(userId).orElse(null);
        return CommentResponse.fromComment(comment,
                user != null ? user.getNickname() : "未知用户",
                user != null ? user.getAvatar() : null);
    }

    @Transactional
    public void deleteComment(String commentId, String userId) {
        Comment comment = commentRepository.findByCommentId(commentId)
                .orElseThrow(() -> new NoSuchElementException("评论不存在"));
        if (!comment.getUserId().equals(userId)) {
            throw new IllegalStateException("无权删除此评论");
        }

        commentRepository.delete(comment);

        Post post = postRepository.findByPostId(comment.getPostId())
                .orElseThrow(() -> new NoSuchElementException("动态不存在"));
        post.setCommentCount(Math.max(0, post.getCommentCount() - 1));
        postRepository.save(post);
    }
}
