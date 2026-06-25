package com.dochat.server.repository;

import com.dochat.server.model.JobResume;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.Optional;

public interface JobResumeRepository extends JpaRepository<JobResume, Long> {
    Optional<JobResume> findByUserId(String userId);

    Page<JobResume> findByStatusAndIntentionContaining(String status, String keyword, Pageable pageable);
}
