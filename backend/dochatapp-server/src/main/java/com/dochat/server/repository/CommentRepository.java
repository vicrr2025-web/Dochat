package com.dochat.server.repository;

import com.dochat.server.model.Comment;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface CommentRepository extends JpaRepository<Comment, Long> {
    Page<Comment> findByPostIdOrderByCreatedAtAsc(String postId, Pageable pageable);
    Optional<Comment> findByCommentId(String commentId);
}
