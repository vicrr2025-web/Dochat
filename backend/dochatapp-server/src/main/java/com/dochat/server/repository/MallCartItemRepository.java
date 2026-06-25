package com.dochat.server.repository;

import com.dochat.server.model.MallCartItem;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.transaction.annotation.Transactional;
import java.util.List;
import java.util.Optional;

public interface MallCartItemRepository extends JpaRepository<MallCartItem, Long> {
    List<MallCartItem> findByUserId(String userId);
    Optional<MallCartItem> findByUserIdAndProductId(String userId, String productId);

    @Modifying
    @Transactional
    @Query("DELETE FROM MallCartItem c WHERE c.userId = :userId")
    void deleteByUserId(String userId);
}
