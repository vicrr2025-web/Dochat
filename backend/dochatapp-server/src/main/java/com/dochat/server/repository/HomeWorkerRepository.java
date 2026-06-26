package com.dochat.server.repository;

import com.dochat.server.model.HomeWorker;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface HomeWorkerRepository extends JpaRepository<HomeWorker, Long> {
    Optional<HomeWorker> findByUserId(String userId);
    Optional<HomeWorker> findByWorkerId(String workerId);
    Page<HomeWorker> findByAuthStatusAndSkillsContaining(String authStatus, String skill, Pageable pageable);
}
