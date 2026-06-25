package com.dochat.server.repository;

import com.dochat.server.model.GeoFence;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface GeoFenceRepository extends JpaRepository<GeoFence, Long> {
    List<GeoFence> findByUserId(String userId);
    List<GeoFence> findByTargetUserId(String targetUserId);
}
