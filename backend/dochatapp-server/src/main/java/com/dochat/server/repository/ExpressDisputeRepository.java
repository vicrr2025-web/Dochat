package com.dochat.server.repository;

import com.dochat.server.model.ExpressDispute;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface ExpressDisputeRepository extends JpaRepository<ExpressDispute, Long> {
    Optional<ExpressDispute> findByOrderId(String orderId);
    Optional<ExpressDispute> findByDisputeId(String disputeId);
}
