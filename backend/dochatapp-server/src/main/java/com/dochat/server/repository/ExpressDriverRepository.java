package com.dochat.server.repository;

import com.dochat.server.model.ExpressDriver;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface ExpressDriverRepository extends JpaRepository<ExpressDriver, Long> {
    Optional<ExpressDriver> findByUserId(String userId);
    Optional<ExpressDriver> findByDriverId(String driverId);
}
