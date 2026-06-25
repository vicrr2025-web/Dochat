package com.dochat.server.repository;

import com.dochat.server.model.Session;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;
import java.util.Optional;

public interface SessionRepository extends JpaRepository<Session, Long> {
    Optional<Session> findBySessionId(String sessionId);

    @Query("SELECT s FROM Session s JOIN SessionMember sm ON s.sessionId = sm.sessionId " +
           "WHERE sm.userId = :userId ORDER BY s.lastTime DESC NULLS LAST")
    List<Session> findSessionsByMemberUserId(@Param("userId") String userId, Pageable pageable);

    @Query("SELECT COUNT(s) FROM Session s JOIN SessionMember sm ON s.sessionId = sm.sessionId " +
           "WHERE sm.userId = :userId")
    long countByMemberUserId(@Param("userId") String userId);
}
