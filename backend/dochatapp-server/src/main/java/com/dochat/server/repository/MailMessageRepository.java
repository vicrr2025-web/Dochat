package com.dochat.server.repository;

import com.dochat.server.model.MailMessage;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface MailMessageRepository extends JpaRepository<MailMessage, Long> {
    Page<MailMessage> findByAccountIdAndFolder(String accountId, String folder, Pageable pageable);
    Optional<MailMessage> findByMessageId(String messageId);
    List<MailMessage> findByAccountIdAndFolder(String accountId, String folder);
}
