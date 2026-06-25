package com.dochat.server.repository;

import com.dochat.server.model.UserPrivacy;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface UserPrivacyRepository extends JpaRepository<UserPrivacy, Long> {
    Optional<UserPrivacy> findByUserId(String userId);
}
