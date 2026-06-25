package com.dochat.server.repository;

import com.dochat.server.model.JobPosition;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import java.util.Optional;

public interface JobPositionRepository extends JpaRepository<JobPosition, Long> {
    Optional<JobPosition> findByPositionId(String positionId);

    Page<JobPosition> findByStatus(String status, Pageable pageable);

    @Query("SELECT p FROM JobPosition p WHERE p.status = :status " +
           "AND (:keyword IS NULL OR p.title LIKE %:keyword% OR p.city LIKE %:keyword%) " +
           "AND (:city IS NULL OR p.city = :city) " +
           "AND (:industry IS NULL OR p.industry = :industry) " +
           "AND (:salaryMin IS NULL OR p.salaryMin >= :salaryMin)")
    Page<JobPosition> findByStatusAndFilters(
            @Param("status") String status,
            @Param("keyword") String keyword,
            @Param("city") String city,
            @Param("industry") String industry,
            @Param("salaryMin") Integer salaryMin,
            Pageable pageable);

    Page<JobPosition> findByStatusAndTitleContainingOrCityContaining(
            String status, String titleKeyword, String cityKeyword, Pageable pageable);
}
