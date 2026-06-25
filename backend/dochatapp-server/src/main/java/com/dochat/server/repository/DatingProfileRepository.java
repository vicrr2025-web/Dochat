package com.dochat.server.repository;

import com.dochat.server.model.DatingProfile;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.Optional;

public interface DatingProfileRepository extends JpaRepository<DatingProfile, Long> {
    Optional<DatingProfile> findByUserId(String userId);
}
