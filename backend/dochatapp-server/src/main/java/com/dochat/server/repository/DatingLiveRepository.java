package com.dochat.server.repository;

import com.dochat.server.model.DatingLive;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.Optional;

public interface DatingLiveRepository extends JpaRepository<DatingLive, Long> {
    Optional<DatingLive> findByUserIdAndStatus(String userId, String status);
    Optional<DatingLive> findByLiveId(String liveId);
}
