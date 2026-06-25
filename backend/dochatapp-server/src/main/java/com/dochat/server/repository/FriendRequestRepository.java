package com.dochat.server.repository;

import com.dochat.server.model.FriendRequest;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface FriendRequestRepository extends JpaRepository<FriendRequest, Long> {
    List<FriendRequest> findByToUserIdAndStatus(String toUserId, String status);
    Optional<FriendRequest> findByFromUserIdAndToUserId(String fromUserId, String toUserId);
}
