package com.dochat.server.repository;

import com.dochat.server.model.Message;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;
import java.util.Optional;

public interface MessageRepository extends JpaRepository<Message, Long> {
    Optional<Message> findByMessageId(String messageId);

    List<Message> findBySessionIdOrderBySentAtDesc(String sessionId, Pageable pageable);

    @Query("SELECT m FROM Message m WHERE m.sessionId = :sessionId " +
           "AND (:beforeMessageId IS NULL OR m.sentAt < " +
           "(SELECT m2.sentAt FROM Message m2 WHERE m2.messageId = :beforeMessageId)) " +
           "ORDER BY m.sentAt DESC")
    List<Message> findBySessionIdAndBefore(
            @Param("sessionId") String sessionId,
            @Param("beforeMessageId") String beforeMessageId,
            Pageable pageable);

    Page<Message> findBySessionIdAndContentContainingIgnoreCase(
            String sessionId, String keyword, Pageable pageable);

    @Query("SELECT m FROM Message m WHERE m.content ILIKE %:keyword% " +
           "ORDER BY m.sentAt DESC")
    Page<Message> searchByKeyword(@Param("keyword") String keyword, Pageable pageable);
}
