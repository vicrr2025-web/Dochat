package com.dochat.server.repository;

import com.dochat.server.model.JobFavorite;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.transaction.annotation.Transactional;
import java.util.List;
import java.util.Optional;

public interface JobFavoriteRepository extends JpaRepository<JobFavorite, Long> {
    List<JobFavorite> findByUserId(String userId);

    Optional<JobFavorite> findByUserIdAndResumeId(String userId, String resumeId);

    @Modifying
    @Transactional
    @Query("DELETE FROM JobFavorite f WHERE f.userId = :userId AND f.resumeId = :resumeId")
    void deleteByUserIdAndResumeId(String userId, String resumeId);
}
