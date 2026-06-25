package com.dochat.server.repository;

import com.dochat.server.model.MallOrder;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import java.util.Optional;

public interface MallOrderRepository extends JpaRepository<MallOrder, Long> {
    Optional<MallOrder> findByOrderId(String orderId);

    @Query("SELECT o FROM MallOrder o WHERE o.buyerId = :userId OR o.sellerId = :userId ORDER BY o.createdAt DESC")
    Page<MallOrder> findByBuyerIdOrSellerId(@Param("userId") String userId, Pageable pageable);

    @Query("SELECT o FROM MallOrder o WHERE (o.buyerId = :userId OR o.sellerId = :userId) AND o.status = :status ORDER BY o.createdAt DESC")
    Page<MallOrder> findByBuyerIdOrSellerIdAndStatus(@Param("userId") String userId, @Param("status") String status, Pageable pageable);
}
