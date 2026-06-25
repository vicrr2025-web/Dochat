package com.dochat.server.repository;

import com.dochat.server.model.JobCompany;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.Optional;

public interface JobCompanyRepository extends JpaRepository<JobCompany, Long> {
    Optional<JobCompany> findByUserId(String userId);
}
