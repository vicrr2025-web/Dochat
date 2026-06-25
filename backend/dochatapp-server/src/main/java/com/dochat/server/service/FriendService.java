package com.dochat.server.service;

import com.dochat.server.dto.FriendRequestResponse;
import com.dochat.server.dto.FriendResponse;
import com.dochat.server.model.*;
import com.dochat.server.repository.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.*;
import java.util.stream.Collectors;

@Service
public class FriendService {

    private static final Logger log = LoggerFactory.getLogger(FriendService.class);

    private final UserRepository userRepository;
    private final FriendRepository friendRepository;
    private final FriendRequestRepository friendRequestRepository;
    private final SessionRepository sessionRepository;
    private final SessionMemberRepository sessionMemberRepository;

    public FriendService(UserRepository userRepository,
                         FriendRepository friendRepository,
                         FriendRequestRepository friendRequestRepository,
                         SessionRepository sessionRepository,
                         SessionMemberRepository sessionMemberRepository) {
        this.userRepository = userRepository;
        this.friendRepository = friendRepository;
        this.friendRequestRepository = friendRequestRepository;
        this.sessionRepository = sessionRepository;
        this.sessionMemberRepository = sessionMemberRepository;
    }

    public Map<String, Object> searchUser(String phone) {
        User user = userRepository.findByPhone(phone)
                .orElse(null);
        if (user == null) {
            throw new RuntimeException("3001:用户不存在");
        }
        Map<String, Object> result = new HashMap<>();
        result.put("userId", user.getUserId());
        result.put("avatar", user.getAvatar());
        result.put("nickname", user.getNickname());
        return result;
    }

    @Transactional
    public FriendRequestResponse sendRequest(String fromUserId, String toUserId, String message) {
        if (fromUserId.equals(toUserId)) {
            throw new RuntimeException("3009:不能对自己操作");
        }

        userRepository.findByUserId(toUserId)
                .orElseThrow(() -> new RuntimeException("3001:用户不存在"));

        // Check already friends
        Optional<Friend> existingFriend = friendRepository.findByUserIdAndFriendId(fromUserId, toUserId);
        if (existingFriend.isPresent()) {
            throw new RuntimeException("3002:好友关系已存在");
        }

        // Check blocked
        Optional<Friend> blockedCheck = friendRepository.findByUserIdAndFriendId(toUserId, fromUserId);
        if (blockedCheck.isPresent() && "blocked".equals(blockedCheck.get().getStatus())) {
            throw new RuntimeException("3005:已被对方拉黑");
        }

        // Check existing pending request
        Optional<FriendRequest> existingRequest = friendRequestRepository.findByFromUserIdAndToUserId(fromUserId, toUserId);
        if (existingRequest.isPresent() && "pending".equals(existingRequest.get().getStatus())) {
            throw new RuntimeException("3003:好友申请已发送");
        }

        FriendRequest request = new FriendRequest();
        request.setFromUserId(fromUserId);
        request.setToUserId(toUserId);
        request.setMessage(message);
        request.setStatus("pending");
        request = friendRequestRepository.save(request);

        log.info("Friend request sent: {} -> {}", fromUserId, toUserId);
        return toRequestResponse(request);
    }

    public List<FriendRequestResponse> getPendingRequests(String userId) {
        List<FriendRequest> requests = friendRequestRepository.findByToUserIdAndStatus(userId, "pending");
        return requests.stream()
                .map(this::toRequestResponse)
                .collect(Collectors.toList());
    }

