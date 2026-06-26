package com.dochat.server.repository;

import com.dochat.server.model.ExpressInsurance;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface ExpressInsuranceRepository extends JpaRepository<ExpressInsurance, Long> {
    Optional<ExpressInsurance> findByOrderId(String orderId);
}
