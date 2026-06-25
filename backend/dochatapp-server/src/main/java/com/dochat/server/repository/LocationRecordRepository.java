package com.dochat.server.repository;

import com.dochat.server.model.LocationRecord;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.transaction.annotation.Transactional;

import java.sql.Timestamp;
import java.util.List;

public interface LocationRecordRepository extends JpaRepository<LocationRecord, Long> {
    LocationRecord findTopByUserIdOrderByRecordedAtDesc(String userId);
    List<LocationRecord> findByUserIdAndRecordedAtBetween(String userId, Timestamp start, Timestamp end);

    @Modifying
    @Transactional
    @Query("DELETE FROM LocationRecord lr WHERE lr.recordedAt < :cutoff")
    int deleteByRecordedAtBefore(@Param("cutoff") Timestamp cutoff);
}
