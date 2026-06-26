package com.dochat.server.repository;

import com.dochat.server.model.HomeDispute;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface HomeDisputeRepository extends JpaRepository<HomeDispute, Long> {
    Optional<HomeDispute> findByOrderId(String orderId);
    Optional<HomeDispute> findByDisputeId(String disputeId);
}
