package com.dochat.server.repository;

import com.dochat.server.model.MailRead;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;

public interface MailReadRepository extends JpaRepository<MailRead, Long> {
    Page<MailRead> findByUserIdOrderByReadAtDesc(String userId, Pageable pageable);
}
