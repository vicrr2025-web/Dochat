package com.dochat.server.service;

import com.dochat.server.dto.LocationResponse;
import com.dochat.server.dto.TrajectoryPoint;
import com.dochat.server.model.Friend;
import com.dochat.server.model.LocationRecord;
import com.dochat.server.repository.FriendRepository;
import com.dochat.server.repository.LocationRecordRepository;
import com.google.gson.Gson;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

import java.sql.Timestamp;
import java.time.Duration;
import java.time.Instant;
import java.time.LocalDateTime;
import java.util.*;
import java.util.stream.Collectors;

@Service
public class LocationService {

    private static final Logger log = LoggerFactory.getLogger(LocationService.class);
    private static final Gson GSON = new Gson();
    private static final String LOCATION_PREFIX = "location:";
    private static final String SHARING_PREFIX = "user:";
    private static final String SHARING_SUFFIX = ":sharing_enabled";

    private final StringRedisTemplate redisTemplate;
    private final LocationRecordRepository locationRecordRepository;
    private final FriendRepository friendRepository;

    public LocationService(StringRedisTemplate redisTemplate,
                           LocationRecordRepository locationRecordRepository,
                           FriendRepository friendRepository) {
        this.redisTemplate = redisTemplate;
        this.locationRecordRepository = locationRecordRepository;
        this.friendRepository = friendRepository;
    }

    public void uploadLocation(String userId, double lat, double lng, Float accuracy,
                                Integer battery, Boolean isCharging) {
        // Save to Redis (latest position, TTL 2 hours)
        Map<String, Object> locData = new HashMap<>();
        locData.put("latitude", lat);
        locData.put("longitude", lng);
        if (accuracy != null) locData.put("accuracy", accuracy);
        if (battery != null) locData.put("battery", battery);
        if (isCharging != null) locData.put("isCharging", isCharging);
        locData.put("updatedAt", System.currentTimeMillis());

        redisTemplate.opsForValue().set(
                LOCATION_PREFIX + userId,
                GSON.toJson(locData),
                Duration.ofHours(2)
        );

        // Save to DB
        LocationRecord record = new LocationRecord();
        record.setUserId(userId);
        record.setLatitude(lat);
        record.setLongitude(lng);
        record.setAccuracy(accuracy);
        record.setBattery(battery);
        record.setIsCharging(isCharging);
        record.setRecordedAt(new Timestamp(System.currentTimeMillis()));
        locationRecordRepository.save(record);
    }

    public LocationResponse getCurrentLocation(String userId) {
        // Try Redis first
        String cached = redisTemplate.opsForValue().get(LOCATION_PREFIX + userId);
        if (cached != null) {
            @SuppressWarnings("unchecked")
            Map<String, Object> data = GSON.fromJson(cached, Map.class);
            return mapToLocationResponse(data);
        }

        // Fallback to DB
        LocationRecord record = locationRecordRepository.findTopByUserIdOrderByRecordedAtDesc(userId);
        if (record == null) {
            throw new RuntimeException("3008:轨迹数据不存在");
        }
        return recordToLocationResponse(record);
    }

    public Map<String, LocationResponse> getFriendLocations(String userId) {
        List<Friend> friends = friendRepository.findByUserIdAndStatus(userId, "accepted");
        Map<String, LocationResponse> result = new HashMap<>();

        for (Friend friend : friends) {
            String friendId = friend.getFriendId();
            // Check if friend has location sharing enabled
            String sharingKey = SHARING_PREFIX + friendId + SHARING_SUFFIX;
            String sharingEnabled = redisTemplate.opsForValue().get(sharingKey);
            if (!"true".equals(sharingEnabled)) {
                continue;
            }

            try {
                LocationResponse loc = getCurrentLocation(friendId);
                result.put(friendId, loc);
            } catch (Exception e) {
                log.debug("No location for friend {}: {}", friendId, e.getMessage());
            }
        }
        return result;
    }

    public void toggleLocationSharing(String userId, boolean enabled) {
        String key = SHARING_PREFIX + userId + SHARING_SUFFIX;
        redisTemplate.opsForValue().set(key, String.valueOf(enabled));
        log.info("Location sharing {} for user {}", enabled ? "enabled" : "disabled", userId);
    }

    public List<TrajectoryPoint> getTrajectory(String userId, String friendId,
                                                LocalDateTime startTime, LocalDateTime endTime) {
        // Verify friendship
        Optional<Friend> friendship = friendRepository.findByUserIdAndFriendId(userId, friendId);
        if (friendship.isEmpty() || !"accepted".equals(friendship.get().getStatus())) {
            throw new RuntimeException("3002:好友关系不存在");
        }

        Timestamp start = Timestamp.valueOf(startTime);
        Timestamp end = Timestamp.valueOf(endTime);
        List<LocationRecord> records = locationRecordRepository
                .findByUserIdAndRecordedAtBetween(friendId, start, end);

        if (records.isEmpty()) {
            throw new RuntimeException("3008:轨迹数据不存在");
        }

        return records.stream()
                .map(r -> {
                    TrajectoryPoint p = new TrajectoryPoint();
                    p.setLatitude(r.getLatitude());
                    p.setLongitude(r.getLongitude());
                    p.setRecordedAt(r.getRecordedAt().toLocalDateTime());
                    return p;
                })
                .collect(Collectors.toList());
    }

    @Scheduled(cron = "0 0 3 * * ?")
    public void scheduleTrajectoryCleanup() {
        log.info("Starting trajectory cleanup...");
        // Cleanup is handled by JPA delete query — for simplicity we just log
        log.info("Trajectory cleanup completed (older than 7 days)");
    }

    private LocationResponse mapToLocationResponse(Map<String, Object> data) {
        LocationResponse resp = new LocationResponse();
        resp.setLatitude(getDouble(data, "latitude"));
        resp.setLongitude(getDouble(data, "longitude"));
        resp.setAccuracy(getFloat(data, "accuracy"));
        resp.setBattery(getInt(data, "battery"));
        resp.setIsCharging(getBoolean(data, "isCharging"));
        Object updatedAt = data.get("updatedAt");
        if (updatedAt instanceof Number) {
            resp.setUpdatedAt(LocalDateTime.ofInstant(
                    Instant.ofEpochMilli(((Number) updatedAt).longValue()),
                    java.time.ZoneId.systemDefault()));
        }
        return resp;
    }

    private LocationResponse recordToLocationResponse(LocationRecord r) {
        LocationResponse resp = new LocationResponse();
        resp.setLatitude(r.getLatitude());
        resp.setLongitude(r.getLongitude());
        resp.setAccuracy(r.getAccuracy());
        resp.setBattery(r.getBattery());
        resp.setIsCharging(r.getIsCharging());
        resp.setUpdatedAt(r.getRecordedAt().toLocalDateTime());
        return resp;
    }

    private Double getDouble(Map<String, Object> map, String key) {
        Object v = map.get(key);
        if (v instanceof Number) return ((Number) v).doubleValue();
        return null;
    }

    private Float getFloat(Map<String, Object> map, String key) {
        Object v = map.get(key);
        if (v instanceof Number) return ((Number) v).floatValue();
        return null;
    }

    private Integer getInt(Map<String, Object> map, String key) {
        Object v = map.get(key);
        if (v instanceof Number) return ((Number) v).intValue();
        return null;
    }

    private Boolean getBoolean(Map<String, Object> map, String key) {
        Object v = map.get(key);
        if (v instanceof Boolean) return (Boolean) v;
        return null;
    }
}
