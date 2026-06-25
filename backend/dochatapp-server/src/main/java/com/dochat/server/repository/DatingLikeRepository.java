package com.dochat.server.repository;

import com.dochat.server.model.DatingLike;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import java.util.List;
import java.util.Optional;

public interface DatingLikeRepository extends JpaRepository<DatingLike, Long> {
    List<DatingLike> findByToUserId(String toUserId);
    Optional<DatingLike> findByFromUserIdAndToUserId(String fromUserId, String toUserId);

    @Query("SELECT l FROM DatingLike l WHERE l.fromUserId = :userId OR l.toUserId = :userId")
    List<DatingLike> findByFromUserIdOrToUserId(String userId);
}
