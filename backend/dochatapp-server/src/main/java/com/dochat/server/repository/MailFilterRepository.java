package com.dochat.server.repository;

import com.dochat.server.model.MailFilter;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface MailFilterRepository extends JpaRepository<MailFilter, Long> {
    List<MailFilter> findByUserId(String userId);
    Optional<MailFilter> findByUserIdAndTypeAndAddressPattern(String userId, String type, String addressPattern);
}
