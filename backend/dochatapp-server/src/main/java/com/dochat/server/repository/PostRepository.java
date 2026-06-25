package com.dochat.server.repository;

import com.dochat.server.model.Post;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface PostRepository extends JpaRepository<Post, Long> {
    Page<Post> findByStatusAndVisibilityOrderByCreatedAtDesc(String status, String visibility, Pageable pageable);
    Page<Post> findByUserIdInOrderByCreatedAtDesc(List<String> userIds, Pageable pageable);
    Page<Post> findByUserIdOrderByCreatedAtDesc(String userId, Pageable pageable);
    Optional<Post> findByPostId(String postId);
}
