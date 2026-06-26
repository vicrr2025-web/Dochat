package com.dochat.server.repository;

import com.dochat.server.model.HomeFavorite;
import org.springframework.data.domain.Page;
import java.util.List;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.transaction.annotation.Transactional;

public interface HomeFavoriteRepository extends JpaRepository<HomeFavorite, Long> {
    List<HomeFavorite> findByUserId(String userId);
    Page<HomeFavorite> findByUserId(String userId, Pageable pageable);

    @Transactional
    void deleteByUserIdAndWorkerId(String userId, String workerId);

    boolean existsByUserIdAndWorkerId(String userId, String workerId);
}
