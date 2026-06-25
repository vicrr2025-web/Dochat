package com.dochat.server.service;

import com.dochat.server.dto.PasswordChangeRequest;
import com.dochat.server.dto.PrivacyUpdateRequest;
import com.dochat.server.dto.ProfileResponse;
import com.dochat.server.dto.ProfileUpdateRequest;
import com.dochat.server.model.User;
import com.dochat.server.model.UserDevice;
import com.dochat.server.model.UserPrivacy;
import com.dochat.server.repository.UserDeviceRepository;
import com.dochat.server.repository.UserPrivacyRepository;
import com.dochat.server.repository.UserRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.*;
import java.util.stream.Collectors;

@Service
public class SettingsService {

    private static final Logger log = LoggerFactory.getLogger(SettingsService.class);

    private final UserRepository userRepository;
    private final UserDeviceRepository userDeviceRepository;
    private final UserPrivacyRepository userPrivacyRepository;
    private final BCryptPasswordEncoder passwordEncoder;

    public SettingsService(UserRepository userRepository,
                           UserDeviceRepository userDeviceRepository,
                           UserPrivacyRepository userPrivacyRepository,
                           BCryptPasswordEncoder passwordEncoder) {
        this.userRepository = userRepository;
        this.userDeviceRepository = userDeviceRepository;
        this.userPrivacyRepository = userPrivacyRepository;
        this.passwordEncoder = passwordEncoder;
    }

    public ProfileResponse getProfile(String userId) {
        User user = getUserForProfile(userId);
        ProfileResponse resp = new ProfileResponse();
        resp.setUserId(user.getUserId());
        resp.setNickname(user.getNickname());
        resp.setAvatar(user.getAvatar());
        resp.setEmail(user.getEmail());
        resp.setIsVerified(user.getIsVerified());
        resp.setCreditScore(user.getCreditScore());
        resp.setCreditLevel(user.getCreditLevel());
        return resp;
    }

    public ProfileResponse updateProfile(String userId, ProfileUpdateRequest request) {
        User user = getUserForProfile(userId);
        if (request.getNickname() != null) {
            user.setNickname(request.getNickname());
        }
        if (request.getAvatar() != null) {
            user.setAvatar(request.getAvatar());
        }
        userRepository.save(user);
        return getProfile(userId);
    }

    public void changePassword(String userId, PasswordChangeRequest request) {
        User user = getUserForProfile(userId);
        if (!passwordEncoder.matches(request.getOldPassword(), user.getPassword())) {
            throw new RuntimeException("当前密码错误");
        }
        user.setPassword(passwordEncoder.encode(request.getNewPassword()));
        userRepository.save(user);
    }

    public Map<String, Object> verifyIdentity(String userId, String realName, String idNumber, String faceId) {
        User user = getUserForProfile(userId);
        // MOCK: 70% success, 30% pending
        boolean success = Math.random() < 0.7;
        Map<String, Object> result = new HashMap<>();
        if (success) {
            user.setIsVerified(true);
            // Set creditLevel to "copper" on first verify
            if (!user.getIsVerified()) {
                user.setCreditLevel("铜牌");
            }
            userRepository.save(user);
            result.put("status", "success");
            result.put("message", "实名认证成功");
        } else {
            result.put("status", "pending");
            result.put("message", "审核中，请耐心等待");
        }
        return result;
    }

    public Map<String, Object> getVerifyStatus(String userId) {
        User user = getUserForProfile(userId);
        Map<String, Object> result = new HashMap<>();
        result.put("isVerified", user.getIsVerified());
        result.put("creditLevel", user.getCreditLevel());
        result.put("creditScore", user.getCreditScore());
        return result;
    }

    public List<Map<String, Object>> getDevices(String userId) {
        List<UserDevice> devices = userDeviceRepository.findByUserId(userId);
        return devices.stream().map(device -> {
            Map<String, Object> map = new HashMap<>();
            map.put("id", device.getId());
            map.put("deviceId", device.getDeviceId());
            map.put("deviceName", device.getDeviceName());
            map.put("deviceModel", device.getDeviceModel());
            map.put("osVersion", device.getOsVersion());
            map.put("isCurrent", device.isCurrent());
            map.put("lastActiveAt", device.getLastActiveAt().toString());
            map.put("createdAt", device.getCreatedAt().toString());
            return map;
        }).collect(Collectors.toList());
    }

    public void removeDevice(String deviceId) {
        UserDevice device = userDeviceRepository.findByDeviceId(deviceId)
                .orElseThrow(() -> new RuntimeException("设备不存在"));
        userDeviceRepository.delete(device);
    }

    public void removeOtherDevices(String userId, String currentDeviceId) {
        List<UserDevice> devices = userDeviceRepository.findByUserId(userId);
        for (UserDevice device : devices) {
            if (!device.getDeviceId().equals(currentDeviceId)) {
                userDeviceRepository.delete(device);
            }
        }
    }

    public Map<String, Object> getStorage(String userId) {
        // MOCK
        Map<String, Object> storage = new HashMap<>();
        storage.put("total", 128);
        storage.put("chat", 45);
        storage.put("images", 32);
        storage.put("videos", 28);
        storage.put("other", 23);
        return storage;
    }

    public Map<String, Object> getPrivacy(String userId) {
        UserPrivacy privacy = userPrivacyRepository.findByUserId(userId)
                .orElseGet(() -> {
                    UserPrivacy newPrivacy = new UserPrivacy();
                    newPrivacy.setUserId(userId);
                    return userPrivacyRepository.save(newPrivacy);
                });
        Map<String, Object> map = new HashMap<>();
        map.put("onlineVisibility", privacy.getOnlineVisibility());
        map.put("avatarVisibility", privacy.getAvatarVisibility());
        map.put("bioVisibility", privacy.getBioVisibility());
        map.put("messagePermission", privacy.getMessagePermission());
        return map;
    }

    public Map<String, Object> updatePrivacy(String userId, PrivacyUpdateRequest request) {
        UserPrivacy privacy = userPrivacyRepository.findByUserId(userId)
                .orElseGet(() -> {
                    UserPrivacy newPrivacy = new UserPrivacy();
                    newPrivacy.setUserId(userId);
                    return newPrivacy;
                });
        if (request.getOnlineVisibility() != null) {
            privacy.setOnlineVisibility(request.getOnlineVisibility());
        }
        if (request.getAvatarVisibility() != null) {
            privacy.setAvatarVisibility(request.getAvatarVisibility());
        }
        if (request.getBioVisibility() != null) {
            privacy.setBioVisibility(request.getBioVisibility());
        }
        if (request.getMessagePermission() != null) {
            privacy.setMessagePermission(request.getMessagePermission());
        }
        userPrivacyRepository.save(privacy);
        Map<String, Object> map = new HashMap<>();
        map.put("onlineVisibility", privacy.getOnlineVisibility());
        map.put("avatarVisibility", privacy.getAvatarVisibility());
        map.put("bioVisibility", privacy.getBioVisibility());
        map.put("messagePermission", privacy.getMessagePermission());
        return map;
    }

    public List<Map<String, Object>> getBlacklist(String userId) {
        // MOCK: return empty list
        return new ArrayList<>();
    }

    User getUserForProfile(String userId) {
        return userRepository.findByUserId(userId)
                .orElseThrow(() -> new RuntimeException("用户不存在"));
    }
}
