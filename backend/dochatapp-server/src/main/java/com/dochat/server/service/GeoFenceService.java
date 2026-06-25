package com.dochat.server.service;

import com.dochat.server.model.GeoFence;
import com.dochat.server.repository.GeoFenceRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class GeoFenceService {

    private static final Logger log = LoggerFactory.getLogger(GeoFenceService.class);
    private static final double EARTH_RADIUS = 6371000.0;

    private final GeoFenceRepository geoFenceRepository;
    private final StringRedisTemplate redisTemplate;
    private final LocationService locationService;

    public GeoFenceService(GeoFenceRepository geoFenceRepository,
                           StringRedisTemplate redisTemplate,
                           LocationService locationService) {
        this.geoFenceRepository = geoFenceRepository;
        this.redisTemplate = redisTemplate;
        this.locationService = locationService;
    }

    public GeoFence createFence(String userId, String name, double lat, double lng,
                                int radius, String targetUserId) {
        GeoFence fence = new GeoFence();
        fence.setUserId(userId);
        fence.setName(name);
        fence.setLatitude(lat);
        fence.setLongitude(lng);
        fence.setRadius(radius);
        fence.setTargetUserId(targetUserId);
        fence.setIsActive(true);
        return geoFenceRepository.save(fence);
    }

    public List<GeoFence> getFences(String userId) {
        return geoFenceRepository.findByUserId(userId);
    }

    public void deleteFence(Long fenceId, String userId) {
        GeoFence fence = geoFenceRepository.findById(fenceId)
                .orElseThrow(() -> new RuntimeException("3007:电子围栏不存在"));
        if (!fence.getUserId().equals(userId)) {
            throw new RuntimeException("3002:无操作权限");
        }
        geoFenceRepository.delete(fence);
        log.info("Geo-fence deleted: {}", fenceId);
    }

    @Scheduled(cron = "0 * * * * ?")
    public void checkFenceAlerts() {
        List<GeoFence> activeFences = geoFenceRepository.findAll().stream()
                .filter(GeoFence::getIsActive)
                .toList();

        for (GeoFence fence : activeFences) {
            try {
                var targetLocation = locationService.getCurrentLocation(fence.getTargetUserId());
                if (targetLocation == null) continue;

                double lat = targetLocation.getLatitude();
                double lng = targetLocation.getLongitude();
                double distance = haversine(fence.getLatitude(), fence.getLongitude(), lat, lng);

                if (distance > fence.getRadius()) {
                    String alert = String.format(
                            "{\"type\":\"geofence_alert\",\"fenceId\":%d,\"fenceName\":\"%s\",\"targetUserId\":\"%s\",\"distance\":%.0f,\"radius\":%d}",
                            fence.getId(), fence.getName(), fence.getTargetUserId(), distance, fence.getRadius());
                    redisTemplate.convertAndSend("alert:geofence", alert);
                    log.info("Geo-fence alert: {} is out of bounds (distance: {}m, radius: {}m)",
                            fence.getTargetUserId(), (int) distance, fence.getRadius());
                }
            } catch (Exception e) {
                log.debug("Skipping fence check for {}: {}", fence.getId(), e.getMessage());
            }
        }
    }

    private double haversine(double lat1, double lon1, double lat2, double lon2) {
        double dLat = Math.toRadians(lat2 - lat1);
        double dLon = Math.toRadians(lon2 - lon1);
        double a = Math.sin(dLat / 2) * Math.sin(dLat / 2)
                + Math.cos(Math.toRadians(lat1)) * Math.cos(Math.toRadians(lat2))
                * Math.sin(dLon / 2) * Math.sin(dLon / 2);
        double c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
        return EARTH_RADIUS * c;
    }
}
