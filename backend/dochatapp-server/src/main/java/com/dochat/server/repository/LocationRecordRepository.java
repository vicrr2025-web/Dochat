package com.dochat.server.repository;

import com.dochat.server.model.LocationRecord;
import org.springframework.data.jpa.repository.JpaRepository;

import java.sql.Timestamp;
import java.util.List;

public interface LocationRecordRepository extends JpaRepository<LocationRecord, Long> {
    LocationRecord findTopByUserIdOrderByRecordedAtDesc(String userId);
    List<LocationRecord> findByUserIdAndRecordedAtBetween(String userId, Timestamp start, Timestamp end);
}
