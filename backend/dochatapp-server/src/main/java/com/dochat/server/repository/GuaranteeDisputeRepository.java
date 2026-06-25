package com.dochat.server.repository;

import com.dochat.server.model.GuaranteeDispute;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface GuaranteeDisputeRepository extends JpaRepository<GuaranteeDispute, Long> {

    Optional<GuaranteeDispute> findByTradeId(String tradeId);

    Optional<GuaranteeDispute> findByDisputeId(String disputeId);
}
