package com.dochat.server.repository;

import com.dochat.server.model.MallFavorite;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.transaction.annotation.Transactional;
import java.util.List;
import java.util.Optional;

public interface MallFavoriteRepository extends JpaRepository<MallFavorite, Long> {
    List<MallFavorite> findByUserId(String userId);
    Optional<MallFavorite> findByUserIdAndProductId(String userId, String productId);

    @Modifying
    @Transactional
    @Query("DELETE FROM MallFavorite f WHERE f.userId = :userId AND f.productId = :productId")
    void deleteByUserIdAndProductId(String userId, String productId);
}
