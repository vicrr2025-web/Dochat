package com.dochat.server.repository;

import com.dochat.server.model.SessionMember;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;
import java.util.Optional;

public interface SessionMemberRepository extends JpaRepository<SessionMember, Long> {
    List<SessionMember> findBySessionId(String sessionId);

    List<SessionMember> findByUserId(String userId);

    Optional<SessionMember> findByUserIdAndSessionId(String userId, String sessionId);

    boolean existsByUserIdAndSessionId(String userId, String sessionId);

    @Query("SELECT sm.sessionId FROM SessionMember sm WHERE sm.userId = :userId")
    List<String> findSessionIdsByUserId(@Param("userId") String userId);

    @Query("SELECT sm.sessionId FROM SessionMember sm WHERE sm.userId = :userId1 " +
           "AND sm.sessionId IN (SELECT sm2.sessionId FROM SessionMember sm2 WHERE sm2.userId = :userId2)")
    List<String> findCommonSessionIds(@Param("userId1") String userId1, @Param("userId2") String userId2);
}
