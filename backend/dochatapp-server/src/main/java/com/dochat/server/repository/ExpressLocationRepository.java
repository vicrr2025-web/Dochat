package com.dochat.server.repository;

import com.dochat.server.model.ExpressLocation;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface ExpressLocationRepository extends JpaRepository<ExpressLocation, Long> {
    List<ExpressLocation> findByOrderIdOrderByRecordedAtDesc(String orderId);
}
