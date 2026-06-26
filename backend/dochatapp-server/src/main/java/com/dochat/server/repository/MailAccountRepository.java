package com.dochat.server.repository;

import com.dochat.server.model.MailAccount;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface MailAccountRepository extends JpaRepository<MailAccount, Long> {
    List<MailAccount> findByUserId(String userId);
    Optional<MailAccount> findByAccountId(String accountId);
}
