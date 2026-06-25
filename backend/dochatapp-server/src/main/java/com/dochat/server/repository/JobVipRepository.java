package com.dochat.server.repository;

import com.dochat.server.model.JobVip;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.Optional;

public interface JobVipRepository extends JpaRepository<JobVip, Long> {
    Optional<JobVip> findByUserId(String userId);
}
