package com.dochat.server.repository;

import com.dochat.server.model.DatingFeed;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface DatingFeedRepository extends JpaRepository<DatingFeed, Long> {
    List<DatingFeed> findAllByOrderByCreatedAtDesc(Pageable pageable);
    List<DatingFeed> findByUserIdOrderByCreatedAtDesc(String userId, Pageable pageable);
}
