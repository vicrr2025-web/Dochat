package com.dochat.server.repository;

import com.dochat.server.model.JobInterview;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface JobInterviewRepository extends JpaRepository<JobInterview, Long> {
    List<JobInterview> findByCandidateUserIdOrCompanyUserId(String candidateUserId, String companyUserId);
}
