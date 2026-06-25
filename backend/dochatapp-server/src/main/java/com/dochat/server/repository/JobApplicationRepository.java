package com.dochat.server.repository;

import com.dochat.server.model.JobApplication;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;
import java.util.Optional;

public interface JobApplicationRepository extends JpaRepository<JobApplication, Long> {
    Optional<JobApplication> findByApplicationId(String applicationId);

    Optional<JobApplication> findByPositionIdAndUserId(String positionId, String userId);

    List<JobApplication> findByUserId(String userId);

    List<JobApplication> findByPositionId(String positionId);
}
