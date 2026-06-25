package com.dochat.server.repository;

import com.dochat.server.model.GuaranteeTrade;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface GuaranteeTradeRepository extends JpaRepository<GuaranteeTrade, Long> {

    Page<GuaranteeTrade> findByBuyerIdOrSellerId(String buyerId, String sellerId, Pageable pageable);

    Optional<GuaranteeTrade> findByTradeId(String tradeId);

    Page<GuaranteeTrade> findByStatus(String status, Pageable pageable);
}
