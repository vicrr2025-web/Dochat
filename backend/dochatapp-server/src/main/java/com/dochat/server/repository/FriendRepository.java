package com.dochat.server.repository;

import com.dochat.server.model.Friend;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface FriendRepository extends JpaRepository<Friend, Long> {
    List<Friend> findByUserId(String userId);
    Optional<Friend> findByUserIdAndFriendId(String userId, String friendId);
    List<Friend> findByUserIdAndStatus(String userId, String status);
}
