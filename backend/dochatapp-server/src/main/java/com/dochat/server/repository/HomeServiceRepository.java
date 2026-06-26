package com.dochat.server.repository;

import com.dochat.server.model.HomeService;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface HomeServiceRepository extends JpaRepository<HomeService, Long> {
    Page<HomeService> findByStatus(String status, Pageable pageable);
    Optional<HomeService> findByServiceId(String serviceId);
}
