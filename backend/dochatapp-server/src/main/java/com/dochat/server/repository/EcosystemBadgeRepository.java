package com.dochat.server.repository;

import com.dochat.server.model.EcosystemBadge;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface EcosystemBadgeRepository extends JpaRepository<EcosystemBadge, Long> {
    List<EcosystemBadge> findByUserId(String userId);
    java.util.Optional<EcosystemBadge> findByUserIdAndEcosystemKey(String userId, String ecosystemKey);
}
