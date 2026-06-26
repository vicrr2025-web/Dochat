package com.dochat.server.repository;

import com.dochat.server.model.HomeOrder;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface HomeOrderRepository extends JpaRepository<HomeOrder, Long> {
    Page<HomeOrder> findByUserId(String userId, Pageable pageable);
    Page<HomeOrder> findByWorkerId(String workerId, Pageable pageable);
    Optional<HomeOrder> findByOrderId(String orderId);
}
