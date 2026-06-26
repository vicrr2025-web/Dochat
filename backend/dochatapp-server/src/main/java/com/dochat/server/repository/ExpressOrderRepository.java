package com.dochat.server.repository;

import com.dochat.server.model.ExpressOrder;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface ExpressOrderRepository extends JpaRepository<ExpressOrder, Long> {
    Page<ExpressOrder> findByUserId(String userId, Pageable pageable);
    Page<ExpressOrder> findByDriverId(String driverId, Pageable pageable);
    Optional<ExpressOrder> findByOrderId(String orderId);
    Page<ExpressOrder> findByStatus(String status, Pageable pageable);
}
