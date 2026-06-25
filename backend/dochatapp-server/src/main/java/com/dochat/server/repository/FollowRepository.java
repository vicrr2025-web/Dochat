package com.dochat.server.repository;

import com.dochat.server.model.Follow;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

public interface FollowRepository extends JpaRepository<Follow, Long> {
    Page<Follow> findByFollowerId(String followerId, Pageable pageable);
    Page<Follow> findByFollowingId(String followingId, Pageable pageable);
    Optional<Follow> findByFollowerIdAndFollowingId(String followerId, String followingId);
    List<Follow> findByFollowerId(String followerId);

    @Transactional
    void deleteByFollowerIdAndFollowingId(String followerId, String followingId);
}