    @Transactional
    public FriendRequestResponse acceptRequest(Long requestId, String userId) {
        FriendRequest request = friendRequestRepository.findById(requestId)
                .orElseThrow(() -> new RuntimeException("3004:好友申请不存在"));

        if (!"pending".equals(request.getStatus())) {
            throw new RuntimeException("好友申请已处理");
        }
        if (!request.getToUserId().equals(userId)) {
            throw new RuntimeException("无权操作该申请");
        }

        request.setStatus("accepted");
        friendRequestRepository.save(request);

        // Create bidirectional friend relationship
        Friend friend1 = new Friend();
        friend1.setUserId(request.getFromUserId());
        friend1.setFriendId(request.getToUserId());
        friend1.setStatus("accepted");
        friendRepository.save(friend1);

        Friend friend2 = new Friend();
        friend2.setUserId(request.getToUserId());
        friend2.setFriendId(request.getFromUserId());
        friend2.setStatus("accepted");
        friendRepository.save(friend2);

        // Auto-create chat session (single type)
        createChatSession(request.getFromUserId(), request.getToUserId());

        log.info("Friend request accepted: {} <-> {}", request.getFromUserId(), request.getToUserId());
        return toRequestResponse(request);
    }

    @Transactional
    public void rejectRequest(Long requestId) {
        FriendRequest request = friendRequestRepository.findById(requestId)
                .orElseThrow(() -> new RuntimeException("3004:好友申请不存在"));
        request.setStatus("rejected");
        friendRequestRepository.save(request);
        log.info("Friend request rejected: {}", requestId);
    }

    public List<FriendResponse> getFriends(String userId) {
        List<Friend> acceptedFriends = friendRepository.findByUserIdAndStatus(userId, "accepted");
        return acceptedFriends.stream()
                .map(f -> {
                    User friendUser = userRepository.findByUserId(f.getFriendId()).orElse(null);
                    FriendResponse resp = new FriendResponse();
                    resp.setUserId(f.getFriendId());
                    resp.setNickname(friendUser != null ? friendUser.getNickname() : "未知用户");
                    resp.setAvatar(friendUser != null ? friendUser.getAvatar() : null);
                    resp.setStatus(f.getStatus());
                    resp.setCreatedAt(f.getCreatedAt());
                    return resp;
                })
                .collect(Collectors.toList());
    }

    @Transactional
    public void removeFriend(String userId, String friendId) {
        Friend f1 = friendRepository.findByUserIdAndFriendId(userId, friendId)
                .orElseThrow(() -> new RuntimeException("3002:好友关系不存在"));
        friendRepository.delete(f1);

        Optional<Friend> f2 = friendRepository.findByUserIdAndFriendId(friendId, userId);
        f2.ifPresent(friendRepository::delete);

        log.info("Friend removed: {} <-> {}", userId, friendId);
    }

    private void createChatSession(String userId1, String userId2) {
        List<String> commonSessionIds = sessionMemberRepository.findCommonSessionIds(userId1, userId2);
        for (String sid : commonSessionIds) {
            Session s = sessionRepository.findBySessionId(sid).orElse(null);
            if (s != null && "single".equals(s.getType())) {
                return; // already exists
            }
        }

        User u2 = userRepository.findByUserId(userId2).orElse(null);
        String sessionId = "s_" + UUID.randomUUID().toString().replace("-", "").substring(0, 16);
        Session session = new Session();
        session.setSessionId(sessionId);
        session.setType("single");
        session.setName(u2 != null ? u2.getNickname() : "未知用户");
        session.setAvatar(u2 != null ? u2.getAvatar() : null);
        session.setLastTime(LocalDateTime.now());
        sessionRepository.save(session);

        SessionMember m1 = new SessionMember();
        m1.setSessionId(sessionId);
        m1.setUserId(userId1);
        sessionMemberRepository.save(m1);

        SessionMember m2 = new SessionMember();
        m2.setSessionId(sessionId);
        m2.setUserId(userId2);
        sessionMemberRepository.save(m2);
    }

    private FriendRequestResponse toRequestResponse(FriendRequest req) {
        User fromUser = userRepository.findByUserId(req.getFromUserId()).orElse(null);
        FriendRequestResponse resp = new FriendRequestResponse();
        resp.setRequestId(req.getId());
        resp.setFromUserId(req.getFromUserId());
        resp.setFromNickname(fromUser != null ? fromUser.getNickname() : "未知用户");
        resp.setFromAvatar(fromUser != null ? fromUser.getAvatar() : null);
        resp.setMessage(req.getMessage());
        resp.setStatus(req.getStatus());
        resp.setCreatedAt(req.getCreatedAt());
        return resp;
    }
}
