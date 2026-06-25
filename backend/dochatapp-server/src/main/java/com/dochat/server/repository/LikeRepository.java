package com.dochat.server.repository;

import com.dochat.server.model.Like;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.transaction.annotation.Transactional;

import java.util.Optional;

public interface LikeRepository extends JpaRepository<Like, Long> {
    Optional<Like> findByUserIdAndTargetIdAndTargetType(String userId, String targetId, String targetType);
    int countByTargetIdAndTargetType(String targetId, String targetType);

    @Transactional
    void deleteByUserIdAndTargetIdAndTargetType(String userId, String targetId, String targetType);
}
