package com.dochat.server.repository;

import com.dochat.server.model.User;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.Optional;

public interface UserRepository extends JpaRepository<User, Long> {
    Optional<User> findByPhone(String phone);
    Optional<User> findByUserId(String userId);
    boolean existsByPhone(String phone);
}
